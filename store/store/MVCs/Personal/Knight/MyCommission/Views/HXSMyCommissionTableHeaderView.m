//
//  HXSMyCommissionTableHeaderView.m
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyCommissionTableHeaderView.h"

@implementation HXSMyCommissionTableHeaderView

+ (id)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

-(void)awakeFromNib{
    [super awakeFromNib];

}

- (void)updategetCashButtonStatus:(BOOL)enable{
    if(enable){
        [self.getCashButton setUserInteractionEnabled:YES];
        self.getCashButton.borderColor = [UIColor whiteColor];
        [self.getCashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.getCashButton setImage:[UIImage imageNamed:@"ic_enchashment"] forState:UIControlStateNormal];
    }else{
        [self.getCashButton setUserInteractionEnabled:NO];
        self.getCashButton.borderColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        [self.getCashButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.4] forState:UIControlStateNormal];
        [self.getCashButton setImage:[UIImage imageNamed:@"ic_enchashment_disable"] forState:UIControlStateNormal];
    }
}

@end
