//
//  ReservationViewController.m
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/10/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import "ReservationViewController.h"
#import "Reservation.h"
#import "Guest.h"
#import "HotelService.h"

@interface ReservationViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *checkoutDatePicker;

@end

@implementation ReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
  
}
- (IBAction)bookNowButonPressed:(id)sender {
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:[[HotelService sharedService] coreDataStack].managedObjectContext];
  reservation.checkIn = self.startDatePicker.date;
  reservation.checkOut = self.checkoutDatePicker.date;
  reservation.room = self.selectedRoom;

  Guest *guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:[[HotelService sharedService] coreDataStack].managedObjectContext];
  guest.firsName = @"Ryan";
  guest.lastName = @"Christensen";
  reservation.guest = guest;
  [self dismissViewControllerAnimated:true completion:nil];
  
//  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Guest: %@ %@", guest.firsName, guest.lastName] message:@"Room Booked" delegate:self cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
//  [alert show];
  
  //NSLog(@"%lu",(unsigned long)self.selectedRoom.reservations.count);
  
  NSError *saveError;
  [self.selectedRoom.managedObjectContext save:&saveError];
  
  if (saveError) {
    NSLog(@"%@", saveError.localizedDescription);
  }
  
}


@end
