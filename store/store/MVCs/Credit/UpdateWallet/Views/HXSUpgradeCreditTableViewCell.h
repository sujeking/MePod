//
//  HXSUpgradeCreditTableViewCell.h
//  store
//
//  Created by  黎明 on 16/7/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

/*************************************************************************************
 *  59钱包升级cell
 *
 *  @param NSInteger
 *  @param HXSCellTypeNum
 *
 *  @return
 ************************************************************************************/

#import <UIKit/UIKit.h>


@class HXSUpgradeCreditTableViewCellModel;
//授权项目
typedef NS_ENUM(NSInteger,HXSCellTypeNum)
{
    HXSCellTypeNumGPS              = 0,//定位
    HXSCellTypeNumContackBook      = 1,//通讯录
    HXSCellTypeNumZhimaCredit      = 2,//芝麻信用
    HXSCellTypeNumEmergencyContact = 3,//紧急联系人
    HXSCellTypeNumDormAddress      = 4,//宿舍地址
    HXSCellTypeNumIDCardUP         = 5,//身份证正面
    HXSCellTypeNumIDCardDown       = 6,//身份证反面
    HXSCellTypeNumIDCardHandle     = 7,//手持身份证
};


@protocol HXSUpgradeCreditTableViewCellDelegate<NSObject>

- (void)upgradeCreditTableViewCellButtonClick:(HXSUpgradeCreditTableViewCellModel *)model;
- (void)upgradeCreditTableViewCellImageViewTap:(UIImageView *)imageView;

@end


/**
 *  Cell的Model
 */
@interface HXSUpgradeCreditTableViewCellModel : NSObject

@property (nonatomic, copy) NSString *cellLabelTitleStr;
@property (nonatomic, copy) NSString *cellButtonTitleStr;
@property (nonatomic, copy) NSString *cellImageURLStr;
@property (nonatomic, copy) NSNumber *cellIdNum;
@property (nonatomic, copy) NSNumber *cellDoneNum;
@property (nonatomic, assign) HXSCellTypeNum cellTypeNum;


@end


@interface HXSUpgradeCreditTableViewCell : UITableViewCell
@property (nonatomic, strong) HXSUpgradeCreditTableViewCellModel *model;
@property (nonatomic, weak) id<HXSUpgradeCreditTableViewCellDelegate> delegate;
@end
