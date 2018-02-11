//
//  MDTimelineManager.h
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDTimelineManager : NSObject

+ (MDTimelineManager *)sharedManager;
- (void)getTimelineWithCompletion:(void (^)(BOOL success, NSArray *statuses, NSError *error))completion;

@end
