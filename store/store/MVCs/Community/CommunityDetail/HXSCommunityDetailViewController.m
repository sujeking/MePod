//
//  HXSCommunityDetailViewController.m
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSCommunityDetailViewController.h"
#import "HXSCommunityPhotosBrowserViewController.h"
#import "HXSCommunityOthersCenterViewController.h"
#import "HXSLoginViewController.h"
#import "HXSSchoolPostListViewController.h"
#import "HXSCommunityReportViewController.h"
#import "HXSLoginViewController.h"
#import "HXSCommunityTopicListViewController.h"

// Views
#import "HXSCommunittyItemLikeTableViewCell.h"
#import "HXSCommunittyItemReplyItemTitleTableViewCell.h"
#import "HXSShareView.h"
#import "HXSCommunityHeadCell.h"
#import "HXSCommunityContentTextCell.h"
#import "HXSCommunityImageCell.h"
#import "HXSCommunityContentFooterTableViewCell.h"
#import "HXSKeyBoardBarView.h"
#import "HXSNoCommentView.h"
#import "HXSPromptToolView.h"
#import "HXSActionSheet.h"
#import <MBProgressHUD.h>

// Model
#import "HXSCommunityTagModel.h"
#import "HXSCommunityModel.h"
#import "HXSCommunityMyReplyModel.H"
#import "HXSCommunityTopicsModel.h"

typedef NS_ENUM(NSInteger, CommunittyItem)
{
    CommunittyItem_head = 0,                // 帖子标题【发帖人头像，名称，学校】
    CommunittyItem_contentText,             // 帖子内容 文字
    CommunittyItem_contentImg,              // 帖子内容 图片
    CommunittyItem_like = 4,                // 点赞
    CommunittyItem_replyTitle,              // 回复标题【全部回复】
    CommunittyItem_replyItemTitle,          // 回复人的标题【名称，时间，头像，回复按钮[或删除按钮]】
    CommunittyItem_replyitemContent         // 回复内容
};

typedef NS_ENUM(NSInteger, CommunityDetailSection)
{
    CommunityDetailSection_Content = 0,// 帖子内容部分
    CommunityDetailSection_Reply,             // 帖子评论部分
};


static NSString * const kCommunittyItemLikeTableviewCell          = @"HXSCommunittyItemLikeTableViewCell";
static NSString * const kCommunityHeadCell                        = @"HXSCommunityHeadCell";
static NSString * const kCommunityContenttextCell                 = @"HXSCommunityContentTextCell";
static NSString * const kCommunityContentfootertableviewCell      = @"HXSCommunityContentFooterTableViewCell";
static NSString * const kCommunityImageCell                       = @"HXSCommunityImageCell";
static NSString * const kCommunityItemReplyItemTitleTableviewCell = @"HXSCommunittyItemReplyItemTitleTableViewCell";
static NSString * const kSharedefultImageurl                      = @"http://community-59store.img-cn-hangzhou.aliyuncs.com/e5ff26c9250d4274be5c79a3bc370252.png";

static CGFloat const TextSingLineHeight                = 18;//回复内容单行高度
static CGFloat const ReplyItemTitleTableViewCellHeight = 104;//默认回复cell高度
static CGFloat const NormalSectionHeaderHeight         = 40;//sectionheader 高度
static CGFloat const NormalSectionFooterHeight         = 40;//sectionfooter 高度
static CGFloat const NoReplySectionFooterHeight        = 400;//没有评论的时候 sectionfooter 高度

@interface HXSCommunityDetailViewController ()<HXSCommunityPhotosBrowserViewControllerDelegate,
                                                HXSCommunittyItemReplyItemTitleTableViewCellDelegate,
                                                HXSCommunityContentTextCellDelegate>

@property (nonatomic, weak  ) IBOutlet UITableView          *mTableView;
@property (nonatomic, strong) HXSShareView                  *shareView;             // 分享界面
@property (nonatomic, strong) HXSKeyBoardBarView            *keyBoardBarView;

@property (nonatomic, strong) HXSPromptToolView             *promptToolView;
@property (nonatomic, strong) NSString                      *postIdStr;
@property (nonatomic, strong) NSMutableArray                *commentArray;          // 评论数组

