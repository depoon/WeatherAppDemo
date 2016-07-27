//
//  PersistentManager.m
//  WeatherApp
//
//  Created by Soheil on 12/5/15.
//  Copyright (c) 2015 Soheil. All rights reserved.
//

#import "PersistentManager.h"

NSString * const kModelName = @"Model";
NSInteger const kCoreDataType = CoreDataTypeSQL;

@implementation PersistentManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (PersistentManager *)sharedInstance
{
    static PersistentManager *_sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *storeURL = [PersistentManager defaultStoreURL];
        _persistentStoreCoordinator = [self persistentStoreCoordinatorWithModel:self.managedObjectModel
                                                                         andURL:storeURL];
    }
    return self;
}

+ (NSString *)databaseFilename
{
    return [kModelName stringByAppendingPathExtension:@"sqlite"];
}

+ (NSURL *)defaultStoreURL
{
    return [[self libraryDirectoryURL] URLByAppendingPathComponent:[self databaseFilename]];
}

+ (NSURL *)libraryDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *defaultContext = [[PersistentManager sharedInstance] managedObjectContext];
    return defaultContext;
}

+ (void)saveContext {
    NSManagedObjectContext *managedObjectContext = [PersistentManager managedObjectContext];
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}


// initializing MOC, MOM, PSC
- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        if (_persistentStoreCoordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kModelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithModel:(NSManagedObjectModel *)managedObjectModel andURL:(NSURL *)storeURL
{
    NSError *error = nil;
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSString *storeType = nil;
    
    switch (kCoreDataType) {
        case CoreDataTypeBinary:
            storeType = NSBinaryStoreType;
            break;
        case CoreDataTypeMemory:
            storeType = NSInMemoryStoreType;
            break;
        default:
            storeType = NSSQLiteStoreType;
            break;
    }
    
    [persistentStoreCoordinator addPersistentStoreWithType:storeType
                                             configuration:nil
                                                       URL:storeURL
                                                   options:options
                                                     error:&error];
    
    if (!persistentStoreCoordinator || persistentStoreCoordinator.persistentStores.count == 0) {
        NSLog(@"Error: %@", error);
        NSLog(@"unable to load Database");
    }
    
    return persistentStoreCoordinator;
}

@end
