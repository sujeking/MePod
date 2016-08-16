//
//  HXSCommunittyItemReplyItemTitleTableViewCell.m
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunittyItemReplyItemTitleTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+Extension.h"
#import "UIButton+HXSUIButoonHitExtensions.h"
#import "HXSLineView.h"
//链接颜色
#define kLinkAttributes     @{(__bridge NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor colorWithHexString:@"0x3e688a"].CGColor}
#define kLinkAttributesActive       @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[[UIColor colorWithHexString:@"0x3e688a"] CGColor]}

@interface HXSCommunittyItemReplyItemTitleTableViewCell()

@property (nonatomic, strong) NSString *commmnetedUserNameStr;//被回复人的名称

@property (nonatomic, strong) NSString *oldCommentContentStr ;//评论的内容


@end

static NSString *mainContentStr = @"";

@implementation HXSCommunittyItemReplyItemTitleTableViewCell

- (void)awakeFromNib {
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.replyContentLabel.delegate = self;
    self.replyContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.replyContentLabel.numberOfLines = 0;
    self.replyContentLabel.font = [UIFont systemFontOfSize:14];
    
    self.userProfileImageView.layer.cornerRadius = 15;
    self.userProfileImageView.layer.masksToBounds = YES;
    

    self.userProfileImageView.userInteractionEnabled = YES;
    self.userNickNameLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadCommentUserCenterActiion)];
    UITapGestureRecognizer *tapNicknameGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadCommentUserCenterActiion)];
    
    [self.userProfileImageView addGestureRecognizer:tapGestureRecognizer];
    [self.userNickNameLabel addGestureRecognizer:tapNicknameGestureRecognizer];

    [_replyOrDeleteButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];//增加按钮热点
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  回复操作
 */
- (void)replyCommunityAction
{
    if(self.replyActionBlock) {
        self.replyActionBlock();
    }
}


/**
 *  删除回复
 */
- (void)deleteCommentAction
{
    if (self.deleteCommentActionBlock) {
        self.deleteCommentActionBlock();
    }
}


- (void)setCommentEntity:(HXSComment *)commentEntity
{
    HXSCommunityCommentUser *communityCommentUser = commentEntity.commentUser;      //评论的人
    HXSCommunityCommentUser *communityCommentedUser = commentEntity.commentedUser;  //被评论的人
    
    _commentEntity = commentEntity;
    
    NSString *contentStr = commentEntity.contentStr; //回复的内容
    //NSString *commentedContentStr = commentEntity.commentedContentStr;//被回复的内容
    
    NSString *userId = [[[HXSUserAccount currentAccount] userID] stringValue];
    if ([userId isEqualToString:[communityCommentUser.uidNum stringValue]]) {
        [self.replyOrDeleteButton setImage:[UIImage imageNamed:@"ic_delete_small"] forState:UIControlStateNormal];
        [self.replyOrDeleteButton removeTarget:self action:@selector(replyCommunityAction) forControlEvents:UIControlEventTouchUpInside];
        [self.replyOrDeleteButton addTarget:self
                                     action:@selector(deleteCommentAction)
                           forControlEvents:UIControlEventTouchUpInside];

    } else {
        [self.replyOrDeleteButton setImage:[UIImage imageNamed:@"ic_huifu"] forState:UIControlStateNormal];
        [self.replyOrDeleteButton removeTarget:self action:@selector(deleteCommentAction) forControlEvents:UIControlEventTouchUpInside];
        [self.replyOrDeleteButton addTarget:self
                                     action:@selector(replyCommunityAction)
                           forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
   [self.userProfileImageView sd_setImageWithURL:[NSURL URLWithString:communityCommentUser.userAvatarStr] placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]];
    
    self.userNickNameLabel.text = communityCommentUser.userNameStr;
    
    NSString *createTimeStr = [self updateTimeForRow:[commentEntity.createTimeLongNum integerValue]];
    
    self.replyTimeLabel.text = createTimeStr;
    
    [_replyContentLabel setText:@""];
    
    if(!communityCommentedUser)
    {
        mainContentStr = contentStr;
        
        [self.replyContentLabel setText:mainContentStr];
    }
    else
    {
        [self configTheContentLabelForCommentedWithComment:commentEntity];
    }
    
    [self addLongPressGestureToContentLabel];
    
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    if ([[components objectForKey:@"actionStr"] isEqualToString:@"gotoUserVC"])
    {
        [self loadCommentUserCenterActiion];
    }
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if ([url isEqual:[NSURL URLWithString:@"loadToUserCenter"]]) {
        [self loadCommentUserCenterActiion];
    }
}




/**
 *  进入评论者中心
 */
- (void)loadCommentUserCenterActiion
{
    if (self.loadCommentUserCenterActionBlock) {
 
        self.loadCommentUserCenterActionBlock();
    }
}


#pragma mark -

+ (CGFloat)getCellHeightWithCommentText:(NSString *)contentText
{
    CGSize size = [contentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 75, MAXFLOAT)
                                            options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                            context:nil].size;
    
    
    return ceilf(size.height);
}

