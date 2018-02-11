//
//  LTStatusDetailViewController.m
//  Logomotiv_Task
//
//  Created by Roman Filippov on 11/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <DateTools/DateTools.h>
#import "UIImageView+AFNetworking.h"
#import "LTStatusDetailViewController.h"
#import "MDStatus.h"
#import "MDMediaObject.h"

@interface LTStatusDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *statusDate;
@property (weak, nonatomic) IBOutlet UITextView *statusText;
// Just one image to keep it simple, in general it's worth to embed this into UIScrollView
@property (weak, nonatomic) IBOutlet UIImageView *statusMediaView;

@end

@implementation LTStatusDetailViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.userAvatar.layer.cornerRadius = 15.0f;
  self.userAvatar.layer.masksToBounds = YES;
  
  [self updateData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)updateData
{
  self.userName.text = [NSString stringWithFormat:@"@%@", _status.userName];
  self.userDisplayName.text = _status.displayName;
  self.statusText.text = _status.statusText;
  self.statusDate.text = _status.statusCreationDate.shortTimeAgoSinceNow;
  
  [self.statusText sizeToFit];
  [self.userAvatar setImageWithURL:[NSURL URLWithString:_status.userAvatarURL] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
  
  if ([[_status mediaAttachments] count] > 0)
  {
    MDMediaObject *mObj = [[_status mediaAttachments] firstObject];
    [self.statusMediaView setImageWithURL:[NSURL URLWithString:mObj.objectURL] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
  }
}

- (void)setStatus:(MDStatus *)status
{
  if (_status == status)
    return;
  
  if ([_status.userAvatarURL isEqualToString:status.userAvatarURL])
    return;
  
  _status = status;
  [self updateData];
}


@end
