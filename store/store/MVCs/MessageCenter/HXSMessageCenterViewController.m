//
//  HXSMessageCenterViewController.m
//  store
//
//  Created by ArthurWang on 15/7/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMessageCenter.h"

// Controllers
#import "HXSMessageCenterViewController.h"
#import "HXSLoginViewController.h"
#import "HXSWebViewController.h"
#import "HXSDormMainViewController.h"
#import "HXSCouponViewController.h"
#import "HXSMyOrderDetailViewController.h"
#import "HXSBoxOrderViewController.h"
#import "HXSBoxViewController.h"
#import "HXSCreditOrderDetailViewController.h"
#import "HXSMyBillViewController.h"
#import "HXSBorrowCashRecordViewController.h"
#import "HXSDigitalMobileViewController.h"
#import "HXSDigitalMobileDetailViewController.h"
#import "HXSCreditWalletViewController.h"
#import "HXSPrintOrderDetailViewController.h"

// Views
#import "HXSelectionControl.h"
#import "HXSMessageTableViewCell.h"

// Model
// Other
#import "HXSMessage.h"
#import "HXSMessageAction.h"
#import "HXSClickEvent.h"


static HXSMessageCenterViewController *messageCenterVC = nil;

static NSString *messageCell           = @"HXSMessageTableViewCell";
static NSString *messageCellIdentifier = @"HXSMessageTableViewCell";

#define HEIGHT_CELL_ESTIMATED    75
#define HEIGHT_CELL_HEADER       5

// footer view frame
static CGFloat const kFooterImageViewY   = 60.0f;
static CGFloat const kFooterLabelWidth   = 300.0f;
static CGFloat const kFooterLableHeight  = 21.0f;
static CGFloat const kFooterLabelPadding = 22.0f;



// envet key
#define HXS_EVENT_TITLE         @"title"
#define HXS_EVENT_URL           @"link"
#define HXS_EVENT_PARAMS        @"param"
#define HXS_EVENT_SCHEME        @"scheme"

#define KEY_EVENT_PARAM_URL      @"url"
#define KEY_EVENT_PARAM_ORDER_SN @"orderSN"
#define KEY_EVENT_PARAM_STATUS   @"status"

#define NUMBER_PER_PAGE    10


@interface HXSMessageCenterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet HXSelectionControl *selectionController;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) NSArray *messageDataSource;
@property (nonatomic, strong) NSArray *readedDataSource;
@property (nonatomic, strong) NSArray *unreadedDataSource;
@property (nonatomic, strong) HXSMessageModel *messageModel;

@property (nonatomic, strong) NSMutableDictionary *offscreenCells;

@end

@implementation HXSMessageCenterViewController


#pragma mark - Signleton Methods

+ (HXSMessageCenterViewController *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == messageCenterVC) {
            messageCenterVC = [[[self class] alloc] initWithNibName:@"HXSMessageCenterViewController" bundle:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(updateUnreadMessageNumber:)
                                                         name:kLoginCompleted
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(updateUnreadMessageNumber:)
                                                         name:kLogoutCompleted
                                                       object:nil];
        }
    });
    
    return messageCenterVC;
}


#pragma mark - UIViewController LifyCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBarStatus];
    
    [self initialSelectionController];
    
    [self initialMessageTableView];
    
    // update total number of unread message in the navigation bar item
    [HXSMessageModel fetchUnreadMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUnreadedMessage)
                                                 name:kReceivedNewMessageNoitifcation
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMessageTableView:)
                                                 name:kLoginCompleted
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMessageTableView:)
                                                 name:kLogoutCompleted
                                               object:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark -- Initial Methods

- (void)initNavigationBarStatus
{
    self.title = NSLocalizedStringFromTable(@"MessageCenter", @"InfoPlist", nil);
    
    if (1 == self.selectionController.selectedIdx) {// 1 is readed
        self.navigationItem.rightBarButtonItem = nil;
    } else { // 0 is unreaded
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"一键已读"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(onClickReadAllMessage:)];
        
        [self.navigationItem.rightBarButtonItem setEnabled:(0 < [self.unreadedDataSource count])];
    }
    
}

- (void)initialSelectionController
{
    self.selectionController.titles = @[@"未读", @"已读"];
    self.selectionController.selectedIdx = 0; // default
    self.selectionController.showBottomSepratorLine = NO;
    [self.selectionController addTarget:self
                                 action:@selector(selectionControllerChanged:)
                       forControlEvents:UIControlEventValueChanged];
}

