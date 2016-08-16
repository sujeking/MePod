//
//  HXSDigitalMobileAverageTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileAverageTableViewCell.h"

#import "HXSDormHotLevelView.h"

@interface HXSDigitalMobileAverageTableViewCell ()

@property (weak, nonatomic) IBOutlet HXSDormHotLevelView *startView;
/**should '3.5分'*/
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@end

@implementation HXSDigitalMobileAverageTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Public Methods

- (void)setupCellWithAverageScore:(NSNumber *)averageScoreFloatNum
{
    // 星星
    [self.startView setHotValue:ceil([averageScoreFloatNum floatValue])];
    [self.startView setUserInteractionEnabled:NO];
    
    // 分数
    self.scoreLabel.text = [NSString stringWithFormat:@"%0.1f分", [averageScoreFloatNum floatValue]];
}

@end