@property (nonatomic, strong)  NSLayoutConstraint           *attributeBottom;
@property (nonatomic, strong) NSString                      *mainContentStr;

@property (nonatomic, strong) NSNumber                      *pageNum;
@property (nonatomic, strong) NSNumber                      *commnetedUidNum;
@property (nonatomic, strong) NSString                      *commentedContentStr;
@property (nonatomic, strong) NSNumber                      *commneteCountNum;      // 评论数量；
@property (nonatomic ,strong) UIBarButtonItem               *postBarButton;         // 右上角提交按钮
@property (nonatomic, strong) HXSActionSheet                *actionSheet;


/**
 *  是否为点击回复进入  如果是  则自动弹起键盘
 */
@property (nonatomic, assign) BOOL isReplyLoad;
/**
 *  帖子id
 */
@property (nonatomic, strong) HXSPost *postEntitty;
//设置返回页面
@property (nonatomic, copy) void (^popToLastViewController)();

@end

@implementation HXSCommunityDetailViewController





+ (instancetype)createCommunityDetialVCWithPostID:(NSString *)postIDStr
                                        replyLoad:(BOOL)isReplyLoad
                                              pop:(void (^)(void))popToLastViewController
{
    HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController controllerFromXib];
    
    communityDetailViewController.postIdStr = postIDStr;
    communityDetailViewController.isReplyLoad = isReplyLoad;
    communityDetailViewController.popToLastViewController = popToLastViewController;
    
    
    if (0 != [communityDetailViewController.commentArray count]) {
        [communityDetailViewController.commentArray removeAllObjects];
    }
    
    return communityDetailViewController;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTheNavigationBar];
    
    [self setupkeyBoardView];
    
    [self tableViewRegisterNib];

    [self addKeyBoardNotificationObserver];
    
    [self loadConmunityDetail];
    
    [self setupPromptToolView];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isReplyLoad) {
        
        [self setCommentTheCommunityWithPlaceHodlerString:@"我也说一句"];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    self.keyBoardBarView = nil;
}

#pragma mark - Intial Methods

- (void)initTheNavigationBar
{
    self.navigationItem.title = @"帖子详情";
    
    [self.navigationItem setRightBarButtonItem:self.postBarButton];
    
    [self.navigationItem.leftBarButtonItem setAction:@selector(popToLastViewControll)];
}

/**
 *  添加键盘通知
 */
- (void)addKeyBoardNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//返回按钮点击事件
- (void)popToLastViewControll
{
    if (self.popToLastViewController) {
        self.popToLastViewController();
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
*  键盘消失事件
*/
- (void)keyBoardDidHidden:(NSNotification *)notification
{
    [self.view endEditing:YES];
    self.keyBoardBarView.hidden = YES;
    [self.keyBoardBarView resetInuptTextView];
}

/**
 *  回复框回去焦点
 */
- (void)keyBoardDidShow:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    
    CGRect keyBoardFrame = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    self.attributeBottom.constant = -keyBoardFrame.size.height;

    self.keyBoardBarView.hidden = NO;
}

- (void)setPostEntitty:(HXSPost *)postEntitty
{
    _postEntitty = postEntitty;
    
    self.postIdStr = postEntitty.idStr;
}


/**
 *  提交帖子回复内容到服务器
 *
 *  @param commentContent
 */
- (void)commitCommentPostToserver:(NSString *)commentContent
{
    [self.view endEditing:YES];
    
    if (commentContent.length > 120) {
        commentContent = [commentContent substringToIndex:120];
    }
    
    self.keyBoardBarView.hidden = YES;

    [self.keyBoardBarView resetInuptTextView];
    
    __weak typeof(self) weakSelf = self;
    
    [HXSCommunityTagModel communityAddCommentWithPostId:self.postEntitty.idStr content:commentContent complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
        if (code == kHXSNoError) {
            HXSComment *commentEntity = [HXSComment objectFromJSONObject:dic[@"comment"]];
            [weakSelf.commentArray insertObject:commentEntity atIndex:0];
            [weakSelf.mTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
            [weakSelf.promptToolView setCommentCount:@(weakSelf.commneteCountNum.intValue + 1)];
            
            weakSelf.commneteCountNum=@(weakSelf.commneteCountNum.intValue + 1);
        }
       else
        {
            
            
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                              message:message
                                                                      leftButtonTitle:nil
                                                                    rightButtonTitles:@"确定"];
            
            
            [alertView show];
        }
    }];
}

