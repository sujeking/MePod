//
//  HXSRecommendViewController.m
//  store
//
//  Created by chsasaw on 15/6/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSRecommendViewController.h"

// Views
#import "HXSRecommendedAppCell.h"

// Others
#import "HXSRecommendedGamesRequest.h"
#import "HXSRecommendedApp.h"
#import "HXSMediator+AccountModule.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "MBProgressHUD+HXS.h"
#import "HXSUsageManager.h"
#import "HXStoreLocation.h"


@interface HXSRecommendViewController ()<UITableViewDataSource,
                                         UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HXSRecommendedGamesRequest *request;
@property (nonatomic, strong) NSMutableArray *appArray;

@end

@implementation HXSRecommendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.title = @"游戏中心";
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    
    self.appArray = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    
    [HXSLoadingView showLoadingInView:self.view];
    [self reload];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreLocation" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSRecommendedAppCell" bundle:bundle] forCellReuseIdentifier:@"HXSRecommendedAppCell"];
}

- (void)reload
{
    if (!self.request) {
        self.request = [[HXSRecommendedGamesRequest alloc] init];
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
    [self.request requestWithToken:tokenStr completeBlock:^(HXSErrorCode errorcode, NSString *msg, NSArray *data) {

        [weakSelf.tableView endRefreshing];
        [HXSLoadingView closeInView:weakSelf.view];
        
        if (errorcode == kHXSNoError) {
            weakSelf.firstLoading = NO;
            
            weakSelf.appArray = [data mutableCopy];
            [weakSelf.tableView reloadData];
            if (weakSelf.appArray.count == 0) {
                weakSelf.tableView.hidden = YES;
                weakSelf.cannotFindLabel.hidden = NO;
                weakSelf.cannotFindImageView.hidden = NO;
            } else {
                weakSelf.tableView.hidden = NO;
                weakSelf.cannotFindLabel.hidden = YES;
                weakSelf.cannotFindImageView.hidden = YES;
            }
        } else {
            if (weakSelf.isFirstLoading) {
                [HXSLoadingView showLoadFailInView:weakSelf.view
                                             block:^{
                                                 [weakSelf reload];
                                             }];
            } else {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:msg afterDelay:1.0];
            }
            
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.appArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HXSRecommendedAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXSRecommendedAppCell"];
    
    HXSRecommendedApp *appModel = self.appArray[indexPath.section];
    [cell configWithModel:appModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXSRecommendedApp *appModel = self.appArray[indexPath.section];
    NSString *urlString = appModel.url;
    if (urlString.length > 0) {
        NSString *appName = (appModel.title.length > 0) ? appModel.title : @"";
        
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_PERSONAL_RECOMMEND_APP_CLICK parameter:@{@"app":appName}];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

@end
