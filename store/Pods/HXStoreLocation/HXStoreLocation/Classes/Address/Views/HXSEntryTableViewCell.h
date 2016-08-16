//
//  HXSEntryTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/1/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSEntryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel     *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *shopAddressLabel;
/** "共x种商品" */
@property (weak, nonatomic) IBOutlet UILabel     *shopSKUAmountLabel; 

@end
