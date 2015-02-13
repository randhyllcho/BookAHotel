//
//  ReservationListViewController.m
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/11/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import "ReservationListViewController.h"
#import "HotelService.h"
#import "ReservationViewController.h"

@interface ReservationListViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ReservationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  NSManagedObjectContext *context = [[HotelService sharedService]coreDataStack].managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
  NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"room == %@", self.selectedRoom];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"checkIn" ascending:true];
  fetchRequest.predicate = fetchPredicate;
  fetchRequest.sortDescriptors = @[sortDescriptor];
  
  self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
  self.fetchedResultsController.delegate = self;
  self.tableView.dataSource =self;
  NSError *fetchError;
  [self.fetchedResultsController performFetch:&fetchError];
  if (fetchError) {
    NSLog(@"%@", fetchError);
  }
  
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  
  switch (type) {
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case  NSFetchedResultsChangeUpdate:
      [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
     case NSFetchedResultsChangeMove:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    default:
      break;
  }
}

-(void)configureCell: (UITableViewCell *)cell atIndexPath: (NSIndexPath *)indexPath {
  Reservation *reservation = [self.fetchedResultsController objectAtIndexPath:indexPath];
   cell.textLabel.text = [NSString stringWithFormat:@"Room: %@ ", reservation.room.number];
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return [[self.fetchedResultsController sections] count];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *sections = [self.fetchedResultsController sections];
  id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RESERVATION_CELL" forIndexPath:indexPath];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ADD_RESERVATION"]) {
    ReservationViewController *resVC = segue.destinationViewController;
    resVC.selectedRoom = self.selectedRoom;
  }
}

@end
