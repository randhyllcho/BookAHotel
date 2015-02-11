//
//  RoomViewController.m
//  BookRoomRealEasy
//
//  Created by RYAN CHRISTENSEN on 2/9/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

#import "RoomViewController.h"
#import "Room.h"
#import "ReservationViewController.h"

@interface RoomViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *rooms;
@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.tableView.dataSource = self;
  self.rooms = self.hotel.rooms.allObjects;
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.rooms){
    return self.rooms.count;
  } else {
    return 0;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROOM_DETAIL" forIndexPath:indexPath];
  Room *currentRoom = self.rooms[indexPath.row];
  NSString *roomNumber = [NSString stringWithFormat:@"%@", currentRoom.number];
  cell.textLabel.text = roomNumber;
  return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([segue.identifier isEqualToString:@"BOOK_RESERVATION"]) {
    ReservationViewController *reservationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    Room *room = self.rooms[indexPath.row];
    reservationVC.selectedRoom = room;
  }
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
