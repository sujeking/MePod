//
//  UDMessageContentView.m
//  UdeskSDK
//
//  Created by xuchen on 16/1/18.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import "UDMessageContentView.h"
#import "UDMessageTextView.h"
#import "UDMessageInputView.h"
#import "UDMessageVoiceFactory.h"
#import "UDGeneral.h"
#import "UDFoundationMacro.h"
#import "UDTools.h"
#import "UDManager.h"
#import "UDCache.h"
#import "UIImage+UDMessage.h"
#import "UDAlertController.h"
#import "UdeskUtils.h"
#import "UDLabel.h"

#define kUDHaveBubbleMargin 10.0f // 距离气泡上下边的间隙

#define kUDVoiceMargin 20.0f // 语音间隙

#define kUDArrowMarginWidth 9.0f // 箭头宽度

#define kUDTextHorizontalBubblePadding 10.0f // 文本的水平间隙

#define kUDImageHorizontalBubblePadding 4.0f // 图片的水平间隙

#define MAXIMAGESIZE 500

@interface UDMessageContentView ()<UDLabelDelegate>

@end

@implementation UDMessageContentView

#pragma mark - Bubble view

// 计算文本实际的大小
+ (CGSize)neededSizeForText:(NSString *)text {
    
    CGSize textSize = [UDGeneral.store textSize:text fontOfSize:[UIFont systemFontOfSize:Config.contentFontSize] ToSize:CGSizeMake(UD_SCREEN_WIDTH>320?235:180, CGFLOAT_MAX)];
    
    float textfloat = [UDLabel getAttributedStringHeightWithString:text WidthValue:UD_SCREEN_WIDTH>320?235:180 delegate:nil font:[UIFont systemFontOfSize:Config.contentFontSize]];

    return CGSizeMake(textSize.width, textfloat);
}

// 计算图片实际大小
+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    
    CGSize photoSize = [UDTools setImageSize:photo];
    
    // 这里需要缩放后的size
    return photoSize;
}

// 计算语音实际大小
+ (CGSize)neededSizeForVoicePath:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration {
    // 这里的100只是暂时固定，到时候会根据一个函数来计算
    float gapDuration = (!voiceDuration || voiceDuration.length == 0 ? -1 : [voiceDuration floatValue] - 1.0f);
    CGSize voiceSize = CGSizeMake(100 + (gapDuration > 0 ? (120.0 / (60 - 1) * gapDuration) : 0), 39.09);
    return voiceSize;
}

// 计算Cell需要实际Message内容的大小
+ (CGFloat)calculateCellHeightWithMessage:(UDMessage *)message {
    CGSize size = [UDMessageContentView getBubbleFrameWithMessage:message];
    return size.height;
}

// 获取Cell需要的高度
+ (CGSize)getBubbleFrameWithMessage:(UDMessage *)message {
    
    CGSize bubbleSize;

    switch (message.messageType) {
        case UDMessageMediaTypeRich:
        case UDMessageMediaTypeText: {
            CGSize needTextSize = [UDMessageContentView neededSizeForText:message.text];
            bubbleSize = CGSizeMake(needTextSize.width + kUDTextHorizontalBubblePadding*2 + kUDArrowMarginWidth, needTextSize.height + kUDHaveBubbleMargin * 2);
            break;
        }
        case UDMessageMediaTypeVoice: {
            // 根据语音时长，设置气泡长度
            CGSize needVoiceSize = [UDMessageContentView neededSizeForVoicePath:message.voicePath voiceDuration:message.voiceDuration];
            bubbleSize = CGSizeMake(needVoiceSize.width, needVoiceSize.height);
            break;
        }
        case UDMessageMediaTypePhoto: {
            
            CGSize needPhotoSize = CGSizeMake([message.width floatValue], [message.height floatValue]);
            bubbleSize = CGSizeMake(needPhotoSize.width+kUDImageHorizontalBubblePadding*2+kUDArrowMarginWidth, needPhotoSize.height + kUDImageHorizontalBubblePadding * 2-2);
            
            break;
        }
        case UDMessageMediaTypeRedirect: {
            
            bubbleSize = CGSizeMake(UD_SCREEN_WIDTH, 20);
            
            break;
        }
            
        default:
            break;
  
    }
    
    return bubbleSize;
}

