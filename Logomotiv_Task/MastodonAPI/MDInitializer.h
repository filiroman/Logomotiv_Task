//
//  MDInitializer.h
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDInitializer : NSObject

@property (nonatomic, strong) NSString *api_url;
@property (nonatomic, strong) NSString *base_url;

+ (MDInitializer *)sharedInitializer;
- (void)initializeAPI;

@end
