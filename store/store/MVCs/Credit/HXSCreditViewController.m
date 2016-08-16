//
//  HXSCreditViewController.m
//  store
//
//  Created by ArthurWang on 16/2/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditViewController.h"

// control
#import "HXSWebViewController.h"
#import "HXSBindTelephoneController.h"
#import "HXSSubscribeViewController.h"
#import "HXSUpgradeCreditViewController.h"
#import "HXSDigitalMobileViewController.h"
#import "HXSCreditWalletViewController.h"
#import "HXSUpdateWalletViewController.h"

// view
#import "HXSCreditCollectionViewCell.h"
#import "HXSCreditCollectionReusableView.h"
#import "HXSCreditCollectionFooterReusableView.h"
#import "HXSBannerLinkHeaderView.h"
#import "HXSAmountCollectionViewCell.h"
#import "HXSPromptCollectionViewCell.h"
#import "HXSEncashmentCollectionViewCell.h"
#import "HXSPopView.h"
#import "HXSCreditUpdatePopContentView.h"

// model
#import "HXSSlideItem.h"
#import "HXSFinanceOperationManager.h"
#import "HXSShopViewModel.h"
#import "HXSCreditViewModel.h"
// common
#import "HXSLoadingView.h"
#import "NSDate+Extension.h"

static NSString * const kUserDefaultDisplayUpgradeViewDay = @"display_upgrade_view_day";
static NSInteger const kColumnPerRow                      = 2;

typedef NS_ENUM(NSUInteger, HXSCreditSection) {
    HXSCreditSectionEncashment = 0,
    HXSCreditSectionBanner     = 1,

    HXSCreditSectionTotalCount = 2,
};

typedef NS_ENUM(NSUInteger, HXSCreditEncashmentSection) {
    HXSCreditEncashmentSectionAmount     = 0,
    HXSCreditEncashmentSectionPrompt     = 1,
    HXSCreditEncashmentSectionEncashment = 2,

    HXSCreditEncashmentSectionCells      = 3,
};

static NSString *CreditCollectionReusableView                 = @"HXSCreditCollectionReusableView";
static NSString *CreditCollectionReusableViewIdentifier       = @"HXSCreditCollectionReusableView";
static NSString *CreditCollectionFooterReusableView           = @"HXSCreditCollectionFooterReusableView";
static NSString *CreditCollectionFooterReusableViewIdentifier = @"HXSCreditCollectionFooterReusableView";
static NSString *CreditCollectionViewCell                     = @"HXSCreditCollectionViewCell";
static NSString *CreditCollectionViewCellIdentifier           = @"HXSCreditCollectionViewCell";

static NSInteger const  kHeightAmountView  =   57;
static NSInteger const  kHeightPromptView  =   40;
static NSInteger const  kHeightEncashmentView = 300;

@interface HXSCreditViewController () <UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout,
                                        HXSBannerLinkHeaderViewDelegate,
                                        HXSEncashmentCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *creditCollectionView;

@property (nonatomic, strong) HXSShopViewModel                          *shopModel;
@property (nonatomic, strong) HXSCreditViewModel                        *creditViewModel;
@property (nonatomic, strong) NSArray<HXSStoreAppEntryEntity *>         *middleEntriesArr;
@property (nonatomic, strong) NSArray<HXSStoreAppEntryEntity *>         *bottomEntriesArr;
@property (nonatomic, strong) NSArray<HXSCreditCardLoanInfoModel *>     *loanInfoArr;

@property (nonatomic, strong) HXSCreditCollectionReusableView       *headerView;
@property (nonatomic, strong) HXSCreditCollectionFooterReusableView *footerView;

@property (nonatomic, assign) BOOL amountLayoutExpand;


@end