/**
 *  回复人的回复
 *
 *  @param commentContent
 *  @param userId
 *  @param content
 */
- (void)commitCommentUserToServer:(NSString *)commentContent
                  CommentedUserId:(NSNumber *)userId
                 CommentedContent:(NSString *)content
{
    [self.view endEditing:YES];
    
    [self.keyBoardBarView resetInuptTextView];
    
    self.keyBoardBarView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [HXSCommunityTagModel communityAddCommentWithPostId:self.postEntitty.idStr
                                                content:commentContent
                                        commentedUserId:userId
                                       commentedContent:content complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                           if (code == kHXSNoError) {
                                           HXSComment *commentEntity = [HXSComment objectFromJSONObject:dic[@"comment"]];
                                               
                                           [weakSelf.commentArray insertObject:commentEntity atIndex:0];

                                               [weakSelf.mTableView reloadData];
                                           
                                               [weakSelf.promptToolView setCommentCount:@([weakSelf.commentArray count])];
                                           }
    }];
}



/**
 *  设置一个隐藏的输入框
 */
- (void)setupkeyBoardView
{
    self.keyBoardBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:self.keyBoardBarView aboveSubview:self.mTableView];
    
    NSLayoutConstraint *attributeLeading = [NSLayoutConstraint constraintWithItem:self.keyBoardBarView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1
                                                                        constant:0];
    NSLayoutConstraint *attributeTrailing = [NSLayoutConstraint constraintWithItem:self.keyBoardBarView
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1
                                                                         constant:0];
    
    NSLayoutConstraint *attributeBottom = [NSLayoutConstraint constraintWithItem:self.keyBoardBarView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:100];

    NSLayoutConstraint *attributeheight = [NSLayoutConstraint constraintWithItem:self.keyBoardBarView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0
                                                                         constant:48];
    [self.view addConstraint:attributeLeading];
    [self.view addConstraint:attributeTrailing];
    [self.view addConstraint:attributeBottom];
    [self.view addConstraint:attributeheight];
    _attributeBottom = attributeBottom;
}

/**
 *  设置工具View 【评论、点赞、分享】
 */
-(void)setupPromptToolView
{
    __weak typeof(self) weakSelf = self;
    self.promptToolView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSPromptToolView class])
                                                                      owner:nil
                                                                    options:nil].firstObject;
    
    [self.promptToolView setShareTheCommunity:^{
        [weakSelf shareTheCommutity];
    }];
    
    [self.promptToolView setLikeTheCommunity:^{
        [weakSelf setLikeTheCommunity];
    }];
    
    [self.promptToolView setCommentTheCommunity:^{
        [weakSelf setCommentTheCommunityWithPlaceHodlerString:@"我也说一句"];
    }];
    
    [self.view insertSubview:self.promptToolView atIndex:99];
    
    self.promptToolView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *promptToolViewDict = @{@"promptToolView":self.promptToolView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[promptToolView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:promptToolViewDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[promptToolView(==45)]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:promptToolViewDict]];
}

/**
 *  注册cell
 */
- (void)tableViewRegisterNib
{
    __weak typeof(self) weakSelf = self;
    
    [self.mTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreComment];
    }];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityHeadCell bundle:nil]
          forCellReuseIdentifier:kCommunityHeadCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityContenttextCell bundle:nil]
          forCellReuseIdentifier:kCommunityContenttextCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityImageCell bundle:nil]
          forCellReuseIdentifier:kCommunityImageCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityContentfootertableviewCell bundle:nil]
          forCellReuseIdentifier:kCommunityContentfootertableviewCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunittyItemLikeTableviewCell bundle:nil]
          forCellReuseIdentifier:kCommunittyItemLikeTableviewCell];
    
    [self.mTableView registerNib:[UINib nibWithNibName:kCommunityItemReplyItemTitleTableviewCell bundle:nil]
          forCellReuseIdentifier:kCommunityItemReplyItemTitleTableviewCell];
    
    self.pageNum = @(2);  // 评论 从第二页开始
}


#pragma mark Taget Action

/**
 *  弹出举报选项
 */
