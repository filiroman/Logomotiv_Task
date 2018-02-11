//
//  MDMediaObject.m
//  Logomotiv_Task
//
//  Created by Roman Filippov on 11/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import "MDMediaObject.h"

@implementation MDMediaObject

- (id)initWithDictionary:(NSDictionary*)dict
{
  if (self = [super init])
  {
    //TODO: Parse all object types, meta, desc etc
    
    _objectID = [dict objectForKey:@"id"];
    _objectURL = [dict objectForKey:@"url"];
    _objectType = [self objectTypeFromString:[dict objectForKey:@"type"]];
    
    // Note: When the type is "unknown", it is likely only remote_url is available and local url is missing
    if (_objectURL == nil)
      _objectURL = [dict objectForKey:@"remote_url"];
  }
  return self;
}

+ (MDMediaObject*)mediaObjectFromDictionary:(NSDictionary*)dict
{
  return [[MDMediaObject alloc] initWithDictionary:dict];
}

- (MDMediaObjectType)objectTypeFromString:(NSString*)objString
{
  if ([objString isEqualToString:@"image"])
    return MDMediaObjectTypeImage;
  if ([objString isEqualToString:@"video"])
    return MDMediaObjectTypeVideo;
  if ([objString isEqualToString:@"gifv"])
    return MDMediaObjectTypeGif;
  
  return MDMediaObjectTypeUnknown;
}

@end
