//
//  City+CreateTest.m
//  WeatherApp
//
//  Created by Soheil on 20/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

//
//  WeatherReqeustApiTest.m
//  WeatherApp
//
//  Created by Soheil on 13/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kiwi.h"
#import "City+Create.h"

SPEC_BEGIN(CityCreateTes)

describe(@"Mocking City Model", ^{
    __block NSDictionary *json;
    __block NSManagedObjectContext *managedContext;
    __block City *city;
    
    beforeAll(^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FixtureRequest_OK" ofType:@"json"];
        NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSError *error =  nil;
        NSDictionary *jsonResponce = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        json = jsonResponce[@"data"];
        
        managedContext = [[PersistentManager sharedInstance]managedObjectContext];

        // Removing core data file from system.
        // Testing Core data is easier to be done using in memory management rather than removing file
        NSPersistentStore * store = [[managedContext.persistentStoreCoordinator persistentStores] lastObject];
        [managedContext.persistentStoreCoordinator removePersistentStore:store error:&error];
        [[NSFileManager defaultManager] removeItemAtURL:[store URL] error:&error];
    });
    
    context(@"Checking if any Data is in Core data", ^{
        it(@"Core data should not have any data for city entity", ^{
            NSArray *cities = [City getAllCities];
            [[theValue(cities.count) should] equal:theValue(0)];
        });
    });
    
    context(@"Checking json file if it is added to core data", ^{
        beforeEach(^{
            city = [City getCityWithDictionary:json];
        });
        
        it(@"Checking if the json is added to core data", ^{
            [[city.name should] equal:@"Singapore, Singapore"];
            [[city.humidity should] equal:@"75"];
            [[city.weatherDesc should] equal:@"Partly Cloudy"];
        });
        
        it(@"Second check to see if the same data exist", ^{
            City *newCity = [City getCityWithDictionary:json];
            [[newCity should] equal:city];
            [[newCity.name should] equal:city.name];
        });
        
        it(@"Check to see if the keyword exists in Core data", ^{
            NSArray *cities = [City getAllCitiesWithFilter:@"Singapore"];
            
            [[theValue(cities.count) should] equal:theValue(1)];
        });
    });
});

SPEC_END

