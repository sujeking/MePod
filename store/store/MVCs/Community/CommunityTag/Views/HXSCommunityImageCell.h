//
//  HXSCommunityImageCell.h
//  store
//
//  Created by  黎明 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//




//*******************************************************************/
//根据图片的张数计算高度   count/3==0?count/3:count/3+1
//
//*******************************************************************/


#import <UIKit/UIKit.h>
#import "HXSPost.h"
#import "HXSCommunitUploadImageEntity.h"

@interface HXSCommunityImageCell : UITableViewCell

@property (nonatomic, strong) HXSPost *postEntity;

@property (nonatomic, weak) IBOutlet UIImageView *imageView0;
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet UIImageView *imageView3;

/**
 *  点击图片显示的回调
 */
@property (nonatomic, copy) void (^showImages)(NSMutableArray<HXSCommunitUploadImageEntity *> *images,NSInteger index,UIImageView *imageView);
/**
 *  设置帖子详情的图片
 *
 *  @param postEntity
 */
- (void)setPostDetailEntity:(HXSPost *)postEntity;



/**
 *  根据图片的张数返回Cell的高度
 *
 *  @param imagesCount 图片张数
 *
 *  @return 
 */
+ (CGFloat)getCellHeightWithImagesCount:(NSInteger)imagesCount;

@end
