//
//  HXSAddressInfoView.m
//  store
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAddressInfoView.h"
#import "HXSAddressEntity.h"

@implementation HXSAddressInfoView

- (void)awakeFromNib {
    
}


#pragma mark - show address info

- (IBAction)showAddressInfo:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoEditAddressViewcontroller)]) {
        [self.delegate performSelector:@selector(gotoEditAddressViewcontroller) withObject:nil];
    }
}

- (void)initBuyerInfo:(HXSAddressEntity *)addressInfo
{
    self.nameLabel.text = addressInfo.name;
    self.phoneLabel.text = addressInfo.phone;
    self.addressTextView.text = [addressInfo getAddressName];
    
}
@end
