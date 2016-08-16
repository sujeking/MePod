//
//  HXSCommunityImageCell.m
//  store
//
//  Created by  黎明 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <objc/runtime.h>


@interface HXSCommunityImageCell()

@property (nonatomic, weak) IBOutlet UIImageView *imageView4;
@property (nonatomic, weak) IBOutlet UIImageView *imageView5;
@property (nonatomic, weak) IBOutlet UIImageView *imageView6;
@property (nonatomic, weak) IBOutlet UIImageView *imageView7;
@property (nonatomic, weak) IBOutlet UIImageView *imageView8;
@property (nonatomic, weak) IBOutlet UIImageView *imageView9;

@property (nonatomic, weak) IBOutlet UILabel *promptTagLabel;   //提示标签 [共9张]
@property (nonatomic, strong) NSMutableArray     *totalImageViewFrameArray;

@end

@implementation HXSCommunityImageCell

- (void)awakeFromNib {

    [self setClipsToBounds:YES];
    
    [self setupSubViews];
    
    [self addTapGestureRecognizer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setPostEntity:(HXSPost *)postEntity
{
    _postEntity = postEntity;
    _totalImageViewFrameArray = [[NSMutableArray alloc]init];
    if (postEntity.imagesArr.count > 3) {
        self.promptTagLabel.text = [NSString stringWithFormat:@"共%lu张",(unsigned long)postEntity.imagesArr.count];
        self.promptTagLabel.hidden = NO;
    }else{
        self.promptTagLabel.hidden = YES;
    }
    
    switch (postEntity.imagesArr.count) {
        case 1:
        {
            HXSImage *image = postEntity.imagesArr.firstObject;
            [self setOnePick:image.urlStr];
        }
            break;
        case 2:
        {
            NSMutableArray *imageUrls = [NSMutableArray new];
            for (HXSImage *picture in postEntity.imagesArr) {
                
                [imageUrls addObject:picture.urlStr];
            }
            [self setTwoPick:imageUrls];
        }
            break;
        default:
        {
            NSMutableArray *imageUrls = [NSMutableArray new];
            int i=0;
            for (HXSImage *picture in postEntity.imagesArr) {
                
                [imageUrls addObject:picture.urlStr];
                i++;
                if(i==3)
                    break;
            }
            
            [self setMorePick:imageUrls];
        }
            break;
    }
}


- (void)setPostDetailEntity:(HXSPost *)postEntity
{
    self.promptTagLabel.hidden = YES;

    _postEntity = postEntity;
    
    _totalImageViewFrameArray = [[NSMutableArray alloc]init];
    
    switch (postEntity.imagesArr.count) {
        case 1:
        {
            HXSImage *image = postEntity.imagesArr.firstObject;
            [self setOnePick:image.urlStr];
        }
            break;
        case 2:
        {
            NSMutableArray *imageUrls = [NSMutableArray new];
            for (HXSImage *picture in postEntity.imagesArr) {
                
                [imageUrls addObject:picture.urlStr];
            }
            [self setTwoPick:imageUrls];
            
        }
            break;
        default:
        {
            NSMutableArray *imageUrls = [NSMutableArray new];
            for (HXSImage *picture in postEntity.imagesArr) {
                
                [imageUrls addObject:picture.urlStr];
            }
            
            [self setMorePick:imageUrls];
        }
            break;
    }

}


- (void)addTapGestureRecognizer
{
    for (int i = 0; i < 10; i++) {
        
        NSString *imageViewStr = [NSString stringWithFormat:@"_imageView%d", i];
        
        Ivar ivar = class_getInstanceVariable([self class], [imageViewStr UTF8String]);
        
        id imageViewObj = object_getIvar(self, ivar);
        
        UIImageView *imageView = (UIImageView *)imageViewObj;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *taggr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheImageView:)];
        [imageView addGestureRecognizer:taggr];
    }
}

