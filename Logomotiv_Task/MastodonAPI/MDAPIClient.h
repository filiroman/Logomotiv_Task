//
//  MDAPIClient.h
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface MDAPIClient : AFHTTPSessionManager

+ (MDAPIClient *)sharedClientWithBaseAPI:(NSString *)baseAPI;

@end