#pragma mark - Getters

// 获取气泡的位置以及大小
- (CGRect)bubbleFrame {
    // 1.先得到MessageContentView的实际大小
    CGSize bubbleSize = [UDMessageContentView getBubbleFrameWithMessage:self.message];
    
    // 2.计算起泡的大小和位置
    CGFloat paddingX = 0.0f;
    if (self.message.messageFrom == UDMessageTypeSending) {
        paddingX = CGRectGetWidth(self.bounds) - bubbleSize.width+kUDArrowMarginWidth;
    } else if (self.message.messageFrom == UDMessageTypeReceiving) {
        paddingX = -kUDArrowMarginWidth;
    }
    
    CGRect bubbleRect = CGRectMake(paddingX,kUDHaveBubbleMargin,bubbleSize.width,bubbleSize.height);

    return bubbleRect;

}

#pragma mark - Configure Methods

- (void)configureCellWithMessage:(UDMessage *)message {
    
    _message = message;
    
    //消息类型展示的空间
    [self configureBubbleImageView:message];
    //消息内容
    [self configureMessageDisplayMediaWithMessage:message];

}
//消息类型展示的空间
- (void)configureBubbleImageView:(UDMessage *)message {
    
    if (message.messageFrom == UDMessageTypeSending) {
        
        if (message.messageStatus == UDMessageSending) {
            //显示菊花，隐藏重发按钮
            _indicatorView.hidden = NO;
            [_indicatorView startAnimating];
            _messageAgainButton.hidden = YES;
        }
        else if (message.messageStatus == UDMessageFailed) {
            //显示重发按钮，隐藏菊花
            _indicatorView.hidden = YES;
            [_indicatorView stopAnimating];
            _messageAgainButton.hidden = NO;
        }
        else if (message.messageStatus == UDMessageSuccess) {
            //隐藏重发按钮，隐藏菊花
            _indicatorView.hidden = YES;
            [_indicatorView stopAnimating];
            _messageAgainButton.hidden = YES;
        }
    }
    
    switch (message.messageType) {
        case UDMessageMediaTypeVoice: {
            //设置语音时长颜色
            if (message.messageFrom == UDMessageTypeSending) {
                _voiceDurationLabel.textColor = [UIColor whiteColor];
            } else if (message.messageFrom == UDMessageTypeReceiving) {
                _voiceDurationLabel.textColor = [UIColor blackColor];
            }
            //显示语音时间
            _voiceDurationLabel.hidden = NO;
            //隐藏转接tag
            _redirectTagLabel.hidden = YES;
            
        }
        case UDMessageMediaTypeRich:
        case UDMessageMediaTypeText: {
            //气泡的图片
            _bubbleImageView.image = [UDMessageBubbleFactory bubbleImageViewForType:message.messageFrom style:UDBubbleImageViewStyleUDChat meidaType:message.messageType];
            // 显示气泡
            _bubbleImageView.hidden = NO;
            // 隐藏图片
            _photoImageView.hidden = YES;

            if (message.messageType == UDMessageMediaTypeText||message.messageType==UDMessageMediaTypeRich) {
                //显示文本消息的控件
                _textLabel.hidden = NO;
                // 隐藏语音播放动画
                _animationVoiceImageView.hidden = YES;
                // 隐藏语音
                _voiceDurationLabel.hidden = YES;
                //隐藏转接tag
                _redirectTagLabel.hidden = YES;
                
            } else {
                //隐藏文本消息的控件
                _textLabel.hidden = YES;
                
                // 对语音消息的进行特殊处理
                if (message.messageType == UDMessageMediaTypeVoice) {
                    [_animationVoiceImageView removeFromSuperview];
                    _animationVoiceImageView = nil;
                    
                    UIImageView *animationVoiceImageView = [UDMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.messageFrom];
                    [self addSubview:animationVoiceImageView];
                    _animationVoiceImageView = animationVoiceImageView;
                    _animationVoiceImageView.hidden = NO;
                } else {
                    
                    _bubbleImageView.hidden = YES;
                    _animationVoiceImageView.hidden = YES;
                }
                
                //隐藏转接tag
                _redirectTagLabel.hidden = YES;

            }
            
            break;
        }
        case UDMessageMediaTypePhoto: {
            // 显示图片
            _photoImageView.hidden = NO;
            //隐藏其它控件
            _textLabel.hidden = YES;
            //设置气泡图片
            _bubbleImageView.image = [UDMessageBubbleFactory bubbleImageViewForType:message.messageFrom style:UDBubbleImageViewStyleUDChat meidaType:message.messageType];
            //显示图片气泡
            _bubbleImageView.hidden = NO;
            //隐藏语音播放动画
            _animationVoiceImageView.hidden = YES;
            
            //隐藏转接tag
            _redirectTagLabel.hidden = YES;
            
            break;
        }
        case UDMessageMediaTypeRedirect: {
        
            // 显示图片
            _photoImageView.hidden = YES;
            //隐藏其它控件
            _textLabel.hidden = YES;
            //显示图片气泡
            _bubbleImageView.hidden = YES;
            //隐藏语音播放动画
            _animationVoiceImageView.hidden = YES;
            
            //隐藏转接tag
            _redirectTagLabel.hidden = YES;
            
            //隐藏转接tag
            _redirectTagLabel.hidden = NO;
            
            break;
        }
            
        default:
            break;
   
    }
}
//设置内容
- (void)configureMessageDisplayMediaWithMessage:(UDMessage *)message {
    
    if (message.messageType == UDMessageMediaTypeText) {
        
        if (message.messageFrom == UDMessageTypeSending) {
            _textLabel.textColor = Config.userTextColor;
        }
        else if (message.messageFrom == UDMessageTypeReceiving) {
            _textLabel.textColor = Config.agentTextColor;
        }
        _textLabel.text = message.text;

    }
    else if (message.messageType == UDMessageMediaTypePhoto) {
        
        [[UDCache sharedUDCache] queryDiskCacheForKey:message.contentId done:^(UIImage *image, UDImageCacheType cacheType) {
            
            if (image) {
                
                self.message.photo = image;
                _photoImageView.image = image;
            }
            else {
            
                NSString *newURL = [message.photoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:newURL]];
                
                NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (data) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.message.photo = [UIImage imageWithData:data];
                            _photoImageView.image = [UIImage imageWithData:data];
                        });
                        
                        [[UDCache sharedUDCache] storeImage:_photoImageView.image forKey:message.contentId];
                    }
                    
                }];
                
                [dataTask resume];
            }
         
        }];
    
    }
    else if (message.messageType == UDMessageMediaTypeVoice) {
        _voiceDurationLabel.text = [NSString stringWithFormat:@"%@\'\'", message.voiceDuration];
    }
    else if (message.messageType == UDMessageMediaTypeRedirect) {
    
        _redirectTagLabel.text = message.text;
    }
    else if (message.messageType == UDMessageMediaTypeRich) {
        
        _textLabel.textColor = Config.agentTextColor;
        
        _textLabel.text = message.text;
        if (message.richURLDictionary.count>0) {

            for (NSString *richContent in message.richArray) {
                
                [_textLabel.matchArray addObject:richContent];
            }
        }
    }
    
    [self setNeedsLayout];
}