- (void)setupSubViews
{
    for (UIImageView *imageView in self.contentView.subviews) {
        if([imageView isKindOfClass:[UIImageView class]]) {
            imageView.clipsToBounds = YES;
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.promptTagLabel.bounds
                                                    cornerRadius:CGRectGetHeight(self.promptTagLabel.bounds)/2];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = path.CGPath;
    
    self.promptTagLabel.layer.mask = shapeLayer;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}


/**
 *  设置一张图片
 *
 *  @param imageUrl
 */
- (void)setOnePick:(NSString *)imageUrl
{
    for (int i = 0; i < 9; i++) {
        
        NSString *imageViewStr = [NSString stringWithFormat:@"_imageView%d", (i + 1)];
        
        Ivar ivar = class_getInstanceVariable([self class], [imageViewStr UTF8String]);
        
        id imageViewObj = object_getIvar(self, ivar);
        
        UIImageView *imageView = (UIImageView *)imageViewObj;
        
        imageView.hidden = YES;
    }
    
    [self.imageView0 setHidden:NO];
    
    [self.imageView0 sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                       placeholderImage:[UIImage imageNamed:@"img_loading_picturebig"]];

    [self.totalImageViewFrameArray addObject:self.imageView0];
}


/**
 *  设置两张图片
 *
 *  @param imageUrlsArray
 */
- (void)setTwoPick:(NSMutableArray *)imageUrlsArray
{
    [self.imageView0 setHidden:YES];
    for (int i = 0; i < 9; i++) {
        
        NSString *imageViewStr = [NSString stringWithFormat:@"_imageView%d", (i + 1)];
        
        Ivar ivar = class_getInstanceVariable([self class], [imageViewStr UTF8String]);
        
        id imageViewObj = object_getIvar(self, ivar);
        
        UIImageView *imageView = (UIImageView *)imageViewObj;
        
        imageView.hidden = YES;
    }
    
    [self.imageView1 setHidden:NO];
    
    [self.imageView2 setHidden:NO];
    
    [self.totalImageViewFrameArray addObject:self.imageView1];
    
    [self.totalImageViewFrameArray addObject:self.imageView2];
    
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageUrlsArray[0]]
                       placeholderImage:[UIImage imageNamed:@"img_loading_picturebig"]];

    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageUrlsArray[1]]
                       placeholderImage:[UIImage imageNamed:@"img_loading_picturebig"]];
}


/**
 *  设置多种图片
 *
 *  @param imageUrls
 */
- (void)setMorePick:(NSArray *)imageUrls
{
    [self.imageView0 setHidden:YES];
    
    for (int i = 0; i < 9; i++) {
        
        NSString *imageViewStr = [NSString stringWithFormat:@"_imageView%d", (i + 1)];
        
        Ivar ivar = class_getInstanceVariable([self class], [imageViewStr UTF8String]);
        
        id imageViewObj = object_getIvar(self, ivar);
        
        UIImageView *imageView = (UIImageView *)imageViewObj;
        
        if(i<imageUrls.count) {
            [self.totalImageViewFrameArray addObject:imageView];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i]]
                         placeholderImage:[UIImage imageNamed:@"img_loading_picturebig"]];
            imageView.hidden = NO;
        }else {
            imageView.hidden = YES;
        }
    }
}

#pragma mark -

+ (CGFloat)getCellHeightWithImagesCount:(NSInteger)imagesCount
{
    //float imageHight = (SCREEN_WIDTH / 3.0) - 14;
    
    float imageHight = (SCREEN_WIDTH - 75) / 3;

    if (imagesCount == 0) {
        
        return 0;
        
    } else if (imagesCount == 1) {
        
        return 200;
        
    } else {
        
        if (imagesCount % 3 == 0) {
        
            return imageHight * (imagesCount / 3);// + (imagesCount / 3 +1) * 10;

        } else {
            
            return imageHight* (imagesCount / 3 + 1);// + ((imagesCount / 3 + 1) + 1)*10;
        }
    }
}

/**
 *  图片点击
 *
 *  @param sender
 */
- (void)tapTheImageView:(UITapGestureRecognizer *)sender
{
    NSInteger tag = [[sender view] tag];
    
    NSMutableArray *uploadImageEntitys = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< [self.postEntity.imagesArr count]; i++) {
        HXSImage *image = self.postEntity.imagesArr[i];
        HXSCommunitUploadImageEntity *uploadImageEntity = [[HXSCommunitUploadImageEntity alloc]init];
        uploadImageEntity.urlStr = image.urlStr;
        if(i < _totalImageViewFrameArray.count)
        {
            uploadImageEntity.imageView =self.totalImageViewFrameArray[i];
        }
        [uploadImageEntitys addObject:uploadImageEntity];
    }
    
    if (self.showImages) {
        UIImageView *imageView = (UIImageView *)sender.view;
        self.showImages(uploadImageEntitys,tag == 0 ? 0 : tag - 1,imageView);
    }
}


@end