- (void)initialMessageTableView
{
    [self.messageTableView registerNib:[UINib nibWithNibName:messageCell bundle:[NSBundle mainBundle]]
                forCellReuseIdentifier:messageCellIdentifier];
    
    self.messageTableView.estimatedRowHeight = HEIGHT_CELL_ESTIMATED;
    self.messageTableView.allowsMultipleSelectionDuringEditing = YES;
    
    __weak typeof (self) weakSelf = self;
    [self.messageTableView addRefreshHeaderWithCallback:^{
        [weakSelf reloadMessage];
    }];
    
    [self.messageTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreMessage];
    }];
    
    [self.messageTableView setShowsInfiniteScrolling:NO];
    
    [HXSLoadingView showLoadingInView:self.view];
    [self reloadMessage];
}


#pragma mark - Target/Action

- (void)selectionControllerChanged:(HXSelectionControl *)control
{
    if (0 == self.selectionController.selectedIdx) {// 0 is unreaded
        [HXSUsageManager trackEvent:kUsageEventMessageTab parameter:@{@"type":@"未读"}];
    } else { // 1 is readed
        [HXSUsageManager trackEvent:kUsageEventMessageTab parameter:@{@"type":@"已读"}];
    }
    
    [self.selectionController setUserInteractionEnabled:NO];
    
    [self reloadMessage];
    
    [self initNavigationBarStatus]; // change the right button
}

