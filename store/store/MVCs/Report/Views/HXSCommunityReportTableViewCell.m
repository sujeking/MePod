//
//  HXSCommunityReportTableViewCell.m
//  store
//
//  Created by J006 on 16/5/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityReportTableViewCell.h"

@interface HXSCommunityReportTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel        *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *selectedImageView;

@end

@implementation HXSCommunityReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark init

- (void)initCommunityReportTableViewCellWithReportEntity:(HXSCommunityReportItemEntity *)reportEntity
                                      andWithParamEntity:(HXSCommunityReportParamEntity *)paramEntity
{
    [_contentLabel setText:@""];
    [_selectedImageView setHidden:YES];
    
    if(reportEntity.reasonStr)
    {
        [_contentLabel setText:reportEntity.reasonStr];
    }
    
    if(paramEntity.reasonStr
       && [paramEntity.reasonStr isEqualToString:reportEntity.reasonStr])
    {
        [_selectedImageView setHidden:NO];
    }
    else
    {
        [_selectedImageView setHidden:YES];
    }
}

@end
