//
//  HXSMessageTableViewCell.h
//  store
//
//  Created by ArthurWang on 15/7/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *messageIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitileLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;



@end
