//
//  LTTimelineTableViewCell.m
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <DateTools/DateTools.h>
#import "UIImageView+AFNetworking.h"
#import "LTTimelineTableViewCell.h"
#import "MDStatus.h"


@interface LTTimelineTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@end

@implementation LTTimelineTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  self.userAvatar.layer.cornerRadius = 10.0f;
  self.userAvatar.layer.masksToBounds = YES;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData
{
  self.userName.text = [NSString stringWithFormat:@"@%@", _status.userName];
  self.userDisplayName.text = _status.displayName;
  self.statusText.text = _status.statusText;
  self.statusDate.text = _status.statusCreationDate.shortTimeAgoSinceNow;
  
  [self.userAvatar setImageWithURL:[NSURL URLWithString:_status.userAvatarURL] placeholderImage:nil];
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
