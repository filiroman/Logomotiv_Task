//
//  MDInitializer.m
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import "MDInitializer.h"
#import "MDConstants.h"
#import "MDAPIClient.h"

@interface MDInitializer ()

@property (nonatomic, readonly) BOOL isRegistered;
@property (nonatomic, strong) NSString *client_id;
@property (nonatomic, strong) NSString *client_secret;


@end
@implementation MDInitializer

- (id)init
{
  self = [super init];
  if (self) {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    self.client_id = [ud objectForKey:MD_CLIENT_ID_KEY];
    self.client_secret = [ud objectForKey:MD_CLIENT_SECRET_KEY];
    
    BOOL changed = NO;
    
    // if app is launching for the first time, we set base URLs and save them into NSUserDefaults
    if (![ud objectForKey:MD_BASE_URL_KEY])
    {
      self.base_url = MD_BASE_URL_DEFAULT;
      [ud setObject:MD_BASE_URL_DEFAULT forKey:MD_BASE_URL_KEY];
      changed = YES;
    }
    else
      self.base_url = [ud objectForKey:MD_BASE_URL_KEY];
    
    if (![ud objectForKey:MD_API_URL_KEY])
    {
      self.api_url = MD_API_URL_DEFAULT;
      [ud setObject:MD_API_URL_DEFAULT forKey:MD_API_URL_KEY];
      changed = YES;
    }
    else
      self.api_url = [ud objectForKey:MD_API_URL_KEY];
    
    if (changed)
      [ud synchronize];
  }
  return self;
}

+ (MDInitializer *)sharedInitializer
{
  static MDInitializer *sharedInitializer = nil;
  static dispatch_once_t initToken;
  dispatch_once(&initToken, ^{
    
    sharedInitializer = [[MDInitializer alloc] init];
  });
  
  return sharedInitializer;
}

- (void)registerApp:(void (^)(BOOL))completion
{
  NSDictionary *params = @{@"client_name": MD_APP_NAME,
                           @"redirect_uris": MD_APP_REDIRECT_URI,
                           @"scopes": MD_APP_SCOPE,
                           @"website": MD_APP_WEB};
  
  NSString *requestUrl = [NSString stringWithFormat:@"%@%@", self.api_url, @"apps"];
  
  [[MDAPIClient sharedClientWithBaseAPI:self.api_url] POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    self.client_id = [responseObject objectForKey:@"client_id"];
    self.client_secret = [responseObject objectForKey:@"client_secret"];
    
    // Save client_id and client_secret for future usage when we've got them from the server
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.client_id forKey:MD_CLIENT_ID_KEY];
    [ud setObject:self.client_secret forKey:MD_CLIENT_SECRET_KEY];
    [ud synchronize];
    
    if (completion != nil) {
      completion(self.isRegistered);
    }
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    if (completion != nil) {
      completion(self.isRegistered);
    }
    
  }];
}

- (void)initializeAPI
{
  if (!self.isRegistered)
  {
    [self registerApp:^(BOOL success) {
      
      if (success)
      {
        NSLog(@"APP %@ IS REGISTERED SUCCESSFULLY!", MD_APP_NAME);
      }
    }];
  }
  else
  {
    NSLog(@"APP %@ IS ALREADY REGISTERED!", MD_APP_NAME);
  }
}

- (BOOL)isRegistered
{
  return self.client_id != nil && self.client_secret != nil;
}


@end
