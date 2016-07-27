//
//  DateUtils.m
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import "DateUtils.h"

@interface DateUtils()
@property(strong,nonatomic) NSDateFormatter *dateFormat;
@end

@implementation DateUtils
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormat = [[NSDateFormatter alloc] init];
    }
    return self;
}

+ (DateUtils *)sharedUtils{
    static dispatch_once_t pred = 0;
    __strong static id _sharedUtils = nil;
    dispatch_once(&pred, ^{
        _sharedUtils = [[self alloc] init];
    });
    return _sharedUtils;
}

- (NSDate *)getDateFromString:(NSString *)dateStr
{
    // Convert string to date object
    [self.dateFormat setDateFormat:@"yyyy'-'MM'-'dd'"];
    NSDate *date = [self.dateFormat dateFromString:dateStr];
    
    return date;
}

- (NSString *)showDateInFormat:(NSDate *)date stringFormat:(NSString *)string{
    [self.dateFormat setDateFormat:string];
    return [self.dateFormat stringFromDate:date];
}

+ (BOOL)isTimeIntervalSince:(NSDate *)givenDate biggerThan:(NSInteger)seconds{
    NSDate *currentTime = [NSDate date];
    
    if ([currentTime timeIntervalSinceDate:givenDate] > seconds)
    {
        return YES;
    }
    
    return NO;
}

@end
