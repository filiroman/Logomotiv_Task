//
//  MDTimelineManager.m
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import "MDTimelineManager.h"
#import "MDAPIClient.h"
#import "MDInitializer.h"
#import "MDStatus.h"

@implementation MDTimelineManager

+ (MDTimelineManager *)sharedManager
{
  static MDTimelineManager *sharedManager = nil;
  static dispatch_once_t managerToken;
  dispatch_once(&managerToken, ^{
    
    sharedManager = [[MDTimelineManager alloc] init];
  });
  
  return sharedManager;
}

- (void)getTimelineWithCompletion:(void (^)(BOOL success, NSArray *statuses, NSError *error))completion
{
  [[MDAPIClient sharedClientWithBaseAPI:[[MDInitializer sharedInitializer] api_url]] GET:@"timelines/public" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSArray* statuses = [self parseStatusesFromArray:((NSArray*)responseObject)];
    if (completion != nil) {
      completion(YES, statuses, nil);
    }
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    if (completion != nil) {
      completion(NO, nil, error);
    }
  }];
}


- (NSArray*)parseStatusesFromArray:(NSArray*)statusesArray
{
  NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[statusesArray count]];
  
  for (NSDictionary* statusDict in statusesArray) {
    MDStatus *statusObj = [MDStatus statusFromDictionary:statusDict];
    [resultArray addObject:statusObj];
  }
  
  return resultArray;
}

@end
