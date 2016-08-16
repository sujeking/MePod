//
//  ImageTableViewCell.m
//  masony
//
//  Created by  黎明 on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HXSCommunityPostingPhotoCell.h"
#import "HXSCommunitUploadImageEntity.h"

#import <SDImageCache.h>

@interface HXSCommunityPostingPhotoCell()
@end

@implementation HXSCommunityPostingPhotoCell

#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define margin 15

static NSInteger const maxUploadPhotoNums = 9;          // 最大上传图片数量
static NSInteger const maxPhotoNumsInOneLine = 5;       // 一行最大显示数量



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initSubViews];
}


- (void)initSubViews
{
    //设置默认图片 用于添加图片入口
    NSMutableArray *initArray = [NSMutableArray array];
    [self setImages:initArray];
}



/**
 *  更具图片个数 进行计算和展示
 *
 *  @param images
 */
- (void)setupSubViewsWithImages:(NSArray *)images
{
    for (UIView *view in self.subviews)
    {
        if(view.tag == 99)
        {
            [view removeFromSuperview];
        }
    }
    
    NSInteger imageCount = [images count];

    CGFloat bgwidth = (screenWidth - 2 * margin) ;//图片背景宽度
    CGFloat imagepadding = bgwidth / (2 * margin - 1);
    CGFloat imagew = imagepadding * maxPhotoNumsInOneLine;
    CGFloat bgheight = 0;
    if (imageCount / maxPhotoNumsInOneLine == 0||imageCount % maxPhotoNumsInOneLine == 0)
    {
        bgheight = imagew;
    }
    else
    {
        bgheight = 2 * imagew + imagepadding;
    }

    UIView *imageBgView = [[UIView alloc] initWithFrame:
                           CGRectMake(margin, margin, bgwidth, bgheight)];
    imageBgView.tag = 99;
    [self addSubview:imageBgView];
    
    
    for (int i = 0; i < imageCount; i++)
    {
        HXSCommunitUploadImageEntity *uploadImageEntity = images[i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setUserInteractionEnabled:YES];
        imageView.tag = i;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(imageViewTapAction:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        CGFloat x,y =0 ;
        if (i < maxPhotoNumsInOneLine)
        {
            x = (i % maxPhotoNumsInOneLine) * (imagew + imagepadding);
            y = 0;
        }
        else
        {
            x = (i % maxPhotoNumsInOneLine) * (imagew + imagepadding);
            y = imagew + imagepadding;
        }
        
        imageView.frame = CGRectMake(x, y, imagew, imagew);
        if (uploadImageEntity.urlStr.length == 0)
        {
            [imageView setImage:uploadImageEntity.defaultImage];
        }
        else
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:uploadImageEntity.urlStr]];
        }
        
        [imageBgView addSubview:imageView];
    }
    
    self.cellHeight =  bgheight + 2 * margin;

}

//图片点击事件
- (void)imageViewTapAction:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    if (self.imageViewTapBlock)
    {
        self.imageViewTapBlock(imageView);
    }
}


- (void)setImages:(NSMutableArray *)images
{
    if (_images)
    {
        [_images removeAllObjects];
    }
    
    NSMutableArray *upLoadImages = [NSMutableArray array];
    
    [upLoadImages addObjectsFromArray:images];
    
    HXSCommunitUploadImageEntity *communitUploadImageEntity = [[HXSCommunitUploadImageEntity alloc] init];
    UIImage *image = [UIImage imageNamed:@"ic_addgoods_normal"];
    [communitUploadImageEntity setDefaultImage:image];
    
    [upLoadImages insertObject:communitUploadImageEntity atIndex:upLoadImages.count];
    
    if ([upLoadImages count] > maxUploadPhotoNums)
    {
        [upLoadImages removeObject:communitUploadImageEntity];
    }

    _images = upLoadImages;
    
    [self setupSubViewsWithImages:upLoadImages];
}

@end
