//
//  HXSCommunityNitifacationCell.h
//  store
//
//  Created by  黎明 on 16/4/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSCommunityNitifacationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *MsgContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *useIconImageView;
@property (weak, nonatomic) IBOutlet UIView *noticeBgView;

- (void)initMsgContent:(NSString *)msgContent andMsgIconUrl:(NSString *)msgIconUrl;
@end
