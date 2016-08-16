//
//  HXSApplyBoxViewController.m
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSApplyBoxViewController.h"
#import "HXSBoxMacro.h"
// Controllers
#import "HXSApplyBoxInfoViewController.h"

// Model
#import "HXSBoxInfoEntity.h"


// Views
#import "HXSAboutBoxView.h"

// Others
#import "UIView+Utilities.h"


@interface HXSApplyBoxViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HXSAboutBoxView *headerView;

@property (nonatomic, strong) HXSBoxInfoEntity *boxInfoEntity;
@property (nonatomic, copy) void (^refreshBoxInfo)(void);

@end

@implementation HXSApplyBoxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Public Methods

+ (instancetype)createApplyBoxVCWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity refresh:(void (^)(void))refreshBoxInfo
{
    HXSApplyBoxViewController *applyBoxViewController = [HXSApplyBoxViewController controllerFromXib];
    
    applyBoxViewController.boxInfoEntity = boxInfoEntity;
    applyBoxViewController.refreshBoxInfo = refreshBoxInfo;
    
    return applyBoxViewController;
}

- (void)refresh
{
    [self.tableView endRefreshing];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.parentViewController.navigationItem.title = (0 < [self.navigationTitleStr length]) ? self.navigationTitleStr : @"申请零食盒";
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

- (void)initialTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - Target Methods

/**
 *  申请盒子按钮点击操作
 */
- (void)applyBox
{
    __weak typeof(self) weakSelf = self;
    HXSLocationManager *locationMgr = [HXSLocationManager manager];

    [locationMgr gotoSelectDormWithViewController:self completion:^{
            [HXSUsageManager trackEvent:kUsageEventBoxNeed parameter:@{@"is_select_address":@"已选地址"}];
            HXSApplyBoxInfoViewController *applyBoxVC = [HXSApplyBoxInfoViewController controllerFromXib];
            [weakSelf.navigationController pushViewController:applyBoxVC animated:YES];
    }];
}

// 点击对零食盒不感兴趣
- (void)notInterestedButtonClicked{
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"提醒"
                                                                 message:@"零食首页的零食盒入口将不再显示哦"
                                                         leftButtonTitle:@"不感兴趣"
                                                       rightButtonTitles:@"再考虑下"];
    
    // Don't do in versin 5.0

    [alert show];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 640;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - Setter Getter Methods

- (HXSAboutBoxView *)headerView
{
    if (nil == _headerView) {
        _headerView = [HXSAboutBoxView viewFromNib];
        [_headerView.applyButton addTarget:self action:@selector(applyBox) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"对零食盒不感兴趣"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0x999999] range:strRange];
        [str addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithRGBHex:0x999999] range:strRange];
        [_headerView.notInterestedButton setAttributedTitle:str forState:UIControlStateNormal];
        [_headerView.notInterestedButton addTarget:self action:@selector(notInterestedButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headerView;
}

@end