- (void)onClickReadAllMessage:(UIBarButtonItem *)barButton
{
    [MBProgressHUD showInView:[[UIApplication sharedApplication] keyWindow]];
    
    __weak typeof(self) weakSelf = self;
    [self.messageModel readAllMessages:^(HXSErrorCode code, NSString *message, NSDictionary *messageInfo) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        
        if (kHXSNoError != code) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
            
            return ;
        }
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %d", MESSAGE_STATUS_UNREADED];
            [HXSMessage MR_deleteAllMatchingPredicate:predicate];
        }];
        
        [HXSLoadingView showLoadingInView:weakSelf.view];
        [weakSelf reloadMessage];
        
        [HXSMessageModel fetchUnreadMessage];
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSMessageTableViewCell *cell = (HXSMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:messageCellIdentifier forIndexPath:indexPath];
    
    HXSMessage *messageEntity = [self.messageDataSource objectAtIndex:indexPath.row];
    
    NSTimeInterval timeInterval = [messageEntity.createTime doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateStr = [HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm"];
    
    [self setupCellIconImageInCell:cell message:messageEntity];
    cell.messageTimeLabel.text = dateStr;
    cell.messageContentLabel.text = messageEntity.content;
    cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    
    [cell layoutIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        HXSMessageTableViewCell *cell = [self.offscreenCells objectForKey:messageCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:messageCell owner:self options:nil] lastObject];
            
            [self.offscreenCells setObject:cell forKey:messageCellIdentifier];
        }
        
        // 填充内容
        HXSMessage *messageEntity = [self.messageDataSource objectAtIndex:indexPath.row];
        
        NSTimeInterval timeInterval = [messageEntity.createTime doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSString *dateStr = [HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"];
        
        [self setupCellIconImageInCell:cell message:messageEntity];
        cell.messageTimeLabel.text = dateStr;
        cell.messageContentLabel.text = messageEntity.content;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        // 将cell的宽度设置为和tableView的宽度一样宽。
        // 这点很重要。
        // 如果cell的高度取决于table view的宽度（例如，多行的UILabel通过单词换行等方式），
        // 那么这使得对于不同宽度的table view，我们都可以基于其宽度而得到cell的正确高度。
        // 但是，我们不需要在-[tableView:cellForRowAtIndexPath]方法中做相同的处理，
        // 因为，cell被用到table view中时，这是自动完成的。
        // 也要注意，一些情况下，cell的最终宽度可能不等于table view的宽度。
        // 例如当table view的右边显示了section index的时候，必须要减去这个宽度。
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        
        // 触发cell的布局过程，会基于布局约束计算所有视图的frame。
        // （注意，你必须要在cell的-[layoutSubviews]方法中给多行的UILabel设置好preferredMaxLayoutWidth值；
        // 或者在下面2行代码前手动设置！）
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        // 得到cell的contentView需要的真实高度
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        // 要为cell的分割线加上额外的1pt高度。因为分隔线是被加在cell底边和contentView底边之间的。
        height += 5.0f;
        
        return height;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == [self.messageDataSource count]) {
        return tableView.height;
    } else {
       return 0.1; // don't display
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (0 == [self.messageDataSource count]) {
        UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.height)];
        
        UIImage *image = [UIImage imageNamed:@"messagecenter_img_nonews"];
        CGFloat imageViewX = (tableView.width - image.size.width) / 2.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, kFooterImageViewY, image.size.width, image.size.height)];
        imageView.image = image;
        
        [emptyView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((tableView.width - kFooterLabelWidth) / 2.0, CGRectGetMaxY(imageView.frame) + kFooterLabelPadding, kFooterLabelWidth, kFooterLableHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"暂时没有消息哦";

        label.font = [UIFont systemFontOfSize:14]; // default font size
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRGBHex:0x999999];
        
        [emptyView addSubview:label];
        
        view = emptyView;

    }
    
    
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == self.selectionController.selectedIdx) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == self.selectionController.selectedIdx) {// 0 is unreaded
        return UITableViewCellEditingStyleDelete;
    } else { // 1 is readed
        return UITableViewCellEditingStyleNone;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing
        && (indexPath.row < [self.messageDataSource count])
        && (UITableViewCellEditingStyleDelete == editingStyle)) {
        [HXSUsageManager trackEvent:kUsageEventMessageDelete parameter:nil];
        
        NSMutableArray *tempMArr = [[NSMutableArray alloc] initWithArray:self.messageDataSource];
        
        // remove message in the service
        HXSMessage *messageEntity = (HXSMessage *)[self.messageDataSource objectAtIndex:indexPath.row];
        [self removeMessage:messageEntity.messageID];
        
        [tempMArr removeObjectAtIndex:indexPath.row];
        
        self.messageDataSource = tempMArr;
        
        if (0 == self.selectionController.selectedIdx) {// 0 is unreaded
            self.unreadedDataSource = [self.messageDataSource copy];
        } else {
            self.readedDataSource = [self.messageDataSource copy];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self initNavigationBarStatus];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        
        return ;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (nil == self.messageDataSource
        || (indexPath.row >= [self.messageDataSource count])) { // No needed entity
        return;
    }
    
    [HXSUsageManager trackEvent:kUsageEventMessageReadMessage parameter:nil];
    
    // update read message status in the service
    HXSMessage *messageEntity = (HXSMessage *)[self.messageDataSource objectAtIndex:indexPath.row];
    
    [self startEventInMessage:messageEntity];
    
    if (0 == self.selectionController.selectedIdx) {// 0 is unreaded
        
        [self readMessage:messageEntity.messageID];
        
        // remove message at local
        NSMutableArray *tempMArr = [[NSMutableArray alloc] initWithArray:self.messageDataSource];
        [tempMArr removeObjectAtIndex:indexPath.row];
        
        self.messageDataSource = tempMArr;
        
        if (0 == self.selectionController.selectedIdx) {// 0 is unreaded
            self.unreadedDataSource = [self.messageDataSource copy];
        } else {
            self.readedDataSource = [self.messageDataSource copy];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (0 == [self.messageDataSource count]) {
            [self reloadMessageTableView];
            
            [self initNavigationBarStatus];
        }
    }
    
}


#pragma mark - TableView Setup Cell

- (void)setupCellIconImageInCell:(HXSMessageTableViewCell *)cell message:(HXSMessage *)messageEntity
{
    NSString *iconStr = [messageEntity.icon stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.messageIconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"ic_messagecentre_59"]];
    
    cell.messageTitileLabel.text = messageEntity.title ? messageEntity.title : @"";
    cell.tintColor = [UIColor colorWithRGBHex:0x09A9FA];
    
    return;
}

#pragma mark - Fetch Messages Methods

#pragma mark Load New
- (void)reloadMessage
{
    if (0 == self.selectionController.selectedIdx) {// 0 is unreaded
        [self reloadUnreadedMessage];
    } else { // 1 is readed
        [self reloadReadedMessage];
    }
}

- (void)reloadUnreadedMessage
{
    [self reloadMessageWithReaded:NO];
}

- (void)reloadReadedMessage
{
    [self reloadMessageWithReaded:YES];
}

