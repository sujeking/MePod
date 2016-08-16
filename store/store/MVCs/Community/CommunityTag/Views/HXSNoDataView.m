//
//  HXSNoDataView.m
//  store
//
//  Created by  黎明 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSNoDataView.h"

@interface HXSNoDataView()

@property (weak, nonatomic) IBOutlet UIImageView    *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel        *contentLabel;

@end

@implementation HXSNoDataView

#pragma mark init

- (void)initTheHXSNoDataViewWithType:(HXSCommunityNoDataType)type
{
    switch (type)
    {
        case kHXSCommunityNoDataTypePost:
        {
            [_iconImageView setImage:[UIImage imageNamed:@"img_kong_tiezi"]];
            [_contentLabel setText:@"这里很空旷,待开荒~"];
            break;
        }
        case kHXSCommunityNoDataTypeMyReply:
        {
            [_iconImageView setImage:[UIImage imageNamed:@"img_kong_wodehuifu"]];
            [_contentLabel setText:@"你太高冷了，有空给小\n伙伴们留个言吧～"];
            break;
        }
        case kHXSCommunityNoDataTypeReplyForMe:
        {
            [_iconImageView setImage:[UIImage imageNamed:@"img_kong_huifuwode"]];
            [_contentLabel setText:@"没人来这里墨迹～"];
            break;
        }
    }
}

@end