/**
 *  设置"回复"的回复的内容
 *
 *  @param communityCommentedUser 回复的人
 */
- (void)configTheContentLabelForCommentedWithComment:(HXSComment *)comment
{
    HXSCommunityCommentUser *communityCommentedUser = comment.commentedUser;
    NSString *commentedContentStr = comment.commentedContentStr;//被回复的内容
    NSString *commentedUserNameStr = [NSString stringWithFormat:@"//回复%@:",communityCommentedUser.userNameStr];
    NSString *mainContentStr = [NSString stringWithFormat:@"%@%@%@",comment.contentStr,commentedUserNameStr,commentedContentStr];
    _replyContentLabel.linkAttributes = kLinkAttributes;
    _replyContentLabel.activeLinkAttributes = kLinkAttributesActive;
    _replyContentLabel.delegate = self;
    [_replyContentLabel setText:mainContentStr];
    [_replyContentLabel addLinkToTransitInformation:@{@"actionStr" : @"gotoUserVC"} withRange:[mainContentStr rangeOfString:communityCommentedUser.userNameStr]];
}

#pragma mark private method

/**
 *  增加长按弹出框事件
 */
- (void)addLongPressGestureToContentLabel
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapContentAction:)];
    [_replyContentLabel addGestureRecognizer:longPressGesture];
}

- (void)longTapContentAction:(UILongPressGestureRecognizer *)longPressGesture
{
    HXSCommunityCommentUser *communityCommentUser = _commentEntity.commentUser;
    NSString *userId = [[[HXSUserAccount currentAccount] userID] stringValue];
    if ([userId isEqualToString:[communityCommentUser.uidNum stringValue]]) {
        return;
    }
    
    if(longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
        NSMutableArray<UIMenuItem *> *menuItemsArray = [[NSMutableArray alloc]init];
        UIMenuItem *menuCopyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyMenuItemAction)];
        UIMenuItem *menuReportItem = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(reportMenuItemAction)];
        [menuItemsArray addObject:menuCopyItem];
        [menuItemsArray addObject:menuReportItem];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuItemsArray];
        [menu setTargetRect:_replyContentLabel.bounds inView:_replyContentLabel];
        [menu setMenuVisible:YES animated:YES];
    }
}

/**
 *  复制
 */
- (void)copyMenuItemAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyTheContentWithComment:)])
    {
        [self.delegate copyTheContentWithComment:_commentEntity];
    }
}

/**
 *  举报
 */
- (void)reportMenuItemAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyTheContentWithComment:)])
    {
        [self.delegate reportTheContentWithComment:_commentEntity];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyMenuItemAction) || action == @selector(reportMenuItemAction))
    {
        return YES;
    }
    
    return NO; //隐藏系统默认的菜单项
}


/**
 *  日期转换
 *
 *  @param timeInterval
 *
 *  @return
 */
- (NSString *)updateTimeForRow:(NSInteger)timeInterval {
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建时间戳
    NSTimeInterval createTime = timeInterval;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转分钟
    NSInteger minutes = time/60;
    if (minutes < 60) {
        if(minutes == 0){
            
            return @"刚刚";
        } else {
            
            return [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
        }
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    
    //秒转天数
    NSInteger days = time/3600/24;
    if(days >= 6) {
        
        return @"6天前";
    } else {
        
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
}


@end