- (void)reloadMessageWithReaded:(BOOL)hasReaded
{
    __weak typeof(self) weakSelf = self;
    
    [self.messageModel fetchNewMessageWithStatus:hasReaded
                                        complete:^(HXSErrorCode code, NSString *message, NSArray *messageInfo) {
                                            
                                            [weakSelf.selectionController setUserInteractionEnabled:YES];
                                            
                                            [weakSelf.messageTableView performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
                                            [HXSLoadingView closeInView:weakSelf.view];
                                            
                                            if (kHXSNoError != code) {
                                                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                   status:message
                                                                               afterDelay:1.5f];
                                                [weakSelf.messageTableView setShowsInfiniteScrolling:NO];
                                                return ;
                                            } else {
                                                
                                                weakSelf.messageDataSource = [messageInfo copy];
                                                
                                                [weakSelf reloadMessageTableView];
                                                
                                                BOOL hasMoreMessage = NO;
                                                if (hasReaded) {
                                                    weakSelf.readedDataSource = [messageInfo copy];
                                                    hasMoreMessage = [weakSelf.messageModel.readedTotalCountNumer integerValue] > [messageInfo count];
                                                } else {
                                                    weakSelf.unreadedDataSource = [messageInfo copy];
                                                    hasMoreMessage = [weakSelf.messageModel.unreadedtotalCountNumer integerValue] > [messageInfo count];
                                                }
                                                
                                                if (hasMoreMessage) {
                                                    [weakSelf.messageTableView setShowsInfiniteScrolling:YES];
                                                } else {
                                                    [weakSelf.messageTableView setShowsInfiniteScrolling:NO];
                                                }
                                                
                                                [weakSelf initNavigationBarStatus];
                                            }
                                        }];
}

#pragma mark Load More

- (void)loadMoreMessage
{
    [[self.messageTableView infiniteScrollingView] stopAnimating];
    
    if (0 == [self.messageDataSource count]) {
        return;
    }
    
    if (0 == self.selectionController.selectedIdx) {// 0 is unreaded
        [self loadMoreUnreadedMessage];
    } else { // 1 is readed
        [self loadMoreReadedMessage];
    }
}

- (void)loadMoreUnreadedMessage
{
    [self loadMoreMessageWithReaded:NO];
}

- (void)loadMoreReadedMessage
{
    [self loadMoreMessageWithReaded:YES];
}

- (void)loadMoreMessageWithReaded:(BOOL)hasReaded
{
    __weak typeof(self) weakSelf = self;
    [self.messageModel loadMoreMessageWithStatus:hasReaded
                                        complete:^(HXSErrorCode code, NSString *message, NSArray *messageInfo) {
                                            
                                            [weakSelf.selectionController setUserInteractionEnabled:YES];
                                            
                                            [[weakSelf.messageTableView infiniteScrollingView] performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.5];
                                            
                                            
                                            if (kHXSNoError != code) {
                                                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                   status:message
                                                                               afterDelay:1.5f];
                                                [weakSelf.messageTableView setShowsInfiniteScrolling:NO];
                                                return ;
                                            } else {
                                                
                                                weakSelf.messageDataSource = [messageInfo copy];
                                                
                                                [weakSelf reloadMessageTableView];
                                                
                                                BOOL hasMoreMessage = NO;
                                                if (hasReaded) {
                                                    weakSelf.readedDataSource = [messageInfo copy];
                                                    hasMoreMessage = [weakSelf.messageModel.readedTotalCountNumer integerValue] > [messageInfo count];
                                                } else {
                                                    weakSelf.unreadedDataSource = [messageInfo copy];
                                                    hasMoreMessage = [weakSelf.messageModel.unreadedtotalCountNumer integerValue] > [messageInfo count];
                                                }
                                                
                                                if (hasMoreMessage) {
                                                    [weakSelf.messageTableView setShowsInfiniteScrolling:YES];
                                                } else {
                                                    [weakSelf.messageTableView setShowsInfiniteScrolling:NO];
                                                }
                                            }
                                            
                                        }];
}

#pragma mark Delete Message

- (void)removeMessage:(NSString *)messageID
{
    [self.messageModel deleteMessageWithMessageID:messageID
                                         complete:^(HXSErrorCode code, NSString *message, NSDictionary *messageInfo) {
                                             // DO Nothing
                                             [HXSMessageModel fetchUnreadMessage];
                                         }];
}

#pragma mark Read Message

- (void)readMessage:(NSString *)messageID
{
    [self.messageModel updateMessageStatusWithMessageID:messageID
                                               complete:^(HXSErrorCode code, NSString *message, NSDictionary *messageInfo) {
                                                   
                                                   [HXSMessageModel fetchUnreadMessage];
                                               }];
}


#pragma mark - Reload TableView

- (void)reloadMessageTableView
{
    [self.messageTableView reloadData];
}


