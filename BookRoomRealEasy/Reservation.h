//
//  Reservation.h
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/9/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Guest, Room;

@interface Reservation : NSManagedObject

@property (nonatomic, retain) NSDate * checkIn;
@property (nonatomic, retain) NSDate * checkOut;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) Guest *guest;

@end
