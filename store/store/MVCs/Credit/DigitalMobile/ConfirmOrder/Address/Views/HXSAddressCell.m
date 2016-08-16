//
//  HXSAddressCell.m
//  store
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAddressCell.h"
#import "HXSDigitalMobileAddressViewController.h"
#import "HXSDigitalMobileParamEntity.h"
#import "HXSDigitalMobileAddressEntity.h"

@implementation HXSAddressCell

- (void)awakeFromNib {
    // Initialization code
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 5.0f;
    
    self.name.delegate = self;
    self.phone.delegate = self;
    self.postalCode.delegate = self;
    self.bedroom.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seletcArea:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(seletcAreaAction)]) {
        [self.delegate performSelector:@selector(seletcAreaAction) withObject:nil];
    }
}

- (IBAction)selectStreet:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectStreetAction)]) {
        [self.delegate performSelector:@selector(selectStreetAction) withObject:nil];
    }
}

- (IBAction)selectSchool:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectSchoolAction)]) {
        [self.delegate performSelector:@selector(selectSchoolAction) withObject:nil];
    }
}

- (IBAction)selectBuilding:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectBuildingAction)]) {
        [self.delegate performSelector:@selector(selectBuildingAction) withObject:nil];
    }
}

- (IBAction)saveAddressInfo:(id)sender
{
    [self endEditing:YES];
    
    if (![self checkUploadData]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(saveAddressInfoAction:)]) {
        [self.delegate performSelector:@selector(saveAddressInfoAction:) withObject:self.addressEntity];
    }
}


#pragma mark - 数据校验

- (BOOL)checkUploadData
{
    BOOL isInfoComplete = YES;
    
    if (self.addressEntity.name.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请输入收货人" afterDelay:1.0f];
        return NO;
    }
    
    if (self.addressEntity.phone.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请输入手机号" afterDelay:1.0f];
        return NO;
    }
    
    if (![self.addressEntity.phone isValidCellPhoneNumber]) {
        [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请输入正确的手机号" afterDelay:1.0f];
        return NO;
    }
    
    if (self.addressEntity.postcode.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请输入邮编" afterDelay:1.0f];
        return NO;
    }
    
    if (self.addressEntity.province.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请选择地区" afterDelay:1.0f];
        return NO;
    }
    
    // 直辖市不做校验
    if (self.addressEntity.provinceId.integerValue > 4) {
        if (self.addressEntity.town.length == 0) {
            [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请选择街道" afterDelay:1.0f];
            return NO;
        }
    }
    
    if (self.addressEntity.site.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请选择学校" afterDelay:1.0f];
        return NO;
    }
    
    if (self.addressEntity.dormentry.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请选择楼栋" afterDelay:1.0f];
        return NO;
    }
    
    if (self.addressEntity.dormitory.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.superview status:@"请输入宿舍号" afterDelay:1.0f];
        return NO;
    }
    
    return isInfoComplete;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.name) {
        self.addressEntity.name = [textField.text trim];
    }
    
    if (textField == self.phone) {
        self.addressEntity.phone = [textField.text trim];
    }
    
    if (textField == self.postalCode) {
        self.addressEntity.postcode = [textField.text trim];
    }
    
    if (textField == self.bedroom) {
        self.addressEntity.dormitory = [textField.text trim];
    }
}

- (void)initCell:(HXSAddressEntity *)addressEntity and:(NSMutableArray *)addressInfo
{
    self.addressEntity = addressEntity;
    
    self.name.text = addressEntity.name;
    self.phone.text = addressEntity.phone;
    self.postalCode.text = addressEntity.postcode;
    self.bedroom.text = addressEntity.dormitory;
    
    // 地址信息
    HXSDigitalMobileAddressEntity *provinceEntity = (HXSDigitalMobileAddressEntity *)addressInfo[0];
    HXSDigitalMobileCityAddressEntity *cityEntity = (HXSDigitalMobileCityAddressEntity *)addressInfo[1];
    HXSDigitalMobileCountryAddressEntity *countyEntity = (HXSDigitalMobileCountryAddressEntity *)addressInfo[2];
    
    self.area.text = [NSString stringWithFormat:@"%@%@%@",provinceEntity.provinceNameStr,cityEntity.cityNameStr,countyEntity.countryNameStr];
    self.street.text = addressEntity.town;
    self.school.text = addressEntity.site;
    self.building.text = addressEntity.dormentry;
    
    // 直辖市取消街道选择
    if ([provinceEntity.provinceIDIntNum intValue] < 5) {
        [self hiddenStreetView];
    }else {
        [self showStreetView];
    }
}

- (void)hiddenStreetView
{
    self.streetView.hidden = YES;
    self.StreetViewHieght.constant = 0;
    
    self.addressEntity.townId = nil;
    self.addressEntity.town = nil;
    [self layoutIfNeeded];
}

- (void)showStreetView
{
    self.streetView.hidden = NO;
    self.StreetViewHieght.constant = 43;
    [self layoutIfNeeded];
}

@end