#pragma mark - Notification Methods

+ (void)updateUnreadMessageNumber:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HXSMessageModel fetchUnreadMessage];
    });
    
}

- (void)updateMessageTableView:(NSNotification *)notification
{
    self.readedDataSource   = nil;
    self.unreadedDataSource = nil;
    self.messageDataSource  = nil;
    
    [self reloadMessage];
}


#pragma mark - Event Methods

- (void)startEventInMessage:(HXSMessage *)messageEntity
{
    HXSMessageAction *event = messageEntity.action;
    
    NSDictionary *paramDic = (NSDictionary *)event.param;
    
    if([EVENT_SCHEME_DORM isEqualToString:event.scheme])
    {
        [self onClickDorm:event param:paramDic];
    }
    else if([EVENT_SCHEME_COUPON isEqualToString:event.scheme])
    {
        [self onClickCoupon:event param:paramDic];
    }
    else if ([EVENT_SCHEME_CREDIT isEqualToString:event.scheme])
    {
        [self onClickCredit:event param:paramDic];
    }
    else if([EVENT_SCHEME_ORDER_DETAIL isEqualToString:event.scheme])
    {
        [self onClickOrderDetial:event param:paramDic];
    }
    else if ([EVENT_SCHEME_CREDIT_PAY isEqualToString:event.scheme])
    {
        [self onClickCreditPay:event param:paramDic];
    }
    else if ([EVENT_SCHEME_BOX isEqualToString:event.scheme])
    {
        [self onClickMyBox:event param:paramDic];
    }
    else if ([EVENT_SCHEME_CREDIT_CONSUME_BILL isEqualToString:event.scheme])
    {
        [self onClickCreditConsumeBill:event param:paramDic];
    }
    else if ([EVENT_SCHEME_CREDIT_INSTALLMENT_BILL isEqualToString:event.scheme])
    {
        [self onClickCreditInstallmentBill:event param:paramDic];
    }
    else if ([EVENT_SCHEME_CREDIT_INSTALLMENT_RECORD isEqualToString:event.scheme])
    {
        [self onClickCreditInstallmentRecord:event param:paramDic];
    }
    else if ([EVENT_SCHEME_CREDIT_WALLET isEqualToString:event.scheme])
    {
        [self onClickCreditWallet:event param:paramDic];
    }
    else if ([EVENT_SCHEME_TIP isEqualToString:event.scheme])
    {
        [self onClickTip:event param:paramDic];
    }
    else if ([EVENT_SCHEME_TIP_GROUP_ITEM isEqualToString:event.scheme])
    {
        [self onClickTipGroupItem:event param:paramDic];
    }
    else if(event.link && event.link.length > 0)
    {
        [self onClickWeb:event param:paramDic];
    }
}

#pragma mark Events

