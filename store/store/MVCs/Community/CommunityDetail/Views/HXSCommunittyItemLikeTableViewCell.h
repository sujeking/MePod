//
//  HXSCommunittyItemLikeTableViewCell.h
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点赞cell
 */

@interface HXSCommunittyItemLikeTableViewCell : UITableViewCell

/**
 *  点赞
 */
@property (nonatomic, strong) NSArray *likeListArr;

/**
 *  根据点赞人数计算高度  对多4行
 *
 *  @param count
 *
 *  @return
 */
+ (CGFloat)getHeightForLikeCount:(NSInteger)count;

@end
