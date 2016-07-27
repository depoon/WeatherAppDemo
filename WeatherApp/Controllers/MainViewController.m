//
//  ViewController.m
//  WeatherApp
//
//  Created by Soheil on 11/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MainViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *arrayCities;
@property (strong, nonatomic) NSMutableArray *filteredCities;
@property (strong, nonatomic) WeatherRequestApi *api;
@property (strong, nonatomic) id searchedCity;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleAlignmentConstraint;
@end

static const CGFloat LEFT_RIGHT_MARGIN = 50;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultPosition];
    [self updateListArray];
    [self.view setAccessibilityIdentifier: @"WeatherSearchPage"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.searchedCity = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self defaultPosition];
    [self setupObservers];
    
    if([self.searchBar.text length]){
        [self updateListArray];
    }
}

- (void)defaultPosition {
    CGFloat screenHeight =  [UIScreen mainScreen].bounds.size.height ;
    CGFloat searchBarHeight =  self.searchBar.frame.size.height;
    CGFloat topMidHeight =  (screenHeight/2) - (searchBarHeight);
    
    self.topLayoutConstraint.constant = topMidHeight;
    self.leftLayoutConstraint.constant = LEFT_RIGHT_MARGIN;
    self.rightLayoutConstraint.constant = LEFT_RIGHT_MARGIN;
    self.searchBar.barTintColor = [UIColor whiteColor];

    CGFloat middleTopAlignment  = (topMidHeight/2) ;

    self.middleAlignmentConstraint.constant = middleTopAlignment;
    self.welcomeLabel.alpha = 1;
    self.tableView.alpha = 0;
}

- (void)setupObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOrientationDidChandeNote:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                                  object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)updateListArray{
     self.arrayCities = [[City getAllCities] mutableCopy];
    
    if([self.arrayCities count] > 0){
        if([self.searchBar.text length]){
            [self searchBar:self.searchBar textDidChange:self.searchBar.text];
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark - Segue
- (void)pushToDetailViewController{
    [self.navigationController setNavigationBarHidden:NO animated:YES];;
    [self performSegueWithIdentifier:@"showForcastDetailSgue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showForcastDetailSgue"])
    {
        // Get reference to the destination view controller
        DetailViewController *vc = [segue destinationViewController];
        vc.cityObject = self.searchedCity;
    }
}

#pragma mark - Keyboad Show and Hide
-(void)keyboardWillShow:(NSNotification *)notification {
    if(self.topLayoutConstraint.constant == 0){
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration = userInfo?[[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]:0.3;
    NSInteger curve = userInfo?[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]:1 ;
    
    self.topLayoutConstraint.constant = 0;
    self.leftLayoutConstraint.constant = 0;
    self.rightLayoutConstraint.constant = 0;
    self.middleAlignmentConstraint.constant += self.middleAlignmentConstraint.constant * 1.5;
    
    [UIView animateWithDuration:animationDuration delay:0 options:curve animations:^{
        [self.view layoutIfNeeded];
        [self.searchBar setShowsCancelButton:YES animated:YES];
        self.welcomeLabel.alpha = 0;
        
        if([self.arrayCities count] > 0){
            self.tableView.alpha = 1;
        }
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    if(self.topLayoutConstraint.constant != 0){
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration = userInfo?[[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]:0.3;
    NSInteger curve = userInfo?[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]:1 ;
    
    [self defaultPosition];
    [UIView animateWithDuration:animationDuration delay:0 options:curve animations:^{
        [self.view layoutIfNeeded];
        [self.searchBar setShowsCancelButton:NO animated:YES];
    } completion:NULL];
}

#pragma mark - UISearchBar Delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self keyboardWillShow:nil];    // This is only for simulator when the keyboard toggle is off
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self keyboardWillHide:nil];   // This is only for simulator when the keyboard toggle is off
    
    searchBar.text = nil;
    [self.api cancelOperation];
    [self showOrHideProgress:NO];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self requestToLoadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(!_arrayCities || ([_arrayCities count] == 0)){
        return;
    }
    
    self.filteredCities = [[City getAllCitiesWithFilter:searchText] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.searchBar.text length] > 0){
        return [self.filteredCities count];
    }else{
        return [self.arrayCities count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    City *city;
    
    if([self.searchBar.text length] > 0){
        city = [self.filteredCities objectAtIndex:indexPath.row];
    }else{
        city = [self.arrayCities objectAtIndex:indexPath.row];
    }
    
    if(city){
        cell.textLabel.text = city.name;   
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    City *city = [self.arrayCities objectAtIndex:indexPath.row];
    self.searchedCity = city;
    [self pushToDetailViewController];
}

#pragma mark - Device Orientation changes
- (void)handleOrientationDidChandeNote:(NSNotification *)notification{
    [self defaultPosition];
}

#pragma mark - API
-(void)requestToLoadData {
    NSString *searchBarTrimedString = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    __weak __typeof(self)weakSelf = self;
    self.api = [[WeatherRequestApi alloc]initWithCallback:^(NSDictionary *dict, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (error) {
            [strongSelf showOrHideProgress:NO];
            
            NSString *msg;
            
            if([error.domain isEqualToString:@"WEATHER_CUSTOM_MESSAGE_ERROR"]){
                msg = error.userInfo[@"message"];
            }else if ([error.domain isEqualToString:@"NSURLErrorDomain"]){
                // The operation has been cancelled. Thus this is not an unexpected error.
                return;
            }
            else{
                msg = @"An error occured!";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            // Inserting to persistent Data
            strongSelf.searchedCity = [City getCityWithDictionary:dict];
            [PersistentManager saveContext];
            [strongSelf updateListArray];
            
            // send to detail screen
            [strongSelf showOrHideProgress:NO];
            [strongSelf pushToDetailViewController];
        }
    } withSearchKeyword:searchBarTrimedString];
    [self.api cancelOperation];
    
    if([searchBarTrimedString length] < 3){
        return;
    }
    
    [self showOrHideProgress:YES];
    [self.api execute];
}

#pragma mark - show or hide Progress 
-(void)showOrHideProgress:(BOOL)status{
    UIView *view;
    view = [self.view viewWithTag:1];
    
    if(status == YES){
        if(!view){
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat topPosition = self.searchBar.frame.size.height;
            CGFloat halfScreenHeight = ([UIScreen mainScreen].bounds.size.height / 1.5) - topPosition;
            
            view = [[UIView alloc]initWithFrame:CGRectMake(0, topPosition, screenWidth, halfScreenHeight)];
            view.backgroundColor = [UIColor clearColor];
            view.tag = 1;
            
            [self.view addSubview:view];
            
            [MBProgressHUD showHUDAddedTo:view animated:YES];
        }
    }else {
        if(view){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [view removeFromSuperview];
        }
    }
}

@end
