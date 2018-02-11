//
//  MDAPIClient.m
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import "MDAPIClient.h"

@implementation MDAPIClient

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
  self = [super initWithBaseURL:url sessionConfiguration:configuration];
  if (self) {
    
    self.requestSerializer.networkServiceType = NSURLNetworkServiceTypeBackground;
    
    NSOperationQueue *operationQueue = self.operationQueue;
    
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      
      switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
          [operationQueue setSuspended:NO];
          break;
        case AFNetworkReachabilityStatusNotReachable:
        default:
          [operationQueue setSuspended:YES];
          break;
      }
    }];
  }
  
  return self;
}


+ (MDAPIClient *)sharedClientWithBaseAPI:(NSString *)baseAPI
{
  NSURL *baseAPIURL = [NSURL URLWithString:baseAPI];
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//  configuration.timeoutIntervalForRequest = 900.0f;
  
  MDAPIClient *sharedClient = [[MDAPIClient alloc] initWithBaseURL:baseAPIURL sessionConfiguration:configuration];
  [sharedClient.reachabilityManager startMonitoring];
  
  return sharedClient;
}


@end
