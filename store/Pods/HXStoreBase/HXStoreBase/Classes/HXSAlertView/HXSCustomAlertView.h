//
//  HXSCustomAlertView.h
//  store
//
//  Created by ArthurWang on 15/7/30.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AlertBlock)(void);

typedef enum : NSUInteger {
    MESSAGE_LABEL_ALIGNMENT_CENTER = 0, // Default
    MESSAGE_LABEL_ALIGNMENT_LEFT
} MESSAGE_LABEL_ALIGNMENT;

@interface HXSCustomAlertView : UIViewController

@property (nonatomic, strong) NSString   *titleStr;
@property (nonatomic, strong) NSString   *messageStr;
@property (nonatomic, copy)   AlertBlock leftBtnBlock;
@property (nonatomic, copy)   AlertBlock rightBtnBlock;

@property (nonatomic, assign) MESSAGE_LABEL_ALIGNMENT messageLabelAlignment;

// Methods

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)cancelButtonTitle
            rightButtonTitles:(NSString *)otherButtonTitle;


- (void)show;

@end

