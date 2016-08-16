//
//  HXSCommunityMessageViewController.m
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityMessageViewController.h"
#import "HXSCommunityDetailViewController.h"
#import "HXSNoticeMsgCell.h"
#import "HXSCommunityMessageModel.h"
#import "HXSCommunityDetailViewController.h"

NSString * const NoticeMsgCell = @"HXSNoticeMsgCell";

@interface HXSCommunityMessageViewController () <UITableViewDataSource,
                                                UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, assign) int page;

@end

@implementation HXSCommunityMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.interactivePopGestureRecognizer addTarget:self
                                                                  action:@selector(popLastViewController)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.interactivePopGestureRecognizer removeTarget:self
                                                                     action:@selector(popLastViewController)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Override Methods

- (void)back
{
    [self popLastViewController];
}

#pragma mark -

- (void)setupSubViews
{
    self.navigationItem.title = @"社区消息";
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.messageArray = [NSMutableArray array];
}


- (void)setupTableView
{
    [self.mTableView setBackgroundColor:[UIColor colorWithR:245 G:246 B:247 A:1]];
    [self.mTableView registerNib:[UINib nibWithNibName:NoticeMsgCell bundle:nil] forCellReuseIdentifier:NoticeMsgCell];
    [self.mTableView setTableFooterView:[UIView new]];
    
    __weak typeof (self) weakSelf = self;
    [self.mTableView addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    
    [self reload];
    
    [self.mTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    [self.mTableView setShowsInfiniteScrolling:NO];
}

//清空消息
- (void)cleanNotifacationMsg
{
    __weak typeof(self) weakSelf = self;
    HXSCommunityMessage *messageEntity = self.messageArray.firstObject;
    [HXSCommunityMessageModel readCommunityUserMessageWithLastMessageId:messageEntity.idStr complete:^(HXSErrorCode code, NSString *message, NSDictionary *resultDict) {
        if ((code == kHXSNoError)||(code == kHXCommunityNotMessage)) {
            if (weakSelf.cleanNotifacationMsgBlock) {
                weakSelf.cleanNotifacationMsgBlock();
            }
        }
       [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}



#pragma mark - Target Methods

- (void)popLastViewController
{
    [self cleanNotifacationMsg];
}


#pragma mark - webService
- (void)loadMessageArray
{
    
    int tempPage;
    
    if(1 == self.page){
        [MBProgressHUD showInView:self.view];
        tempPage = 1;
    }else{
        tempPage = self.page + 1;
    }
    
    __weak typeof (self) weakSelf = self;
    
    NSString *lastMessageId = nil;
    
    if(self.messageArray.count > 0 && self.page > 1){
        HXSCommunityMessage *lastCommunityMessage = [self.messageArray lastObject];
        lastMessageId = lastCommunityMessage.idStr;
    }
    
    [HXSCommunityMessageModel getCommunityUserMessageWithLastMessageId:lastMessageId page:@(tempPage) complete:^(HXSErrorCode code, NSString *message, NSArray *messages) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf.mTableView endRefreshing];
        [[weakSelf.mTableView infiniteScrollingView] stopAnimating];
        
        if(kHXSNoError == code){
            if(tempPage == 1)
               [weakSelf.messageArray removeAllObjects];
            
            weakSelf.page ++;
            [weakSelf.messageArray addObjectsFromArray:messages];
            [weakSelf.mTableView reloadData];
            
            [weakSelf.mTableView setShowsInfiniteScrolling:messages.count>0];
        
        }
        else
        {
            [weakSelf.mTableView setShowsInfiniteScrolling:NO];
            if(code != kHXSItemNotExit)
            {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                   status:message
                                               afterDelay:1.5f];
            }
        }
    }];
}

- (void)reload
{
    self.page = 1;
    [self loadMessageArray];
}

-(void)loadMore
{
    [self loadMessageArray];
}

#pragma mark  -  UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSNoticeMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:NoticeMsgCell forIndexPath:indexPath];
    cell.communityMessage = [self.messageArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self loadToCommunityDetailViewController:[self.messageArray objectAtIndex:indexPath.row]];
}

/**
 *  进入帖子详情页面
 *
 *  @param model
 */
- (void)loadToCommunityDetailViewController:(id)model
{
    HXSCommunityMessage *message = (HXSCommunityMessage *)model;
    
    HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:message.postIdStr replyLoad:NO pop:nil];
    
    [self.navigationController pushViewController:communityDetailViewController animated:YES];
}
@end
