//
//  HXSPostButton.h
//  store
//
//  Created by  黎明 on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostButtonDelegate <NSObject>

@optional
- (void)postButtonClickAction;

@end

@interface HXSPostButton : UIButton
@property (nonatomic, weak) id<PostButtonDelegate> delegate;

@end