@implementation HXSCreditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialCollectionView];
    
    /* Don't used in version 5.0
    [self initialNotification];
    
    [self initialCreditStatus];
    
    [self initialLoadingData];
    
    [self displayUpgradeAlertView];
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"花不完";
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_queations"] style:UIBarButtonItemStylePlain target:self action:@selector(borronInfoBtnPressed:)];
    
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)initialCollectionView
{
    [self.creditCollectionView registerNib:[UINib nibWithNibName:CreditCollectionViewCell bundle:nil]
                forCellWithReuseIdentifier:CreditCollectionViewCellIdentifier];
    [self.creditCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSAmountCollectionViewCell class]) bundle:nil]
                forCellWithReuseIdentifier:NSStringFromClass([HXSAmountCollectionViewCell class])];
    [self.creditCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPromptCollectionViewCell class]) bundle:nil]
                forCellWithReuseIdentifier:NSStringFromClass([HXSPromptCollectionViewCell class])];
    [self.creditCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSEncashmentCollectionViewCell class]) bundle:nil]
                forCellWithReuseIdentifier:NSStringFromClass([HXSEncashmentCollectionViewCell class])];
    [self.creditCollectionView registerNib:[UINib nibWithNibName:CreditCollectionReusableView bundle:nil]
                forCellWithReuseIdentifier:CreditCollectionReusableViewIdentifier];
    [self.creditCollectionView registerNib:[UINib nibWithNibName:CreditCollectionFooterReusableView bundle:nil]
                forCellWithReuseIdentifier:CreditCollectionFooterReusableViewIdentifier];
    
    [self.creditCollectionView setAlwaysBounceVertical:YES];
    
    __weak typeof(self) weakSelf = self;
    [self.creditCollectionView addRefreshHeaderWithCallback:^{
        [weakSelf refreshCreditData];
    }];
}

- (void)initialNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLoginComplete:)
                                                 name:kLoginCompleted
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutComplete:)
                                                 name:kLogoutCompleted
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInfo:)
                                                 name:kUserInfoUpdated
                                               object:nil];
}

- (void)initialCreditStatus
{
    self.amountLayoutExpand = NO;
}

- (void)initialLoadingData
{
    // Show the loading view at first time
    [HXSLoadingView showLoadingInView:self.view];
    
    [self refreshCreditData];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeZero;
    
    switch (indexPath.section) {
        case HXSCreditSectionEncashment:
        {
            switch (indexPath.row) {
                case HXSCreditEncashmentSectionAmount:
                {
                    if (self.amountLayoutExpand) {
                        itemSize = CGSizeMake(SCREEN_WIDTH, kHeightAmountView);
                    } else {
                        itemSize = CGSizeMake(SCREEN_WIDTH, 0.01f);
                    }
                }
                    break;
                    
                case HXSCreditEncashmentSectionPrompt:
                {
                    BOOL display = [HXSPromptCollectionViewCell shouldDisplayPromptView];
                    if (display) {
                        itemSize = CGSizeMake(SCREEN_WIDTH, kHeightPromptView);
                    } else {
                        itemSize = CGSizeMake(SCREEN_WIDTH, 0.01f);
                    }
                }
                    break;
                    
                case HXSCreditEncashmentSectionEncashment:
                {
                    itemSize = CGSizeMake(SCREEN_WIDTH, kHeightEncashmentView);
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case HXSCreditSectionBanner:
        {
            CGFloat width = SCREEN_WIDTH / kColumnPerRow;
            CGFloat height = width * 120 / 187;  // UI Designer set width 187 & height 120
            
            itemSize = CGSizeMake(width, ceil(height));
        }
            break;
            
        default:
            break;
    }
    
    return itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (HXSCreditSectionEncashment == section) {
        return CGSizeMake(SCREEN_WIDTH, HEIGHT_CREDIT_CARD_INFO_VIEW);
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (HXSCreditSectionBanner == section) {
        CGFloat width = collectionView.width;
        CGFloat height = [self heightOfBannerView];
        
        return CGSizeMake(width, height);
    }
    
    return CGSizeZero;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return HXSCreditSectionTotalCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    switch (section) {
        case HXSCreditSectionEncashment:
        {
            count = HXSCreditEncashmentSectionCells;
        }
            
            break;
            
        case HXSCreditSectionBanner:
        {
            count = [self.middleEntriesArr count];
            
            if (0 < (count % kColumnPerRow)) {
                count += kColumnPerRow - count % kColumnPerRow;
            }
        }
            
            break;
            
        default:
            break;
    }
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    switch (indexPath.section) {
        case HXSCreditSectionEncashment:
        {
            switch (indexPath.row) {
                case HXSCreditEncashmentSectionAmount:
                {
                    HXSAmountCollectionViewCell *amountCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSAmountCollectionViewCell class]) forIndexPath:indexPath];
                    
                    [amountCell updateAmountValues];
                    
                    cell = amountCell;
                }
                    break;
                    
                case HXSCreditEncashmentSectionPrompt:
                {
                    HXSPromptCollectionViewCell *promptCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSPromptCollectionViewCell class]) forIndexPath:indexPath];
                    
                    [promptCell updatePromptLabel];
                    
                    cell = promptCell;
                }
                    break;
                    
                case HXSCreditEncashmentSectionEncashment:
                {
                    HXSEncashmentCollectionViewCell *encashmentCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSEncashmentCollectionViewCell class]) forIndexPath:indexPath];
                    
                    [encashmentCell setupEncahmentCollectionViewCellWithLoanInfo:self.loanInfoArr delegate:self];
                    
                    cell = encashmentCell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case HXSCreditSectionBanner:
        {
            HXSCreditCollectionViewCell *creditCell = [collectionView dequeueReusableCellWithReuseIdentifier:CreditCollectionViewCellIdentifier
                                                                                          forIndexPath:indexPath];
            
            if (indexPath.row < [self.middleEntriesArr count]) {
                HXSStoreAppEntryEntity *slideItem = [self.middleEntriesArr objectAtIndex:indexPath.row];
                
                [creditCell setupCollectionCellWithSlideItem:slideItem];
            } else {
                [creditCell setupCollectionCellWithSlideItem:nil];
            }
            
            cell = creditCell;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (UICollectionElementKindSectionHeader == kind) {
        HXSCreditCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                         withReuseIdentifier:CreditCollectionReusableViewIdentifier
                                                                                                forIndexPath:indexPath];
        
        [headerView updateHeaderView];
        
        self.headerView = headerView;
        reusableView = headerView;
    } else if (UICollectionElementKindSectionFooter == kind) {
        HXSCreditCollectionFooterReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                               withReuseIdentifier:CreditCollectionFooterReusableView
                                                                                                      forIndexPath:indexPath];
        
        footerView.creditFooterBannerView.eventDelegate = self;
        [footerView.creditFooterBannerView setSlideItemsArray:self.bottomEntriesArr];
        
        self.footerView = footerView;
        reusableView = footerView;
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (HXSCreditSectionBanner == indexPath.section) {
        HXSStoreAppEntryEntity *slideItem = [self.middleEntriesArr objectAtIndex:indexPath.row];
        
        [self didSelectedLink:slideItem.linkURLStr];
        
        [HXSUsageManager trackEvent:@"credit_banner" parameter:@{@"title":slideItem.titleStr}];
    }
}


#pragma mark - Target Methods

- (void)login:(UIGestureRecognizer *)tap
{
    [[AppDelegate sharedDelegate].rootViewController checkIsLoggedin];
}

- (void)onClickOpreationBtn:(UIButton *)btn
{
    [btn setUserInteractionEnabled:NO];
    
    // 提升额度
    [self jumpToImproveQuota];
    
    [btn setUserInteractionEnabled:YES];
}

- (void)onClickAmountLayoutBtn:(UIButton *)button
{
    [button setUserInteractionEnabled:NO];
    
    // update amount cell
    self.amountLayoutExpand = !self.amountLayoutExpand;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:HXSCreditSectionEncashment inSection:HXSCreditEncashmentSectionAmount];
    [self.creditCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [button setUserInteractionEnabled:YES];
}

- (void)onClickOpenInTimeBtn:(UIButton *)button
{
    [button setUserInteractionEnabled:NO];
    
    // 立即开通
    [self jumpToApplyCreditVC];
    
    [button setUserInteractionEnabled:YES];
}

- (void)borronInfoBtnPressed:(id)sender
{
    NSString *url = [[ApplicationSettings instance] huaBuWanFAQURL];
    
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.navigationController pushViewController:webVc animated:YES];
    
    [HXSUsageManager trackEvent:@"credit_FQA" parameter:nil];
}


#pragma mark - Notification Methods

- (void)onLoginComplete:(NSNotification *)notification
{
    [self.creditCollectionView reloadData];
}

- (void)logoutComplete:(NSNotification *)notification
{
    [self.creditCollectionView reloadData];
}

- (void)updateUserInfo:(NSNotification *)notification
{
    [self.creditCollectionView reloadData];
    
    [self.creditCollectionView endRefreshing];
    [HXSLoadingView closeInView:self.view];
}



#pragma mark - Update Info Methods

- (void)refreshCreditData
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    __weak typeof(self) weakSelf = self;
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletCreditMiddle)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (kHXSNoError != status) {
                                                  if ([HXSLoadingView isShowingLoadingViewInView:weakSelf.view]) {
                                                      [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                                   block:^{
                                                                                       [weakSelf refreshCreditData];
                                                                                   }];
                                                  } else {
                                                      [weakSelf.creditCollectionView endRefreshing];
                                                      
                                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                         status:message
                                                                                     afterDelay:1.5f];
                                                  }
                                                  
                                                  return ;
                                              }
                                              
                                              weakSelf.middleEntriesArr = entriesArr;
                                              
                                              [self refreshCreditInlet];
                                          }];
}

- (void)refreshCreditInlet
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletCreditBottom)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              
                                              weakSelf.bottomEntriesArr = entriesArr;
                                              
                                              [weakSelf fetchLoanInfo];
                                              
                                          }];
    
}

- (void)fetchLoanInfo
{
    __weak typeof(self) weakSelf = self;
    
    [self.creditViewModel fetchLoanInfo:^(HXSErrorCode status, NSString *message, NSArray *itemsArr) {
        weakSelf.loanInfoArr = itemsArr;
        
        [weakSelf refreshCreditCardInfo];
    }];
}

- (void)refreshCreditCardInfo
{
    if ([HXSUserAccount currentAccount].isLogin) {
        [[HXSUserAccount currentAccount].userInfo updateUserInfo];
    } else {
        [self.creditCollectionView endRefreshing];
        [HXSLoadingView closeInView:self.view];
        
        [self.creditCollectionView reloadData];
    }
}

#pragma mark - HXSBannerLinkHeaderViewDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - HXSEncashmentCollectionViewCellDelegate

- (void)didSelectLoanInfo:(HXSCreditCardLoanInfoModel *)loanInfoModel
{
    // If don't login, should login at first
    if (![[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
        return;
    }
    
    NSString *messageStr = nil;
    
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    switch ([creditCardInfo.accountStatusIntNum intValue]) {
        case kHXSCreditAccountStatusNotOpen:
        {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                              message:@"别心急，您还没有开通钱包呢"
                                                                      leftButtonTitle:@"取消"
                                                                    rightButtonTitles:@"去开通"];
            __weak typeof(self) weakSelf = self;
            
            alertView.rightBtnBlock = ^(void){
                [HXSUsageManager trackEvent:@"credit_open_in_alert" parameter:nil];
                
                [weakSelf jumpToApplyCreditVC];
            };
            
            [alertView show];
            
            return;
        }
            break;
            
        case kHXSCreditAccountStatusOpened:
        {
            switch ([creditCardInfo.lineStatusIntNum intValue]) {
                case kHXSCreditLineStatusInit:
                {
                    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                                      message:@"抱歉，您还没有取现额度，请先去提升额度吧"
                                                                              leftButtonTitle:@"取消"
                                                                            rightButtonTitles:@"提升额度"];
                    __weak typeof(self) weakSelf = self;
                    
                    alertView.rightBtnBlock = ^(void){
                        [weakSelf jumpToImproveQuota];
                        
                        [HXSUsageManager trackEvent:@"credit_upgrade_in_alert" parameter:nil];
                    };
                    
                    [alertView show];
                    
                    return;
                }
                    break;
                    
                case kHXSCreditLineStatusChecking:
                {
                    messageStr = @"请提升额度后再进行取现操作哦~";
                }
                    break;
                    
                case kHXSCreditLineStatusDone:
                {
                    if ((nil == loanInfoModel)
                        || (0.0 >= [loanInfoModel.intallmentAllDoubleNum doubleValue])) {
                        messageStr = @"同学，请选择取现金额";
                    } else {
                        [self jumpToEncashmentVC];
                    }
                }
                    break;
                    
                case kHXSCreditLineStatusFailed:
                {
                    messageStr = @"请提升额度后再进行取现操作哦~";
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case kHXSCreditAccountStatusNormalFreeze:
        case kHXSCreditAccountStatusAbnormalFreeze:
        {
            messageStr = @"您的账户已冻结，无法进行提现";
        }
            break;
            
        case kHXSCreditAccountStatusChecking:
        {
            messageStr = @"请开通钱包后再进行取现操作哦~";
        }
            break;
            
        case kHXSCreditAccountStatusCheckFailed:
        {
            messageStr = @"请开通钱包后再进行取现操作哦~";
        }
            break;
            
        default:
            break;
    }
    
    if (nil != messageStr) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:messageStr
                                       afterDelay:1.5f];
    }
}

- (void)didSelectLoanAgreement
{
    NSString *url = @"http://appdoc.59store.com/Public/html/cashinstallment_protocol.html";
    
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - Private Methods

- (CGFloat)heightOfBannerView
{
    if(0 < [self.bottomEntriesArr count]) {
        HXSStoreAppEntryEntity *item = [self.bottomEntriesArr firstObject];
        CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
        CGFloat scaleOfSize = size.height/size.width;
        if (isnan(scaleOfSize)
            || isinf(scaleOfSize)) {
            scaleOfSize = 1.0;
        }
        
        return scaleOfSize * self.view.frame.size.width;
    }else {
        return 0.0f;
    }
}


#pragma mark - Jump To VC

- (void)jumpToCreditWalletVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSCreditWalletViewController *creditWalletVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSCreditWalletViewController"];
    
    [self.navigationController pushViewController:creditWalletVC animated:YES];
    
    [HXSUsageManager trackEvent:@"credit_wallet" parameter:nil];
}

- (void)jumpToApplyCreditVC
{
    // Must bind telephone at first
    BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
    HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
    if ((!hasPayPasswd) && (basicInfo.phone.length < 1)) {
        [self displayBindTelephoneNumberView];
        
        return;
    }
    
    // apply credit card
    
    HXSSubscribeViewController *subscribeVC = [HXSSubscribeViewController createSubscribeVC];
    
    [self.navigationController pushViewController:subscribeVC animated:YES];
}

- (void)displayBindTelephoneNumberView
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                      message:@"为了您的账号安全，请先绑定手机号"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"去绑定"];
    alertView.rightBtnBlock = ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                             bundle:[NSBundle mainBundle]];
        
        HXSBindTelephoneController *telephoneVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSBindTelephoneController"];
        
        [self.navigationController pushViewController:telephoneVC animated:YES];
    };
    
    [alertView show];
}

- (void)jumpToImproveQuota
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSUpgradeCreditViewController *upgradeVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HXSUpgradeCreditViewController class])];
    [self.navigationController pushViewController:upgradeVC animated:YES];
}

- (void)jumpToUpdateWalletVC
{
    HXSUpdateWalletViewController *updateWalletViewController = [HXSUpdateWalletViewController controllerFromXib];
    [self.navigationController pushViewController:updateWalletViewController animated:YES];
}

- (void)jumpToEncashmentVC
{
    // Must bind telephone at first
    BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
    HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
    if ((!hasPayPasswd) && (basicInfo.phone.length < 1)) {
        [self displayBindTelephoneNumberView];
        
        return;
    }
    
    [HXSFinanceOperationManager sharedManager].borrowSerialNum = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [self performSegueWithIdentifier:@"segueEncashment" sender:nil];
}


#pragma mark - Display Upgrade View

- (void)displayUpgradeAlertView
{
    if (![self shouldDisplayUpgradeAlertView]) {
        // do not display
        return;
    }
    
    WS(weakSelf);
    
    HXSCreditUpdatePopContentView *popContentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSCreditUpdatePopContentView class]) owner:nil options:nil].firstObject;
    
    __block HXSPopView *popView = [[HXSPopView alloc] initWithView:popContentView];
    [popView show];
    
    
    [popContentView setCompleteButtonClickBlick:^{
        [popView closeWithCompleteBlock:^{
            [weakSelf jumpToUpdateWalletVC];
        }];
    }];
}

- (BOOL)shouldDisplayUpgradeAlertView
{
    BOOL result = NO;
    
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    if ((kHXSCreditLineStatusDone == [creditCardInfo.lineStatusIntNum integerValue])
        || (1 == [creditCardInfo.oldStatusIntNum integerValue])) {
        return result;
    }
    
    NSNumber *dayIntNum = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultDisplayUpgradeViewDay];
    NSInteger day = [[NSDate date] day];
    
    if (day > [dayIntNum integerValue]) {
        result = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:day]
                                                  forKey:kUserDefaultDisplayUpgradeViewDay];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}


#pragma mark - Setter Getter Methods

- (void)setHeaderView:(HXSCreditCollectionReusableView *)headerView
{
    if (_headerView != headerView) {
        _headerView = headerView;
        
        [_headerView.opreationBtn addTarget:self
                                     action:@selector(onClickOpreationBtn:)
                           forControlEvents:UIControlEventTouchUpInside];
        [_headerView.amountLayoutBtn addTarget:self
                                     action:@selector(onClickAmountLayoutBtn:)
                           forControlEvents:UIControlEventTouchUpInside];
        [_headerView.openInTimeBtn addTarget:self
                                     action:@selector(onClickOpenInTimeBtn:)
                           forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(login:)];
    
    UITapGestureRecognizer *walletTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(jumpToCreditWalletVC)];
    if ([HXSUserAccount currentAccount].isLogin) {
        [_headerView.creditAmountLabel setUserInteractionEnabled:YES];
        
        [_headerView.creditAmountLabel addGestureRecognizer:walletTap];
    } else {
        [_headerView.creditAmountLabel setUserInteractionEnabled:NO];
        
        [_headerView.creditCardInforView addGestureRecognizer:loginTap];
    }
}

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}

- (HXSCreditViewModel *)creditViewModel
{
    if (nil == _creditViewModel) {
        _creditViewModel = [[HXSCreditViewModel alloc] init];
    }
    
    return _creditViewModel;
}



@end
