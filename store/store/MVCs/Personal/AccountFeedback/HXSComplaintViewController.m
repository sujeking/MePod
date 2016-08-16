//
//  HXSComplaintViewController.m
//  store
//
//  Created by ArthurWang on 15/8/4.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSComplaintViewController.h"

#import "HXSWebViewController.h"
#import "HXSActionSheet.h"
#import "HXSAccountFeedbackTableViewCell.h"
#import "UDManager.h"
#import "UDAgentNavigationMenu.h"


#define KEY_TITLE @"title"
#define KEY_URL   @"url"

@interface HXSComplaintViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HXSComplaintViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"反馈帮助";
    
    [self initialTableView];
    
    [self initialNewConfigUdesk];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Intial Methods

- (void)initialTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSAccountFeedbackTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSAccountFeedbackTableViewCell class])];
}


#pragma mark - Target Methods

- (IBAction)onClickCallServicePhoneBtn:(id)sender
{
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = @"400-118-5959";
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity
                                                 handler:^(HXSAction *action) {
                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:@"400-118-5959"];
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                 }];
    
    [sheet addAction:callAction];
    
    [sheet show];

}


- (IBAction)onClickFeedbackBtn:(id)sender
{
    [UDManager getAgentNavigationMenu:^(id responseObject, NSError *error) {
        
        UDAgentNavigationMenu *agentMenuVC = [[UDAgentNavigationMenu alloc] init];
        [self.navigationController pushViewController:agentMenuVC animated:YES];
        
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSAccountFeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSAccountFeedbackTableViewCell class])
                                                                            forIndexPath:indexPath];
    
    NSDictionary *questionDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.titleLabel.text = [questionDic objectForKey:KEY_TITLE];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *questionDic = [self.dataSource objectAtIndex:indexPath.row];
    NSString *questionTitleStr = [questionDic objectForKey:KEY_TITLE];
    NSString *questionURLStr = [questionDic objectForKey:KEY_URL];
    
    HXSWebViewController *webViewController = [HXSWebViewController controllerFromXib];
    [webViewController setUrl:[NSURL URLWithString:[questionURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    webViewController.title = questionTitleStr;
    
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - UDManager Methods

- (void)initialNewConfigUdesk {
    
    // 构造参数
    HXSUserInfo *userInfo = [HXSUserAccount currentAccount].userInfo;
    
    
    
    NSString *nick_name = userInfo.basicInfo.uName;
    NSString *sdk_token = [[HXSUserAccount currentAccount] strToken];
    NSString *uid = [NSString stringWithFormat:@"%@", userInfo.basicInfo.uid];
    
    //获取用户自定义字段
    [UDManager getCustomerFields:^(id responseObject, NSError *error) {
        
        NSDictionary *customerFieldValueDic = @{};
        for (NSDictionary *dict in responseObject[@"user_fields"]) {
            if ([dict[@"field_label"] isEqualToString:@"用户id"]) {
                NSString *keyStr = dict[@"field_name"];
                
                customerFieldValueDic = @{keyStr: uid};
            }
        }
        
        NSDictionary *userDic = @{
                                  @"sdk_token":              [NSString md5:sdk_token],
                                  @"nick_name":              nick_name,
                                  @"customer_field":         customerFieldValueDic,
                                  };
        
        NSDictionary *parameters = @{@"user":userDic};
        // 创建用户
        [UDManager createCustomerWithCustomerInfo:parameters];
    }];
    
}


#pragma mark - Setter Getter Methods

- (NSArray *)dataSource
{
    if (nil == _dataSource) {
        
        NSDictionary *dormDic = @{KEY_TITLE: @"夜猫店问题",
                                  KEY_URL: @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=223194436&idx=1&sn=a16cf9332c9852367807ebec246e7cbb#rd"};
        NSDictionary *printDic = @{KEY_TITLE: @"云印店问题",
                                  KEY_URL: @"http://mp.weixin.qq.com/s?__biz=MzIyNzIwMjc5NA==&mid=402046238&idx=1&sn=d4a037ff29a8ad56e0ed6543093533b0&scene=0&previewkey=QJxqVBey0PN3bRmAd1NGi8NS9bJajjJKzz%2F0By7ITJA%3D#wechat_redirect"};
        NSDictionary *storeDic = @{KEY_TITLE: @"云超市问题",
                                  KEY_URL: @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=517636528&idx=1&sn=b92acccb380b02274a5d8174de4d4843#rd"};
        NSDictionary *boxDic = @{KEY_TITLE: @"零食盒问题",
                                  KEY_URL: @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=517636530&idx=1&sn=40f148c070624c66eb0451c8ac969f5b#rd"};
        NSDictionary *creditDic = @{KEY_TITLE: @"花不完问题",
                                  KEY_URL: @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=402141254&idx=1&sn=1b3a53db560596c32eb6be8276524793#rd"};
        NSDictionary *walletDic = @{KEY_TITLE: @"59钱包问题",
                                  KEY_URL: @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=413964696&idx=1&sn=9563e9201c0bb7824b6ac609f780b9e6#rd"};
        NSDictionary *installmentDic = @{KEY_TITLE: @"分期商城问题",
                                  KEY_URL: @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=413964881&idx=1&sn=02437d53b1445d9001e60f4f94e5b2c7#rd"};
        NSDictionary *pointDic = @{KEY_TITLE: @"积分商城问题",
                                  KEY_URL: @"http://bbs.59store.com/webapp/faq/"};
        NSDictionary *activityDic = @{KEY_TITLE: @"活动相关问题",
                                  KEY_URL: @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=517636527&idx=1&sn=dbe5c06b1d860b4c4fc46c2b28025a91#rd"};
        
        _dataSource = @[dormDic, printDic, storeDic, boxDic, creditDic, walletDic, installmentDic, pointDic, activityDic];
    }
    
    return _dataSource;
}


@end