- (void)postBarButtonAction:(UIBarButtonItem *)postBarButton
{
    [self.actionSheet show];
}


/**
 *  显示图片
 *
 *  @param uploadImageEntitys
 *  @param index
 *  @param tapImageView
 *  @param postEntity
 */
- (void)showCommunityImagesWith:(NSMutableArray<HXSCommunitUploadImageEntity *> *)uploadImageEntitys
                       andIndex:(NSInteger)index
                andTapImageView:(UIImageView *)tapImageView
                  andPostEntity:(HXSPost *)postEntity
{
    HXSCommunityPhotosBrowserViewController *communityPhotosBrowserViewController = [HXSCommunityPhotosBrowserViewController controllerFromXibWithModuleName:@"PhotosBrowse"];
    [communityPhotosBrowserViewController setTheOriginImageView:tapImageView];
    [communityPhotosBrowserViewController initCommunityPhotosBrowserWithImageParamArray:uploadImageEntitys
                                                                               andIndex:index
                                                                                andType:kCommunitPhotoBrowserTypeViewImage];
    [communityPhotosBrowserViewController setThePostEntity:postEntity];
    communityPhotosBrowserViewController.delegate = self;
    
    [self.tabBarController addChildViewController:communityPhotosBrowserViewController];
    [self.tabBarController.view addSubview:communityPhotosBrowserViewController.view];
    [communityPhotosBrowserViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tabBarController.view);
    }];
    [communityPhotosBrowserViewController didMoveToParentViewController:self.tabBarController];
    //[self.navigationController pushViewController:communityPhotosBrowserViewController animated:NO];
    
}

/**
 *  加载帖子详情
 */
- (void)loadConmunityDetail
{
    if ([self.commentArray count] > 0) {
        [self.commentArray removeAllObjects];
    }
    
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [HXSCommunityModel getCommunityPostDetialWithPostId:self.postIdStr complete:^(HXSErrorCode code,
                                                                                  NSString *message,
                                                                                  HXSPost *post) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        weakSelf.postEntitty = post;
        
        weakSelf.promptToolView.commentCount = weakSelf.postEntitty.commentCountLongNum;
        weakSelf.promptToolView.likeCount    = weakSelf.postEntitty.likeCountLongNum;
        weakSelf.promptToolView.shareCount = weakSelf.postEntitty.shareCountLongNum;
        weakSelf.promptToolView.postEntity   = post;
        
        weakSelf.commneteCountNum = weakSelf.postEntitty.commentCountLongNum;
        [weakSelf.commentArray addObjectsFromArray:post.commentListArr];
        
        [weakSelf.mTableView reloadData];
    }];
}

/**
 *  进入某一话题列表
 */
- (void)loadCommunityTopicListViewControllerWithTopicId:(NSString *)topicIdStr
{
    __weak typeof(self) weakSelf = self;
    
    [HXSCommunityTopicsModel getTopicInfoWithTopicId:topicIdStr complete:^(HXSErrorCode code, NSString *message, HXSTopic *topic) {
        
        HXSCommunityTopicListViewController *communityTopicListViewController = [HXSCommunityTopicListViewController createCommunityTopicListVCWithTopicID:topic.idStr title:nil delegate:nil];
        
        [weakSelf.navigationController pushViewController:communityTopicListViewController animated:YES];
    }];
}

/**
 *  分享帖子
 */
- (void)shareTheCommutity
{
    
    
    if (self.shareView) {
        
        [self.shareView close];
        self.shareView = nil;
    }
    
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    
    HXSImage *imageModel =self.postEntitty.imagesArr[0];
    
    parameter.shareTypeArr = @[@(kHXSShareTypeWechatMoments),
                               @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends),
                               @(kHXSShareTypeQQMoments),
                               @(kHXSShareTypeCopyLink)];
    
    self.shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter callBack:nil];
    self.shareView.shareParameter.titleStr = @"59社区";
    self.shareView.shareParameter.textStr = self.postEntitty.contentStr;
    self.shareView.shareParameter.imageURLStr = imageModel.urlStr.length == 0 ? kSharedefultImageurl:imageModel.urlStr;
    self.shareView.shareParameter.shareURLStr = self.postEntitty.shareLinkStr;
    [self.shareView show];
    
    [self commitShareResultToServer];
}


