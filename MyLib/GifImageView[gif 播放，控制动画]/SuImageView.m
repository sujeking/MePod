//
//  SuImageView.m
//  masony
//
//  Created by  黎明 on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SuImageView.h"
#import <ImageIO/ImageIO.h>

@interface SuImageView()


@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, strong) NSArray *widths;
@property (nonatomic, strong) NSArray *heights;
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, strong) CAKeyframeAnimation *animation;
@property (nonatomic, assign) BOOL animationing;

@end



@implementation SuImageView



- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    
    if(progress < 1.0){
    
        _animationing = NO;
        
        [[self layer]removeAllAnimations];
        
        int index = (ceilf(progress * (self.imageArray.count - 1)));
        
        UIImage *image = self.imageArray[index];
        
        [self.layer setContents:image];
        
    } else {
        
        if(!_animationing){
        
            [[self layer] addAnimation:self.animation forKey:@"kkk"];
            
            _animationing = YES;
        }
    }
}


//解析gif文件数据的方法 block中会将解析的数据传递出来
-(void)getGifImageWithUrk:(NSURL *)url
               returnData:(void(^)(NSArray<UIImage *> * imageArray,
                                   NSArray<NSNumber *>*timeArray,
                                   CGFloat totalTime,
                                   NSArray<NSNumber *>* widths,
                                   NSArray<NSNumber *>* heights))dataBlock{
    
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    
    //获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    
    //存放所有图片
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    
    //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
    NSMutableArray * widthArray = [[NSMutableArray alloc]init];
    
    //存放每张图片的高度
    NSMutableArray * heightArray = [[NSMutableArray alloc]init];
    
    //遍历
    for (size_t i=0; i<count; i++) {
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        
        CGImageRelease(image);
        
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        
        CGFloat width  = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        
        allTime+=time;
        
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}


-(void)initWithImageUrl:(NSURL *)imageUrl{
    
    __weak typeof(self) __self = self;
    
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray,
                                                   NSArray<NSNumber *> *timeArray,
                                                   CGFloat totalTime,
                                                   NSArray<NSNumber *> *widths,
                                                   NSArray<NSNumber *> *heights) {
        //添加帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        
        NSMutableArray * times = [[NSMutableArray alloc]init];
        
        float currentTime = 0;
        
        //设置每一帧的时间占比
        
        for (int i=0; i<imageArray.count; i++) {
        
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            
            currentTime+=[timeArray[i] floatValue];
        }
        [animation setDelegate:self];
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        
        //设置循环
        animation.repeatCount= 1;
        //设置播放总时长
        animation.duration = totalTime;

        __self.imageArray = imageArray;
        __self.timeArray  = timeArray;
        __self.widths     = widths;
        __self.heights    = heights;
        __self.totalTime  = totalTime;
        __self.animation  = animation;
    }];
}

@end