- (void)toucheBenginUDLabel:(UDLabel *)udLabel withContext:(NSString *)context {
    
    NSString *httpUrl = context;
    
    if (self.message.messageType == UDMessageMediaTypeRich) {

        httpUrl = [self.message.richURLDictionary objectForKey:context];
    }
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:httpUrl]];
    
}

//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithUDLabel:(UDLabel *)udLabel
{
    //需要添加链接字符串的正则表达式：http:// (开发者可以根据自身需求添加正则)
    NSString *regex = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    return regex;
}

- (void)configureVoiceDurationLabelFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceFrame = _voiceDurationLabel.frame;
    voiceFrame.origin.x = (self.message.messageFrom == UDMessageTypeSending ? bubbleFrame.origin.x : bubbleFrame.origin.x - CGRectGetWidth(voiceFrame) + bubbleFrame.size.width);
    _voiceDurationLabel.frame = voiceFrame;
    _voiceDurationLabel.textAlignment = (self.message.messageFrom == UDMessageTypeSending ? NSTextAlignmentRight : NSTextAlignmentLeft);
}

- (void)configureMessageSendLoadingFrame:(CGRect)bubbleFrame {

    CGRect indicatorViewFrame = _indicatorView.frame;
    indicatorViewFrame.origin.x =  bubbleFrame.origin.x - 15;
    indicatorViewFrame.origin.y = CGRectGetMidY(bubbleFrame);
    
    _indicatorView.frame = indicatorViewFrame;
    _messageAgainButton.frame = CGRectMake(indicatorViewFrame.origin.x-10, indicatorViewFrame.origin.y-10, 20, 20);
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
                      message:(UDMessage *)message {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1、初始化气泡的背景
        if (!_bubbleImageView) {
            UIImageView *bubbleImageView = [[UIImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            bubbleImageView.userInteractionEnabled = YES;
            [self addSubview:bubbleImageView];
            _bubbleImageView = bubbleImageView;
        }
        
        // 2、初始化显示文本消息的TextView
        if (!_textLabel) {
            UDLabel *textLabel = [[UDLabel alloc] initWithFrame:CGRectZero];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.numberOfLines = 0;
            textLabel.udLabelDelegate = self;
            textLabel.font = [UIFont systemFontOfSize:Config.contentFontSize];
            [self addSubview:textLabel];
            _textLabel = textLabel;
            
        }
        
        // 3、初始化显示图片的控件
        if (!_photoImageView) {
            UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];

            [self addSubview:photoImageView];
            photoImageView.userInteractionEnabled = YES;
            _photoImageView = photoImageView;
            
        }
        
        // 4、初始化显示语音时长的label
        if (!_voiceDurationLabel) {
            UILabel *voiceDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
            voiceDurationLabel.backgroundColor = [UIColor clearColor];
            voiceDurationLabel.font = [UIFont systemFontOfSize:14.f];
            voiceDurationLabel.textAlignment = NSTextAlignmentRight;
            voiceDurationLabel.hidden = YES;
            [self addSubview:voiceDurationLabel];
            _voiceDurationLabel = voiceDurationLabel;
        }
        //菊花
        if (!_indicatorView) {
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.frame = CGRectZero;
            indicatorView.hidden = YES;
            [self addSubview:indicatorView];
            _indicatorView = indicatorView;
        }
        
        //重发按钮
        if (!_messageAgainButton) {
            
            UIButton *againButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [againButton setImage:[UIImage ud_defaultRefreshImage] forState:UIControlStateNormal];
            [againButton addTarget:self action:@selector(againButtonAction) forControlEvents:UIControlEventTouchUpInside];
            againButton.frame = CGRectZero;
            againButton.hidden = YES;
            [self addSubview:againButton];
            _messageAgainButton = againButton;
            
        }
        
        if (!_redirectTagLabel) {
            UILabel *redirectTagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            redirectTagLabel.textColor = [UIColor lightGrayColor];
            redirectTagLabel.textAlignment = NSTextAlignmentCenter;
            redirectTagLabel.font = [UIFont systemFontOfSize:13];
            redirectTagLabel.hidden = YES;
            [self addSubview:redirectTagLabel];
            _redirectTagLabel = redirectTagLabel;
        }

    }
    return self;
}
//消息重发
- (void)againButtonAction {
    
    UDAlertController *againMsgController = [UDAlertController alertWithTitle:nil message:getUDLocalizedString(@"重发该消息？")];
    [againMsgController addCloseActionWithTitle:getUDLocalizedString(@"取消") Handler:NULL];
    [againMsgController addAction:[UDAlertAction actionWithTitle:getUDLocalizedString(@"确定") handler:^(UDAlertAction * _Nonnull action) {
        
        if (![[UDTools internetStatus] isEqualToString:@"notReachable"]) {
            
            self.messageAgainButton.hidden = YES;
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ClickResendMessage object:nil userInfo:@{@"failedMessage":self.message}];
            
        }
        else {
            
            UDAlertController *notNetWork = [UDAlertController alertWithTitle:nil message:getUDLocalizedString(@"网络断开链接了！")];
            [notNetWork addCloseActionWithTitle:getUDLocalizedString(@"取消") Handler:NULL];
            [notNetWork showWithSender:nil controller:nil animated:YES completion:NULL];
            
        }

    }]];
    
    [againMsgController showWithSender:nil controller:nil animated:YES completion:NULL];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UDMessageMediaType currentType = self.message.messageType;
    
    switch (currentType) {
        case UDMessageMediaTypeRich:
        case UDMessageMediaTypeText:
        case UDMessageMediaTypeVoice: {
            // 获取实际气泡的大小
            CGRect bubbleFrame = [self bubbleFrame];
            
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat textX = bubbleFrame.origin.x + kUDTextHorizontalBubblePadding;
            if (self.message.messageFrom == UDMessageTypeReceiving) {
                textX = kUDTextHorizontalBubblePadding;
            }
            
            CGRect textFrame = CGRectMake(textX,
                                          bubbleFrame.origin.y + kUDHaveBubbleMargin,
                                          bubbleFrame.size.width - kUDTextHorizontalBubblePadding*2 - kUDArrowMarginWidth,
                                          bubbleFrame.size.height - kUDHaveBubbleMargin * 2);
            
            self.textLabel.frame = CGRectIntegral(textFrame);
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            CGFloat voiceImagePaddingX = CGRectGetMaxX(bubbleFrame) - kUDVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame);
            if (self.message.messageFrom == UDMessageTypeReceiving) {
                voiceImagePaddingX = CGRectGetMinX(bubbleFrame) + kUDVoiceMargin;
            }
            animationVoiceImageViewFrame.origin = CGPointMake(voiceImagePaddingX, CGRectGetMidY(textFrame) - CGRectGetHeight(animationVoiceImageViewFrame) / 2);  // 垂直居中
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            
            [self configureVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
            
            [self configureMessageSendLoadingFrame:bubbleFrame];
            
            break;
        }
        case UDMessageMediaTypePhoto: {
            
            CGRect bubbleFrame = [self bubbleFrame];
            
            self.bubbleImageView.frame = bubbleFrame;
            
            CGSize needPhotoSize = CGSizeMake([self.message.width floatValue], [self.message.height floatValue]);
            
            CGFloat paddingX = 0.0f;
            if (self.message.messageFrom == UDMessageTypeSending) {
                paddingX = CGRectGetWidth(self.bounds) - needPhotoSize.width-kUDImageHorizontalBubblePadding-1;
            } else if (self.message.messageFrom == UDMessageTypeReceiving) {
                paddingX = kUDImageHorizontalBubblePadding+1;
            }
            CGRect photoImageViewFrame = CGRectMake(paddingX, kUDHaveBubbleMargin+kUDImageHorizontalBubblePadding-1,needPhotoSize.width, needPhotoSize.height);
            
            self.photoImageView.frame = photoImageViewFrame;
            
            [self configureMessageSendLoadingFrame:bubbleFrame];

            break;
        }
        case UDMessageMediaTypeRedirect: {
        
            _redirectTagLabel.frame = [self bubbleFrame];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)dealloc {
    
    _message = nil;
    
    _textLabel = nil;
    
    _bubbleImageView = nil;
    
    _photoImageView = nil;
    
    _animationVoiceImageView = nil;
    
    _indicatorView = nil;
    _messageAgainButton = nil;
    
    _voiceDurationLabel = nil;
    
}

@end
