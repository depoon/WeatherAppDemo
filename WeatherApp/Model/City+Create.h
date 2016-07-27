//
//  City+Create.h
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import "City.h"

@interface City (Create)
+(City *)getCityWithDictionary:(NSDictionary *)dict;
+(NSArray *)getAllCities;
+(NSArray *)getAllCitiesWithFilter:(NSString *)keyword;
@end