//将分享结果告诉服务器
- (void)commitShareResultToServer
{
    __block int shareCount = 0;
    __weak typeof(self) weakSelf = self;
    [HXSCommunityTagModel communityAddShareWithPostId:self.postEntitty.idStr complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
        shareCount = [dic[@"share_count"] intValue];
        if (shareCount != 0) {
            [weakSelf.promptToolView setShareCount:@(shareCount)];
        }
    }];
}

/**
 *  删除帖子
 */
- (void)deleteCommunity:(BOOL)isDelegateCommutnity WithRow:(NSInteger)row
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                      message:@"确定删除吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    WS(weakSelf);
    if (isDelegateCommutnity) {
        //删除帖子
        alertView.rightBtnBlock = ^{
            [weakSelf deleteThisCommunity];
        };
    } else {
        //删除回复
        alertView.rightBtnBlock = ^{
            [weakSelf deleteCommunityCommentAction:row];
        };
    }
    
    
    [alertView show];
}


//确认删除
- (void)deleteThisCommunity
{
    [MBProgressHUD showInView:self.view];
    __weak __typeof(self) weakSelf = self;
    [HXSCommunityModel communityDeletePostWithPostId:self.postEntitty.idStr complete:^(HXSErrorCode code, NSString *message, NSNumber *result_status) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (code == kHXSNoError) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

/**
 *  回复
 */
- (void)setCommentTheCommunityWithPlaceHodlerString:(NSString *)placeHodler
{
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        
        [self.keyBoardBarView setSendReplayTextBlock:^(NSString *replyContentText) {
            
            [weakSelf commitCommentPostToserver:replyContentText];
        }];
        self.keyBoardBarView.commentedTitle = placeHodler;
        [self.keyBoardBarView.inputTextView becomeFirstResponder];
        
    }else{
        self.isReplyLoad = NO;
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
    }
}

/**
 *  删除回复
 */
- (void)deleteCommunityCommentAction:(NSInteger)row
{
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    HXSCommunityMyReplyModel *replyModel = [[HXSCommunityMyReplyModel alloc] init];
    
    HXSComment *commentEntity = self.commentArray[row];
    
    [replyModel deleteTheCommentWithCommentId:commentEntity.idStr andPostId:commentEntity.postIdStr
                                     Complete:^(HXSErrorCode code, NSString *message, NSString *statusStr) {
                                         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                         if (code == kHXSNoError) {
                                             [weakSelf updateTableViewSectionRow:row];
                                             [weakSelf.promptToolView setCommentCount:@(weakSelf.commneteCountNum.intValue -1)];
                                             
                                             weakSelf.commneteCountNum = @(weakSelf.commneteCountNum.intValue - 1);
                                         }
                                     }];
}

/**
 *  删除评论之后刷新列表
 *
 *  @param row
 */
- (void)updateTableViewSectionRow:(NSInteger)row
{
    [self.mTableView beginUpdates];
    
    [self.commentArray removeObjectAtIndex:row];
    
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:row inSection:1];
    
    [self.mTableView deleteRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.mTableView endUpdates];
    
    [self.mTableView reloadData];
}


/**
 *  进入校园帖子列表
 */
- (void)loadSchoolPostViewController:(HXSPost *)postEntity
{
    HXSSchoolPostListViewController *schoolPostListViewController = [HXSSchoolPostListViewController controllerFromXib];
    
    [schoolPostListViewController initCommunitySchoolListViewControllerSiteName:postEntity.siteNameStr SiteId:postEntity.siteIdStr];
    
    [self.navigationController pushViewController:schoolPostListViewController animated:YES];
    
}

/**
 *  点赞
 */
- (void)setLikeTheCommunity
{
    if (!self.promptToolView.likeIconImageView.isUserInteractionEnabled) {
        return;
    }
    
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        [HXSCommunityTagModel communityAddLikeWithPostId:self.postEntitty.idStr
                                                complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                    if (code == kHXSNoError) {
                                                        [weakSelf.promptToolView.likeIconImageView setImage:[UIImage imageNamed:@"ic_dianzan_plus_selected"]];
                                                        NSNumber *likeCount = dic[@"like_count"];
                                                        [weakSelf.promptToolView setLikeCount:likeCount];
                                                        weakSelf.promptToolView.likeIconImageView.userInteractionEnabled = NO;
                                                        [weakSelf loadConmunityDetail];
                                                    }
                                                }];
    } else {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
    }
}

