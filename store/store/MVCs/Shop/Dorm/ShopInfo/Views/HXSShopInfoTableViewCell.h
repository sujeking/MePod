//
//  HXSShopInfoTableViewCell.h
//  store
//
//  Created by  黎明 on 16/7/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

/************************************************************
 *  店铺详情cell  活动、 通知
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface HXSShopInfoTableViewCellModel : NSObject

@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *imgurlStr;
@property (strong, nonatomic) NSString *titleColor;

@end


@interface HXSShopInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) HXSShopInfoTableViewCellModel *dataModel;
@end
