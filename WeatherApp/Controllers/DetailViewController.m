//
//  DetailViewController.m
//  WeatherApp
//
//  Created by Soheil on 11/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import "DetailViewController.h"
@import AFNetworking;
//#import <UIImageView+AFNetworking.h>
#import "DateUtils.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *observationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@end

static const NSInteger requireForUpdateTime = 1800; // 30 minutes

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Adding title to navigation bar
    self.navigationItem.title = @"Weather Forecast";
    
    // Updating View
    [self updateView];
    
    // setting up the UIRefresh controller
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // check for last updated date
    [self lastUpdateDate];
    
    [self.view setAccessibilityIdentifier: @"WeatherDetailsPage"];
}

-(void)lastUpdateDate{
    if([DateUtils isTimeIntervalSince:[_cityObject valueForKeyPath:@"timeStamp"] biggerThan:requireForUpdateTime]){
        // needs to update again
        [self.refreshControl beginRefreshing];
        [self performSelector:@selector(refresh:) withObject:nil afterDelay:0];
        
        if (self.tableView.contentOffset.y == 0) {
            [UIView animateWithDuration:0.25 animations:^{
                CGFloat refreshControlHeight = self.refreshControl.frame.size.height;
                self.tableView.contentOffset = CGPointMake(0, -refreshControlHeight);
            }];
        }
    }
}

-(void)setCityObject:(id)newCityObject
{
    if (_cityObject != newCityObject)
    {
        _cityObject = newCityObject;
        [self updateView];
    }
}

-(void)updateView {
    self.cityNameLabel.text = [_cityObject valueForKeyPath:@"name"];
    self.observationTimeLabel.text = [_cityObject valueForKeyPath:@"observationTime"];
    self.humidityLabel.text = [_cityObject valueForKeyPath:@"humidity"];
    self.weatherDescLabel.text = [_cityObject valueForKeyPath:@"weatherDesc"];

    NSDate *weatherDate = (NSDate *)[_cityObject valueForKeyPath:@"date"];
    self.dateLabel.text = [[DateUtils sharedUtils]showDateInFormat:weatherDate stringFormat:@"dd-MMM-yyyy"];
    
    // setting image URL
    [self.imageView setImageWithURL:[NSURL URLWithString:[self.cityObject valueForKeyPath:@"iconURL"]]];
    [self.tableView reloadData];
}

// Footer in table is only use for indicating last updated time
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(!self.cityObject){
        return nil;
    }
 
    NSString *dateString = [[DateUtils sharedUtils]showDateInFormat:[self.cityObject valueForKeyPath:@"timeStamp"]
                                                       stringFormat:@"dd-MMM-yyyy HH:mm:SS"];
    
    return [NSString stringWithFormat:@"Updated Time: %@",dateString];
}

#pragma mark - Refresh controller
- (void)refresh:(UIRefreshControl *)refreshControl {

    __weak __typeof(self)weakSelf = self;
    WeatherRequestApi *api = [[WeatherRequestApi alloc]initWithCallback:^(NSDictionary *dict, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!error) {
            
            [strongSelf.refreshControl endRefreshing];
            // Inserting to persistent Data
            strongSelf.cityObject = [City getCityWithDictionary:dict];
            [PersistentManager saveContext];
            [strongSelf updateView];
        }
    } withSearchKeyword:self.cityNameLabel.text];
    [api execute];
}


@end
