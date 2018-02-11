//
//  LTTimelineTableViewCell.h
//  Logomotiv_Task
//
//  Created by Roman Filippov on 10/02/2018.
//  Copyright © 2018 romanfilippov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDStatus;
@interface LTTimelineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *statusText;
@property (weak, nonatomic) IBOutlet UILabel *statusDate;
@property (strong, nonatomic) MDStatus *status;

@end
