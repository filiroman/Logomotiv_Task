//
//  MDMediaObject.h
//  Logomotiv_Task
//
//  Created by Roman Filippov on 11/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <Foundation/Foundation.h>

// According to:
// https://github.com/tootsuite/documentation/blob/master/Using-the-API/API.md#attachment
//
typedef enum {
  MDMediaObjectTypeImage = 0,
  MDMediaObjectTypeVideo,
  MDMediaObjectTypeGif,
  MDMediaObjectTypeUnknown
} MDMediaObjectType;

@interface MDMediaObject : NSObject

@property (nonatomic, strong, readonly) NSString* objectID;
@property (nonatomic, strong, readonly) NSString* objectURL;
@property (nonatomic, readonly) MDMediaObjectType objectType;

- (id)initWithDictionary:(NSDictionary*)dict;
+ (MDMediaObject*)mediaObjectFromDictionary:(NSDictionary*)dict;

@end
