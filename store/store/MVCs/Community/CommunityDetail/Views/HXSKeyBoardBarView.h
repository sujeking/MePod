//
//  HXSKeyBoardBarView.h
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSKeyBoardBarView : UIView<UITextViewDelegate>

@property (nonatomic, copy) void (^sendReplayTextBlock)(NSString *replayText);  //点击发送回调
@property (nonatomic, weak) IBOutlet UITextView *inputTextView;//输入框
@property (nonatomic, weak) IBOutlet UIButton   *sendButton;//发送按钮
@property (nonatomic, strong) UILabel  *placeholderLabel;//提示label
@property (nonatomic, strong) NSString *commentedTitle;//被回复的标题【用户名或者帖子】
@property (nonatomic, strong) UIButton *delButton;
/**
 *  重置
 */
- (void)resetInuptTextView;
@end
