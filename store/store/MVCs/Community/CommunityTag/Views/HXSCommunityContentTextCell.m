//
//  HXSCommunityContentCell.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityContentTextCell.h"

@implementation HXSCommunityContentTextCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setPostEntity:(HXSPost *)postEntity
{
    if (nil == postEntity) {
        return;
    }
    _postEntity = postEntity;
    NSString *topicTtitleStr = [NSString stringWithFormat:@"[%@] ",postEntity.topicTitleStr];
    NSString *contentStr = postEntity.contentStr;
    
    NSString *content = [topicTtitleStr stringByAppendingString:contentStr];
    
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:content];
    
    [atts addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249/255.0f green:164/255.0f blue:0/255.0f alpha:1],
                          NSFontAttributeName:[UIFont systemFontOfSize:14]
                          } range:NSMakeRange(0, [topicTtitleStr length])];
    
    self.contentLabel.attributedText = atts;
    
    [self.contentLabel setUserInteractionEnabled:YES];
    
    [self.contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(tapContentLabel:)]];;
    [self addLongPressGestureToContentLabel];
}



/**
 *  文字点击效果  如果当前页面是【话题】则不可点击
 *
 *  @param sender
 */
- (void)tapContentLabel:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.contentLabel];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:14]
                                                                  forKey:NSFontAttributeName];

    CGSize size = [@"[搞笑]" boundingRectWithSize:CGSizeMake(320.0, 0)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:dic
                                           context:nil].size;
    
    if (point.x > 0 && point.x <= size.width) {
        if (self.loadCommunityTopicList) {
            self.loadCommunityTopicList(0);
        }
    } else {
        if (self.selectCommunityItem) {
            self.selectCommunityItem();
        }
    }
}


+ (CGFloat)getCellHeightWithText:(NSString *)contentText
{
    
    CGSize size = [contentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                            options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                            context:nil].size;


    return ceilf(size.height + 10);//10为上下约束边距
}


#pragma mark private method

/**
 *  增加长按弹出框事件
 */
- (void)addLongPressGestureToContentLabel
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapContentAction:)];
    [_contentLabel addGestureRecognizer:longPressGesture];
}

- (void)longTapContentAction:(UILongPressGestureRecognizer *)longPressGesture
{
    if(longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
        HXSCommunityCommentUser *postUser = self.postEntity.postUser;
        NSNumber *userId = [[HXSUserAccount currentAccount] userID];
        
        
        UIMenuItem *menuItem = nil;
        
        if ([userId isEqual:postUser.uidNum]) {
            menuItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteMenuItemAction)];
        } else {
            menuItem = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(reportMenuItemAction)];
        }
        
        
        
        
        NSMutableArray<UIMenuItem *> *menuItemsArray = [[NSMutableArray alloc]init];
        UIMenuItem *menuCopyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyMenuItemAction)];
    
        [menuItemsArray addObject:menuCopyItem];
        [menuItemsArray addObject:menuItem];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuItemsArray];
        [menu setTargetRect:_contentLabel.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

/**
 *  复制
 */
- (void)copyMenuItemAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyTheContentWithEntity:)])
    {
        [self.delegate copyTheContentWithEntity:_postEntity];
    }
}

/**
 *  举报
 */
- (void)reportMenuItemAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reportTheContentWithEntity:)])
    {
        [self.delegate reportTheContentWithEntity:_postEntity];
    }
}

/**
 *  删除
 */
- (void)deleteMenuItemAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteTheContentWithEntity:)])
    {
        [self.delegate deleteTheContentWithEntity:_postEntity];
    }
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyMenuItemAction) || action == @selector(reportMenuItemAction) || action == @selector(deleteMenuItemAction))
    {
        return YES;
    }
    
    return NO; //隐藏系统默认的菜单项
}

@end
