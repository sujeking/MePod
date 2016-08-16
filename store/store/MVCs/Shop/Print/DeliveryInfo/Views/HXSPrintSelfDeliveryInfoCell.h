//
//  HXSPrintSelfDeliveryInfoCell.h
//  store
//
//  Created by 格格 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSDeliveryEntity.h"

@protocol HXSPrintSelfDeliveryInfoCellDelegate <NSObject>

@required

-(void)selectButtonClicked:(NSIndexPath *)indexPath;

@end

@interface HXSPrintSelfDeliveryInfoCell : UITableViewCell

@property(nonatomic,strong) HXSDeliveryEntity *deliveryEntity;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,assign) BOOL ifSelected;
@property(nonatomic,weak) id<HXSPrintSelfDeliveryInfoCellDelegate>cellDelegate;

-(void)setupDeliveryEntity:(HXSDeliveryEntity *)deliveryEntity indexPath:(NSIndexPath *)indexPath;

@end
