//
//  MDTimeline.h
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDStatus : NSObject

@property (nonatomic, strong, readonly) NSString *objectID;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *displayName;
@property (nonatomic, strong, readonly) NSString *userAvatarURL;
@property (nonatomic, strong, readonly) NSString *statusTextHTML;
@property (nonatomic, strong, readonly) NSString *statusText;
@property (nonatomic, strong, readonly) NSDate *statusCreationDate;


+ (MDStatus*)statusFromDictionary:(NSDictionary*)dict;
- (id)initWithDictionary:(NSDictionary*)dict;

// returns array of @MDMediaObject objects or nil of there is no media in status
- (NSArray*)mediaAttachments;

@end
