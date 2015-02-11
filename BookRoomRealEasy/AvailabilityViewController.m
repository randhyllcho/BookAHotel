//
//  AvailabilityViewController.m
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/10/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "AppDelegate.h"
#import "Reservation.h"
#import "HotelService.h"

@interface AvailabilityViewController () <UIAlertViewDelegate>
//@property (strong, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@end

@implementation AvailabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkAvailabilityButton:(id)sender {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Room"];
  NSString *selectedHotel = [self.segmentControl titleForSegmentAtIndex:self.segmentControl.selectedSegmentIndex];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.hotel.name MATCHES %@", selectedHotel];
  fetchRequest.predicate = predicate;
  
  NSFetchRequest *reservationFetch = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
  NSPredicate *reservationPredicate = [NSPredicate predicateWithFormat:@"room.hotel.name MATCHES %@ AND checkIn <= %@ OR checkOut >= %@", selectedHotel, self.endDatePicker.date, self.startDatePicker.date];
  
  reservationFetch.predicate = reservationPredicate;
  NSError *fetchError;
  
  NSArray *results = [[[HotelService sharedService] coreDataStack].managedObjectContext executeFetchRequest:reservationFetch error:&fetchError];
  
  NSMutableArray *rooms = [NSMutableArray new];
  for (Reservation *reservation in results) {
    [rooms addObject:reservation.room];
  }
  
  NSFetchRequest *anotherFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Room"];
  NSPredicate *roomsPredicate = [NSPredicate predicateWithFormat:@"hotel.name MATCHES %@ AND NOT (self IN %@)",selectedHotel, rooms];
  anotherFetchRequest.predicate = roomsPredicate;
  NSError *roomsError;
  NSArray *roomsResults = [[[HotelService sharedService] coreDataStack].managedObjectContext executeFetchRequest:anotherFetchRequest error:&roomsError];
  if (roomsError) {
    NSLog(@"%@", roomsError.localizedDescription);
  }
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", selectedHotel] message:[NSString stringWithFormat:@"%lu rooms available!", (unsigned long)roomsResults.count] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
  [alert show];
  
//  NSLog(@"Results: %lu",(unsigned long)roomsResults.count);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
