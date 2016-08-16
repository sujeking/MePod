//
//  HXSAddressCell.h
//  store
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSAddressEntity.h"
@class HXSDigitalMobileAddressViewController;

@protocol HXSAddressCellActionDelegate <NSObject>

- (void)seletcAreaAction;
- (void)selectStreetAction;
- (void)selectSchoolAction;
- (void)selectBuildingAction;
- (void)saveAddressInfoAction:(HXSAddressEntity *)addressEntity;

@end

@interface HXSAddressCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *postalCode;
@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet UITextField *street;
@property (weak, nonatomic) IBOutlet UITextField *school;
@property (weak, nonatomic) IBOutlet UITextField *building;
@property (weak, nonatomic) IBOutlet UITextField *bedroom;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIView *streetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *StreetViewHieght;


@property (weak, nonatomic) id <HXSAddressCellActionDelegate> delegate;
@property (nonatomic, strong) HXSAddressEntity *addressEntity;

- (void)initCell:(HXSAddressEntity *)addressEntity and:(NSMutableArray *)addressInfo;

@end
