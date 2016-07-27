//
//  PersistentManager.h
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, PersistentStoreType) {
    PersistentStoreTypeNSUserDefault = 1,
    PersistentStoreTypeCoreData
};

typedef NS_ENUM(NSInteger, CoreDataType) {
    CoreDataTypeSQL = 1,
    CoreDataTypeBinary,
    CoreDataTypeMemory
};

@interface PersistentManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (PersistentManager *)sharedInstance;
+ (NSManagedObjectContext *)managedObjectContext;
+ (void)saveContext ;
+ (NSString *)databaseFilename;
+ (NSURL *)defaultStoreURL;
+ (NSURL *)libraryDirectoryURL;
@end
