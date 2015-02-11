//
//  CoreDataStack.m
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/11/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import "CoreDataStack.h"
#import "Hotel.h"
#import "Room.h"

@interface CoreDataStack()

@property (nonatomic) BOOL isTesting;

@end

@implementation CoreDataStack

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(instancetype)initForTesting {
  self = [super init];
  if (self) {
    self.isTesting = true;
  }
  return self;
}

-(void)seedDataBaseIfNeeded {
  NSFetchRequest *fetchRequest  = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *fetchError;
  
  NSInteger results = [self.managedObjectContext countForFetchRequest:fetchRequest error:&fetchError];
  NSLog(@"%ld", (long)results);
  if (results == 0) {
    NSURL *seedURL = [[NSBundle mainBundle] URLForResource:@"seed" withExtension:@"json"];
    NSData *seedData = [[NSData alloc] initWithContentsOfURL:seedURL];
    NSError *JsonError;
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:seedData options:0 error:&JsonError];
    
    if (!JsonError) {
      NSArray *jsonArray = rootDictionary[@"Hotels"];
      
      for (NSDictionary *HotelDictionary in jsonArray) {
        Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
        hotel.name = HotelDictionary[@"name"];
        hotel.location = HotelDictionary[@"location"];
        hotel.rating = HotelDictionary[@"stars"];
        
        NSArray *roomsArray = HotelDictionary[@"rooms"];
        for (NSDictionary *roomsDictioary in roomsArray) {
          Room *room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.managedObjectContext];
          room.number = roomsDictioary[@"number"];
          room.beds = roomsDictioary[@"beds"];
          room.rate = roomsDictioary[@"rate"];
          room.hotel = hotel;
        }
      }
      NSError *saveError;
      [self.managedObjectContext save:&saveError];
      
      if (saveError) {
        NSLog(@"%@", saveError.localizedDescription);
      }
    }
  }
}

- (NSURL *)applicationDocumentsDirectory {
  // The directory the application uses to store the Core Data store file. This code uses a directory named "sexy.royachoga.BookRoomRealEasy" in the application's documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
  // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BookRoomRealEasy" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  // Create the coordinator and store
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BookRoomRealEasy.sqlite"];
  NSError *error = nil;
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  NSString *storeType;
  if (self.isTesting) {
    storeType = NSInMemoryStoreType;
  } else {
    storeType = NSSQLiteStoreType;
  }
  
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc] init];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    NSError *error = nil;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}


@end
