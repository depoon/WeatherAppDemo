//
//  City.h
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistentManager.h"
#import "DateUtils.h"

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * iconURL;
@property (nonatomic, retain) NSString * observationTime;
@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * weatherDesc;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * timeStamp;

@end
