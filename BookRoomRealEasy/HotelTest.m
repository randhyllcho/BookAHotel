//
//  HotelTest.m
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/11/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HotelService.h"
#import "Hotel.h"
#import "Room.h"
#import "Guest.h"


@interface HotelTest : XCTestCase

@property(strong, nonatomic) HotelService *hotelService;
@property(strong, nonatomic) Hotel *hotel;
@property(strong, nonatomic) Room *room;
@property(strong, nonatomic) Guest *guest;

@end

@implementation HotelTest


- (void)setUp {
    [super setUp];
  
  self.hotelService = [[HotelService alloc] initForTesting];
  self.hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
  self.hotel.name = @"An Place";
  self.hotel.location = @"This Place";
  self.hotel.rating = @1;
  
  self.room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
  self.room.rate = @1;
  self.room.hotel = self.hotel;
  self.room.beds = @2;
  
  self.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
  self.guest.firsName = @"Randhyll";
  self.guest.lastName = @"CHO";
  
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  self.hotel = nil;
  self.hotelService = nil;
  self.room = nil;
  self.guest = nil;
  [super tearDown];
}

-(void)testbookReservationTest {
  NSDate *startDate = [NSDate date];
  NSCalendar *calander = [NSCalendar currentCalendar];
  NSDateComponents *components = [NSDateComponents new];
  components.day = 2;
  NSDate *endDate = [calander dateByAddingComponents:components toDate:startDate options:0];
  
  Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest ForRoom:self.room checkIn:startDate checkOut:endDate];
  XCTAssertNotNil(reservation, @"Should prolly make a rez partner...");
  
}


@end
