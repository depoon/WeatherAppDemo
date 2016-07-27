//
//  WeatherRequestApi.h
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import <Foundation/Foundation.h>


//typedef void (^RequestApiCallback)(Offer *offer,NSArray *chats, NSError *error);

typedef void (^WeatherRequestApiCallback)(NSDictionary *dictionary, NSError *error);

@interface WeatherRequestApi : NSObject
- (instancetype)initWithCallback:(WeatherRequestApiCallback)callback withSearchKeyword:(NSString *)keyword;
- (void)execute;
- (void) cancelOperation;
@end