//跳转发帖人中心
- (void)loadPostUserCenterViewController:(HXSPost *)postEntity
{
    HXSCommunityOthersCenterViewController *communityOthersCenterViewController = [HXSCommunityOthersCenterViewController controllerFromXib];
    
    [communityOthersCenterViewController initCommunityOthersCenterViewControllerWithUser:postEntity.postUser];
    
    [self.navigationController pushViewController:communityOthersCenterViewController animated:YES];
    
}

/**
 *  跳转发帖人中心
 */
- (void)loadCommentUserCenterViewController:(HXSCommunityCommentUser *)commentUserEntity
{
    HXSCommunityOthersCenterViewController *communityOthersCenterViewController = [HXSCommunityOthersCenterViewController controllerFromXib];
    [communityOthersCenterViewController initCommunityOthersCenterViewControllerWithUser:commentUserEntity];
    
    [self.navigationController pushViewController:communityOthersCenterViewController animated:YES];
    
}

/**
 *  跳转到举报界面
 */
- (void)jumpToReportViewController
{
    __weak typeof(self) weakSelf = self;
    if ([HXSUserAccount currentAccount].isLogin)
    {
        HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
        [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypePost andWithID:_postEntitty.idStr];
        [self.navigationController pushViewController:reportVC animated:YES];
    }else
    {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
            [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypePost andWithID:weakSelf.postEntitty.idStr];
            [weakSelf.navigationController pushViewController:reportVC animated:YES];
        }];
    }
}


#pragma mark  - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        
        return 5;
    } else {
        
        return [self.commentArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    __weak typeof(self) weakSelf = self;
    
    switch (section) {
        case CommunityDetailSection_Content:
        {
            if (row == CommunittyItem_head) {
                
                HXSCommunityHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityHeadCell forIndexPath:indexPath];
                
                [cell setLoadSchoolCommunityBlock:^{
                    [weakSelf loadSchoolPostViewController:weakSelf.postEntitty];
                }];
                
                [cell setLoadPostUserCenter:^{
                    [weakSelf loadPostUserCenterViewController:weakSelf.postEntitty];
                }];

                
                [cell setPostEntity:self.postEntitty];
                
                return cell;
            } else if(row == CommunittyItem_contentText) {
                
                HXSCommunityContentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityContenttextCell forIndexPath:indexPath];
                cell.contentLabel.numberOfLines = 0;
                cell.contentLabel.lineBreakMode=NSLineBreakByCharWrapping;
                cell.delegate = self;
                [cell setPostEntity:self.postEntitty];
                
                [cell setLoadCommunityTopicList:^(NSInteger index) {
                    [weakSelf loadCommunityTopicListViewControllerWithTopicId:weakSelf.postEntitty.topicIdStr];
                }];
                
                return cell;
            } else if(row == CommunittyItem_contentImg) {
                
                HXSCommunityImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityImageCell forIndexPath:indexPath];

                [cell setPostDetailEntity:self.postEntitty];
                [cell setShowImages:^(NSMutableArray<HXSCommunitUploadImageEntity *> *uploadImageEntitys, NSInteger index, UIImageView *imageView) {
                    [weakSelf showCommunityImagesWith:uploadImageEntitys
                                             andIndex:index
                                      andTapImageView:imageView
                                        andPostEntity:_postEntitty];
                }];
                
                return cell;
            } else if(row == CommunittyItem_like) {
                
                HXSCommunittyItemLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunittyItemLikeTableviewCell forIndexPath:indexPath];
                [cell setLikeListArr:self.postEntitty.likeListArr];
                
                return cell;
            } else {
                HXSCommunityContentFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityContentfootertableviewCell forIndexPath:indexPath];
                
                [cell setPostEntity:self.postEntitty];
                
                [cell setDeleteCommunity:^{
                    [weakSelf deleteCommunity:YES WithRow:0];
                }];
                
                return cell;
            }
            
        }
            break;
            
        case CommunityDetailSection_Reply:
        {
            // 评论
            HXSCommunittyItemReplyItemTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityItemReplyItemTitleTableviewCell forIndexPath:indexPath];

            [cell setCommentEntity:self.commentArray[row]];
            
            cell.delegate = self;
            
            [cell setReplyActionBlock:^{
                //回复操作
                HXSComment *commentEntity = weakSelf.commentArray[row];
                HXSCommunityCommentUser *user = [commentEntity commentUser];
                
                weakSelf.commnetedUidNum = commentEntity.commentedUidLongNum;
                weakSelf.commentedContentStr = commentEntity.commentedContentStr;
                
                
                
                [self setCommentTheCommunityWithPlaceHodlerString:[NSString stringWithFormat:@"回复%@",user.userNameStr]];
                [self.keyBoardBarView setSendReplayTextBlock:^(NSString *commentContent) {
                    
                    HXSComment *commentEntity = weakSelf.commentArray[row];
                    
                    [weakSelf commitCommentUserToServer:commentContent
                                        CommentedUserId:commentEntity.commentUidLongNum
                                       CommentedContent:commentEntity.contentStr];
                }];
                
                
            }];
            
            [cell setDeleteCommentActionBlock:^{
                [weakSelf deleteCommunity:NO WithRow:row];
            }];
            
            [cell setLoadCommentUserCenterActionBlock:^{
                
                HXSComment *commentEntity = weakSelf.commentArray[row];
                HXSCommunityCommentUser *commentUsr = commentEntity.commentUser;
                [weakSelf loadCommentUserCenterViewController:commentUsr];
            }];
            
            return cell;

        }
            break;
        default:
            break;
    }
    return nil;
}

