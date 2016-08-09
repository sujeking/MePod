//
//  SuImageView.h
//  masony
//
//  Created by  黎明 on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuImageView : UIImageView

@property (nonatomic, assign) CGFloat progress;

-(void)initWithImageUrl:(NSURL *)imageUrl;
@end
