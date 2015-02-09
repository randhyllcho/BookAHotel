//
//  Guest.h
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/9/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Reservation;

@interface Guest : NSManagedObject

@property (nonatomic, retain) NSString * firsName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *reservations;
@end

@interface Guest (CoreDataGeneratedAccessors)

- (void)addReservationsObject:(Reservation *)value;
- (void)removeReservationsObject:(Reservation *)value;
- (void)addReservations:(NSSet *)values;
- (void)removeReservations:(NSSet *)values;

@end