//加载更多评论
- (void)loadMoreComment
{
    __weak typeof(self) weakSelf = self;
    [HXSCommunityTagModel getCommunityCommentListWithPostId:self.postIdStr page:self.pageNum  complete:^(HXSErrorCode code, NSString *message, NSArray *comments) {
        
        if (code == kHXSNoError) {
            
            NSInteger page = weakSelf.pageNum.integerValue;
            
            page++;
            
            weakSelf.pageNum = @(page);
            
            [weakSelf.commentArray addObjectsFromArray:comments];
            
            [[weakSelf.mTableView infiniteScrollingView] stopAnimating];
            
            [weakSelf.mTableView reloadData];
        }
        
    }];
}


- (CGFloat)tableView:tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    switch (section) {
        case CommunityDetailSection_Content:
        {
            if (row == CommunittyItem_head) {
                
                return 50;
            } else if(row == CommunittyItem_contentText) {
                
                
                NSString *contentStr = [self.postEntitty.topicTitleStr stringByAppendingString:self.postEntitty.contentStr];
                
               CGFloat height = [HXSCommunityContentTextCell getCellHeightWithText:contentStr];
                
                return height;
            } else if(row == CommunittyItem_contentImg) {
                
                NSInteger count = self.postEntitty.imagesArr.count;
                
                CGFloat height = [HXSCommunityImageCell getCellHeightWithImagesCount:count];
                
                return height;
               
            } else if(row == CommunittyItem_like) {
                
                CGFloat height = [HXSCommunittyItemLikeTableViewCell getHeightForLikeCount:[self.postEntitty.likeCountLongNum intValue]];
                
                return height;

            } else {
                
                return 40;
            }
        }
            break;
            
        case CommunityDetailSection_Reply:
        {
            HXSComment *commentEntity = self.commentArray[row];
            
            NSString *commentContentStr =@"";
            CGFloat height = 0;
            if (commentEntity.commentedContentStr.length != 0)
            {
                commentContentStr = [commentEntity.contentStr stringByAppendingString:commentEntity.commentedContentStr];
                height = [HXSCommunittyItemReplyItemTitleTableViewCell getCellHeightWithCommentText:commentContentStr];
            }
            else
            {
                commentContentStr = commentEntity.contentStr;
                height = [HXSCommunittyItemReplyItemTitleTableViewCell getCellHeightWithCommentText:commentContentStr];
            }
            
            if(height > TextSingLineHeight)
            {
                return height + ReplyItemTitleTableViewCellHeight - TextSingLineHeight;
            }
            else
            {
                return ReplyItemTitleTableViewCellHeight;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return NormalSectionHeaderHeight;
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (CommunityDetailSection_Reply == section)
    {
        if (self.commentArray.count != 0)
        {
            return NormalSectionFooterHeight;
        }
        else
        {
            return NoReplySectionFooterHeight;
        }
    }
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        UIView *sectionTitleView = [[NSBundle mainBundle] loadNibNamed:@"HXSReplySectionTitle"
                                                                 owner:nil
                                                               options:nil][0];
        return sectionTitleView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (1 == section) {
        
        if (self.commentArray.count == 0) {
            HXSNoCommentView *noCommentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSNoCommentView class])
                                                                            owner:nil
                                                                          options:nil].firstObject;
            return noCommentView;
        } else {
            return nil;
        }
        
    }
    return nil;
}



