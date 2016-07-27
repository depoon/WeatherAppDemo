//
//  City+Create.m
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import "City+Create.h"
@implementation City (Create)

+(City *)getCityWithDictionary:(NSDictionary *)dict{
    City *city = nil;
    
    NSString *name;
    NSString *humidity;
    NSString *observationTime;
    NSString *weatherDesc;
    NSString *iconURL;
    NSDate   *date;
    
    NSManagedObjectContext *context = [PersistentManager managedObjectContext];
    
    // Finding the key and value from dict
    humidity = [[dict valueForKeyPath:@"current_condition.humidity"] firstObject] ;
    observationTime = [[dict valueForKeyPath:@"current_condition.observation_time"] firstObject];
    weatherDesc = [[[[dict valueForKeyPath:@"current_condition.weatherDesc"] firstObject] valueForKey:@"value"] firstObject];
    iconURL = [[[[dict valueForKeyPath:@"current_condition.weatherIconUrl"] firstObject] valueForKey:@"value"] firstObject];

    name = [[dict valueForKeyPath:@"request.query"] firstObject];
    
    NSString *dateString = [[dict valueForKeyPath:@"weather.date"] firstObject];
    date = [[DateUtils sharedUtils]getDateFromString:dateString];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if(!matches || error || [matches count] > 1){
        // should handle error
    }else if ([matches count]){
        // update the value in database
        city = [matches firstObject];
        
        [city setValue:observationTime forKey:@"observationTime"];
        [city setValue:humidity forKey:@"humidity"];
        [city setValue:weatherDesc forKey:@"weatherDesc"];
        [city setValue:iconURL forKey:@"iconURL"];
        [city setValue:date forKey:@"date"];
        [city setValue:[NSDate date] forKey:@"timeStamp"];
    }else {
        city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
        city.name = name;
        city.humidity = humidity;
        city.observationTime = observationTime;
        city.weatherDesc = weatherDesc;
        city.iconURL = iconURL;
        city.date = date ;
        city.timeStamp = [NSDate date];
    }
    
    return city;
}

+(NSArray *)getAllCities{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    request.predicate = nil;
    request.fetchLimit = 10;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO]];
    NSManagedObjectContext *context = [PersistentManager managedObjectContext];
    
    NSError *error ;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    return matches;
}

+(NSArray *)getAllCitiesWithFilter:(NSString *)keyword{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",keyword];
    NSManagedObjectContext *context = [PersistentManager managedObjectContext];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    return matches;
}

@end
