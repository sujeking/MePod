//
//  HXSFinishTakePhotoView.m
//  store
//
//  Created by  黎明 on 16/7/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSFinishTakePhotoView.h"

#import <QuartzCore/QuartzCore.h>
@interface HXSFinishTakePhotoView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
@implementation HXSFinishTakePhotoView


- (instancetype)initWithImage:(UIImage *)image
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                         owner:nil
                                       options:nil].firstObject;
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    if (self)
    {
        self.imageView.image = image;
    }
    
    return self;
}


#pragma mark - Action

- (IBAction)reTakeAction:(id)sender
{
    if (self.reTakePhotoBlock)
    {
        self.reTakePhotoBlock(self);
    }
}

- (IBAction)takePhotoDoneAction:(id)sender
{
    if (self.takePhotoDoneBlock)
    {
        self.takePhotoDoneBlock(self.imageView.image);
    }
}


@end
