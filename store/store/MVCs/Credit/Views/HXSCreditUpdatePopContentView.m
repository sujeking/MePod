//
//  HXSCreditUpdatePopContentView.m
//  store
//
//  Created by  黎明 on 16/7/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditUpdatePopContentView.h"

@interface HXSCreditUpdatePopContentView()


@property (weak, nonatomic) IBOutlet UIButton *completeInfoButton;
@property (weak, nonatomic) IBOutlet UITextView *popContentTextView;

@end

@implementation HXSCreditUpdatePopContentView

- (void)awakeFromNib
{
    self.completeInfoButton.backgroundColor = HXS_MAIN_COLOR;
    self.completeInfoButton.layer.cornerRadius = 5.0f;
    self.completeInfoButton.layer.masksToBounds = YES;
    [self.completeInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.popContentTextView setContentOffset:CGPointMake(0, 0)];
}

- (IBAction)completeInfoButtonClick:(id)sender
{
    if (self.completeButtonClickBlick)
    {
        self.completeButtonClickBlick();
    }
}

@end
