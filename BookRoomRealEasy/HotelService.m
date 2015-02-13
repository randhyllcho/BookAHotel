//
//  HotelService.m
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/11/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import "HotelService.h"


@implementation HotelService

+(id)sharedService {
  static HotelService *mySharedService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    mySharedService = [[self alloc] init];
  });
  return mySharedService;
}

-(instancetype)init {
  self = [super init];
  if (self) {
    self.coreDataStack = [[CoreDataStack alloc] init];
  }
  return self;
}

-(instancetype)initForTesting {
  self = [super init];
  if (self) {
    self.coreDataStack =[[CoreDataStack alloc] initForTesting];
  }
  return self;
}

-(Reservation *) bookReservationForGuest:(Guest *)guest ForRoom:(Room *)room checkIn:(NSDate *)checkIn checkOut:(NSDate *)checkOut {
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  
  reservation.checkIn = checkIn;
  reservation.checkOut = checkOut;
  reservation.room = room;
  reservation.guest = guest;
  
  NSError *saveError;
  [self.coreDataStack.managedObjectContext save:&saveError];
  if (!saveError) {
    return reservation;
  } else {
    return nil;
  }
  
}

@end
