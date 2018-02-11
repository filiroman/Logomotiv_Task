//
//  MDTimeline.m
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDStatus.h"
#import "MDMediaObject.h"

@interface MDStatus ()
// Array of @MDMediaObject elements
@property (nonatomic, strong, readonly) NSMutableArray *mediaObjects;
@end

@implementation MDStatus

- (id)initWithDictionary:(NSDictionary*)dict
{
  if (self = [super init])
  {
    _objectID = [dict objectForKey:@"id"];
    _statusTextHTML = [dict objectForKey:@"content"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_statusTextHTML dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _statusText = attrStr.string;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *result = [formatter dateFromString:[dict objectForKey:@"created_at"]];
    _statusCreationDate = result;
    
    // account is not nullable:
    // https://github.com/tootsuite/documentation/blob/master/Using-the-API/API.md#status
    //
    NSDictionary *accountInfo = [dict objectForKey:@"account"];
    _userName = [accountInfo objectForKey:@"username"];
    _displayName = [accountInfo objectForKey:@"display_name"];
    _userAvatarURL = [accountInfo objectForKey:@"avatar"];
    
    // media_attachments is not nullable:
    // https://github.com/tootsuite/documentation/blob/master/Using-the-API/API.md#status
    //
    NSArray *media = [dict objectForKey:@"media_attachments"];
    if ([media count] > 0)
    {
      
      //NOTE: This is for test purposes only
      NSLog(@"Parsing media attachments for %@",_objectID);
      
      _mediaObjects = [NSMutableArray arrayWithCapacity:[media count]];
      
      for (NSDictionary *attachment in media) {
        MDMediaObject *mObj = [MDMediaObject mediaObjectFromDictionary:attachment];
        
        // NOTE: This is just for testing purposes (since it's required to load only images in the task)
        if (mObj.objectType == MDMediaObjectTypeImage)
          [_mediaObjects addObject:mObj];
      }
    }
  }
  return self;
}

+ (MDStatus*)statusFromDictionary:(NSDictionary*)dict
{
  return [[MDStatus alloc] initWithDictionary:dict];
}

- (NSArray*)mediaAttachments
{
  return [NSArray arrayWithArray:_mediaObjects];
}

@end