- (void)onClickDorm:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    [locationMgr goToDestination:PositionBuilding completion:^{
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        HXSDormMainViewController * controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HXSDormMainViewController"];
        controller.navigationItem.title = @"夜猫店";
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

- (void)onClickCoupon:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    HXSCouponViewController *couponViewController = [HXSCouponViewController controllerFromXib];
    couponViewController.couponScope = kHXSCouponScopeNone;
    [self.navigationController pushViewController:couponViewController animated:YES];
}

- (void)onClickCredit:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    [HXSLoginViewController showLoginController:self loginCompletion:^{
        HXSWebViewController *webViewController = [HXSWebViewController controllerFromXib];
        NSString *url = [[ApplicationSettings instance] creditCentsURL];
        [webViewController setUrl:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        webViewController.title = event.title;
        [self.navigationController pushViewController:webViewController animated:YES];
    }];
}

- (void)onClickOrderDetial:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    if(paramDic) {
        int type = [[paramDic objectForKey:@"type"] intValue];
        NSString *orderSn = [paramDic objectForKey:@"order_sn"];
        if(!orderSn || orderSn.length == 0) {
            return;
        }
        
        switch (type) {
            case kHXSOrderTypeNormal:
            {
                HXSMyOrderDetailViewController *orderDetailViewController = [HXSMyOrderDetailViewController controllerFromXib];
                HXSOrderInfo *info = [[HXSOrderInfo alloc] initWithDictionary:paramDic];
                orderDetailViewController.order = info;
                
                [self.navigationController pushViewController:orderDetailViewController animated:YES];
            }
                break;
                
            case kHXSOrderTypeDorm:
            {
                HXSMyOrderDetailViewController *orderDetailViewController = [HXSMyOrderDetailViewController controllerFromXib];
                HXSOrderInfo *info = [[HXSOrderInfo alloc] initWithDictionary:paramDic];
                orderDetailViewController.order = info;
                
                [self.navigationController pushViewController:orderDetailViewController animated:YES];
            }
                break;
                
            case kHXSOrderTypeNewBox:
            {
                HXSBoxOrderViewController *boxViewController = [HXSBoxOrderViewController controllerFromXib];
                boxViewController.orderSNStr = orderSn;
                [self.navigationController pushViewController:boxViewController animated:YES];
            }
                break;
                
            case kHXSOrderTypeEleme:
            {
                // Do nothing
            }
                break;
                
            case kHXSOrderTypePrint:
            {
                HXSPrintOrderDetailViewController *orderDetailViewController = [HXSPrintOrderDetailViewController controllerFromXib];
                orderDetailViewController.orderSNNum = orderSn;
                
                [self replaceCurrentViewControllerWith:orderDetailViewController animated:YES];
            }
                break;
                
            case kHXSOrderTypeDrink:
            {
                // Do nothing
            }
                break;
                
            case kHXSOrderTypeCharge:
            case kHXSOrderTypeInstallment:
            case kHXSOrderTypeOneDream:
            {
                HXSCreditOrderDetailViewController *creditOrderDetialVC = [HXSCreditOrderDetailViewController controllerFromXib];
                creditOrderDetialVC.orderSNStr = orderSn;
                creditOrderDetialVC.orderTypeIntNum = [NSNumber numberWithInteger:type];
                
                [self.navigationController pushViewController:creditOrderDetialVC animated:YES];
            }
                break;
                
            case kHXSOrderTypeEncashment:
                // Do nothing
                break;
                
            case kHXSOrderTypeStore:
            {
                // DO nothing
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)onClickCreditPay:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    // Do nothing
}
- (void)onClickWeb:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    HXSWebViewController * webViewController = [HXSWebViewController controllerFromXib];
    [webViewController setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",event.link]]];
    webViewController.title = event.title;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)onClickMyBox:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    HXSBoxViewController *boxVC = [HXSBoxViewController controllerFromXib];
    
    [self.navigationController pushViewController:boxVC animated:YES];
}

- (void)onClickCreditConsumeBill:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSMyBillViewController *myBillVC = [story instantiateViewControllerWithIdentifier:@"HXSMyBillViewController"];
    myBillVC.selectedSegmentIndexIntNum = [NSNumber numberWithInt:0];
    
    [self.navigationController pushViewController:myBillVC animated:YES];
}

- (void)onClickCreditInstallmentBill:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSMyBillViewController *myBillVC = [story instantiateViewControllerWithIdentifier:@"HXSMyBillViewController"];
    myBillVC.selectedSegmentIndexIntNum = [NSNumber numberWithInt:0];
    
    [self.navigationController pushViewController:myBillVC animated:YES];
}

- (void)onClickCreditInstallmentRecord:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSBorrowCashRecordViewController *cashRecordVC = [story instantiateViewControllerWithIdentifier:@"HXSBorrowCashRecordViewController"];
    
    [self.navigationController pushViewController:cashRecordVC animated:YES];
}

- (void)onClickCreditWallet:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    if ([[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
        HXSCreditWalletViewController *creditWalletVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSCreditWalletViewController"];
        
        [self.navigationController pushViewController:creditWalletVC animated:YES];
    }
}

- (void)onClickTip:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    HXSDigitalMobileViewController *digitalMobileVC = [HXSDigitalMobileViewController controllerFromXib];
    
    [self.navigationController pushViewController:digitalMobileVC animated:YES];
}

- (void)onClickTipGroupItem:(HXSMessageAction *)event param:(NSDictionary *)paramDic
{
    HXSDigitalMobileDetailViewController *detailVC = [HXSDigitalMobileDetailViewController controllerFromXib];
    
    NSString *groupIDStr = [paramDic objectForKey:@"group_id"];
    detailVC.itemIDIntNum = [NSNumber numberWithInt:[groupIDStr intValue]];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - Setter Getter Methods

- (HXSMessageModel *)messageModel
{
    if (nil == _messageModel) {
        _messageModel = [[HXSMessageModel alloc] init];
    }
    
    return _messageModel;
}

- (NSMutableDictionary *)offscreenCells
{
    if (nil == _offscreenCells) {
        _offscreenCells = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return _offscreenCells;
}

@end
