//
//  HotelListViewController.m
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/9/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import "HotelListViewController.h"
#import "AppDelegate.h"
#import "Hotel.h"
#import "RoomViewController.h"


@interface HotelListViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *hotels;

@end

@implementation HotelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.tableView.dataSource = self;
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  NSManagedObjectContext *context = appDelegate.managedObjectContext;
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *fetchError;
  
  NSArray *results = [context executeFetchRequest:fetchRequest error:&fetchError];
  if (!fetchError) {
    self.hotels = results;
    [self.tableView reloadData];
  }
  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.hotels) {
    return self.hotels.count;
  } else {
    return 0;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOTEL_CELL" forIndexPath:indexPath];
  Hotel *hotel = self.hotels[indexPath.row];
  cell.textLabel.text = hotel.name;
  return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"SHOW_ROOMS"]) {
    RoomViewController *roomVc = (RoomViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathsForSelectedRows.firstObject;
    roomVc.hotel = self.hotels[indexPath.row];
  }
}


@end