- (void)tableView:tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    self.keyBoardBarView.hidden = YES;
    [self.keyBoardBarView resetInuptTextView];
}

#pragma mark HXSCommunityContentTextCellDelegate

- (void)copyTheContentWithEntity:(HXSPost *)postEntity
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = postEntity.contentStr;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]];
    [MBProgressHUD showInView:self.view
                   customView:imageView
                       status:@"复制成功"
                   afterDelay:0.5];
}

- (void)reportTheContentWithEntity:(HXSPost *)postEntity
{
    __weak typeof(self) weakSelf = self;
    if ([HXSUserAccount currentAccount].isLogin)
    {
        HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
        [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypePost andWithID:postEntity.idStr];
        [self.navigationController pushViewController:reportVC animated:YES];
    }
    else
    {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
            [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypePost andWithID:postEntity.idStr];
            [weakSelf.navigationController pushViewController:reportVC animated:YES];
        }];
    }
}

#pragma mark HXSCommunittyItemReplyItemTitleTableViewCellDelegate

- (void)copyTheContentWithComment:(HXSComment *)commentEntity
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = commentEntity.contentStr;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]];
    [MBProgressHUD showInView:self.view
                   customView:imageView
                       status:@"复制成功"
                   afterDelay:0.5];
}

- (void)reportTheContentWithComment:(HXSComment *)commentEntity
{
    __weak typeof(self) weakSelf = self;
    if ([HXSUserAccount currentAccount].isLogin)
    {
        HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
        [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypeComment andWithID:commentEntity.idStr];
        [self.navigationController pushViewController:reportVC animated:YES];
    }
    else
    {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
            [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypeComment andWithID:commentEntity.idStr];
            [weakSelf.navigationController pushViewController:reportVC animated:YES];
        }];
    }
}

#pragma mark HXSCommunityPhotosBrowserViewControllerDelegate

- (void)reportThePhotoWithEntity:(HXSPost *)entity
{
    [self jumpToReportViewController];
}

#pragma mark - Get Set Methods
- (UIBarButtonItem *)postBarButton
{
    if(!_postBarButton)
    {
        _postBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_gengduo"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(postBarButtonAction:)];
    }
    return _postBarButton;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet)
    {
        WS(weakSelf);
        
        HXSActionSheetEntity *reportEntity = [[HXSActionSheetEntity alloc] init];
        NSString *userId = [[[HXSUserAccount currentAccount] userID] stringValue];
        HXSActionHandler actionHandler = nil;
        
        
        if ([userId isEqualToString:self.postEntitty.postUser.uidNum.stringValue]) {
            
            reportEntity.nameStr = @"删除";
            actionHandler =^(HXSAction *action){
                [weakSelf deleteCommunity:YES WithRow:0];
            };

        } else {
            
            reportEntity.nameStr = @"举报";
            actionHandler =^(HXSAction *action){
                [weakSelf jumpToReportViewController];
            };

        }

        HXSAction *savePhotoAction = [HXSAction actionWithMethods:reportEntity
                                                          handler:actionHandler];
        _actionSheet = [HXSActionSheet actionSheetWithMessage:@""
                                            cancelButtonTitle:@"取消"];
        [_actionSheet addAction:savePhotoAction];
    }
    return _actionSheet;
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (HXSKeyBoardBarView *)keyBoardBarView
{
    if (!_keyBoardBarView) {
        
        _keyBoardBarView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSKeyBoardBarView class])
                                                         owner:nil
                                                       options:nil].firstObject;
        
        _keyBoardBarView.hidden = YES;
    }
    
    return _keyBoardBarView;
}


@end
