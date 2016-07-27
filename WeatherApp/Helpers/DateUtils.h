//
//  DateUtils.h
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject
+ (DateUtils *)sharedUtils;
- (NSDate *)getDateFromString:(NSString *)dateStr;
- (NSString *)showDateInFormat:(NSDate *)date stringFormat:(NSString *)string;
+ (BOOL)isTimeIntervalSince:(NSDate *)givenDate biggerThan:(NSInteger)seconds;
@end
