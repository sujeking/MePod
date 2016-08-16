//
//  HXSPrintSettingPagesModifyCell.m
//  store
//
//  Created by J006 on 16/3/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintSettingPagesModifyCell.h"

@interface HXSPrintSettingPagesModifyCell()

/**减号*/
@property (weak, nonatomic) IBOutlet UIButton     *decreaseButton;
/**打印label*/
@property (weak, nonatomic) IBOutlet UILabel      *printNumsLabel;
/**加号*/
@property (weak, nonatomic) IBOutlet UIButton     *increaseButton;
@property (nonatomic, strong) HXSMyPrintOrderItem *currentPrintOrderItem;

@end

@implementation HXSPrintSettingPagesModifyCell

- (void)awakeFromNib
{
}


#pragma mark - init

- (void)initPrintSettingPagesModifyCellWithHXSMyPrintOrderItem:(HXSMyPrintOrderItem *)orderItem
                                         andWithQuantityIntNum:(NSNumber *)quantityIntNum;
{
    _currentPrintOrderItem = orderItem;
    [_printNumsLabel setText:[quantityIntNum stringValue]];
    
    [self checkTheCurrentPrintNumsAndSettingTheButton];
}


#pragma mark - Button Action

/**
 *  减少打印份数
 *
 *  @param sender
 */
- (IBAction)decreaseAction:(id)sender
{
    NSInteger currentPrintNums = [_printNumsLabel.text integerValue];
    
    currentPrintNums--;
    
    if(currentPrintNums < DEFAULT_PRINTNUMS) {
        currentPrintNums = DEFAULT_PRINTNUMS;
    }
    
    [_printNumsLabel setText:[NSString stringWithFormat:@"%zd",currentPrintNums]];
    
    [self checkTheCurrentPrintNumsAndSettingTheButton];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmPrintNumsWithNums:)])
        [self.delegate confirmPrintNumsWithNums:currentPrintNums];
}

/**
 *  增加打印份数
 *
 *  @param sender
 */
- (IBAction)increaseAction:(id)sender
{
    NSInteger currentPrintNums = [_printNumsLabel.text integerValue];
    currentPrintNums++;
    [_printNumsLabel setText:[NSString stringWithFormat:@"%ld",(long)currentPrintNums]];
    
    [self checkTheCurrentPrintNumsAndSettingTheButton];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmPrintNumsWithNums:)])
        [self.delegate confirmPrintNumsWithNums:currentPrintNums];
}


#pragma mark - private methods

/**
 *  检测当前打印份数并根据数量设置减号按钮图片
 */
- (void)checkTheCurrentPrintNumsAndSettingTheButton
{
    NSInteger currentPrintNums = [_printNumsLabel.text integerValue];
    
    if(currentPrintNums <= DEFAULT_PRINTNUMS) {
        [_decreaseButton setImage:[UIImage imageNamed:@"ic_print_minus_bukedianji"]
                         forState:UIControlStateNormal];
    } else {
        [_decreaseButton setImage:[UIImage imageNamed:@"ic_print_minus_normal"]
                         forState:UIControlStateNormal];
    }
}

@end
