//
//  DetailViewController.h
//  WeatherApp
//
//  Created by Soheil on 11/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherRequestApi.h"
#import "PersistentManager.h"
#import "City+Create.h"

@interface DetailViewController : UITableViewController
@property(nonatomic,strong) id cityObject;
@end
