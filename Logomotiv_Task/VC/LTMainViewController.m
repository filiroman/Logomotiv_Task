//
//  LTMainViewController.m
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import "MDAPI.h"
#import "LTMainViewController.h"
#import "LTTimelineTableViewCell.h"
#import "LTStatusDetailViewController.h"

@interface LTMainViewController ()

@property (nonatomic, strong) NSMutableArray *timeline;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation LTMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
  [self setRefreshControl:refreshControl];
  
  self.tableView.hidden = YES;
  [self.tableView registerNib:[UINib nibWithNibName:@"LTTimelineTableViewCell" bundle:nil] forCellReuseIdentifier:@"statusCell"];
  
  self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  self.spinner.frame = CGRectMake(0, 0, 48, 48);
  
  UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
  self.spinner.center=frontWindow.center;
  [frontWindow addSubview:self.spinner];
  [self.spinner startAnimating];
  
  self.timeline = [NSMutableArray array];
  [self loadTimelineWithCompletion:^(BOOL success, NSArray *timeline, NSError *error) {
    [self.tableView reloadData];
    self.tableView.hidden = NO;
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshData
{
  [self loadTimelineWithCompletion:^(BOOL success, NSArray *timeline, NSError *error) {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
  }];
}

- (void)loadTimelineWithCompletion:(void (^)(BOOL success, NSArray *timeline, NSError *error))completion
{
  [[MDTimelineManager sharedManager] getTimelineWithCompletion:^(BOOL success, NSArray *statuses, NSError *error) {
    
    if (success)
    {
      [self.timeline removeAllObjects];
      [self.timeline addObjectsFromArray:statuses];
      
      if (completion != nil)
        completion(YES,statuses,nil);
    }
    else
    {
      NSLog(@"com.romanfilippov.Logomotiv-Task status retreiving error: %@", [error description]);
      if (completion != nil)
        completion(NO,nil,error);
    }
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.timeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  LTTimelineTableViewCell *cell = (LTTimelineTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
  MDStatus *status = [self.timeline objectAtIndex:[indexPath row]];
  
  [cell setStatus:status];
  
  if ([[status mediaAttachments] count] > 0)
  {
    //NOTE: For test purposes
    NSLog(@"Media is presented on row: %ld",(long)[indexPath row]);
  }
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"statusDetail" sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([[segue identifier] isEqualToString:@"statusDetail"])
  {
    LTStatusDetailViewController *statusDetailVC = (LTStatusDetailViewController*)[segue destinationViewController];
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    [statusDetailVC setStatus:[self.timeline objectAtIndex:[selectedRowIndex row]]];
  }
}


@end
