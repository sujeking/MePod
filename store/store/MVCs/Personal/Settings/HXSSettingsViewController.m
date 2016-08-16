//
//  HXSSettingsViewController.m
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSPersonal.h"
// Controllers
#import "HXSSettingsViewController.h"
#import "HXSDormAboutUsViewController.h"
#import "HXSServiceSelectViewController.h"

// Views

// Model
#import "HXSSettingsModel.h"

// Other
#import <MessageUI/MessageUI.h>
#import "HXSFinanceOperationManager.h"

typedef NS_ENUM(NSInteger, HXSSSettingOption) {
    HXSSSettingOptionNotification = 0,
    HXSSSettingOptionClearCache,
    HXSSSettingOptionAboutUs,
    HXSSSettingOptionVersionUpdate,
#if DEBUG
    HXSSSettingOptionVersionServiceURL,
#endif
    HXSSSettingOptionVersionLogOut,
    
    HXSSSettingOptionCount
};

@interface HXSSettingsViewController ()<UITableViewDataSource,
                                         UITableViewDelegate,
                                         MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) HXSSettingsModel *settingsModel;
@property (nonatomic, assign) BOOL notificationHasBeenDenied;

@end

@implementation HXSSettingsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    self.title = @"设置";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete:) name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete:) name:kLogoutCompleted object:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.tableView.rowHeight = 55;
    
    [self fetchDevicePushStatus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - override

- (void)loginComplete:(NSNotification *)noti
{
    [self.tableView reloadData];
    
    if(![HXSUserAccount currentAccount].isLogin) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [[HXSFinanceOperationManager sharedManager] clearBorrowInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method

- (void)notificationSwitchValueChanged:(UISwitch *)sw
{
    [HXSUsageManager trackEvent:kUsageEventSettingNotification parameter:nil];
    
    self.notificationHasBeenDenied = !sw.isOn;
    
    [self updateDevicePushStatus:[NSNumber numberWithBool:sw.isOn]];
}

#pragma mark - Configure

- (HXSSSettingOption)optionForIndexPath:(NSIndexPath *)indexPath
{
    return (HXSSSettingOption)indexPath.section;
}

- (NSString *)imageNameForOption:(HXSSSettingOption)option
{
    switch (option) {
        case HXSSSettingOptionNotification:     return @"ic_set_notice";
        case HXSSSettingOptionClearCache:       return @"ic_set_clean";
        case HXSSSettingOptionAboutUs:          return @"ic_set_aboutus";
        case HXSSSettingOptionVersionUpdate:    return @"ic_set_version";
        case HXSSSettingOptionVersionLogOut:
            break;
        default:
            break;
    }
    
    return @"";
}

- (NSString *)titleForOption:(HXSSSettingOption)option
{
    switch (option) {
        case HXSSSettingOptionNotification:     return @"推送通知";
        case HXSSSettingOptionClearCache:       return @"清除缓存";
        case HXSSSettingOptionAboutUs:          return @"关于我们";
        case HXSSSettingOptionVersionUpdate:    return @"当前版本";
#if DEBUG
        case HXSSSettingOptionVersionServiceURL: return @"环境选择";
#endif
        case HXSSSettingOptionVersionLogOut:    return @"退出登录";
            break;
        default:
            break;
    }
    
    return @"";
}

- (void) configureCell:(UITableViewCell *)cell option:(HXSSSettingOption) option
{
    NSString *imge = [self imageNameForOption:option];
    cell.imageView.image = (imge.length > 0) ? [UIImage imageNamed:imge] : nil;
    
    cell.textLabel.textColor = [UIColor colorWithRGBHex:0x333333];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.text = [self titleForOption:option];
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (option) {
        case HXSSSettingOptionNotification:
        {
            UISwitch *sw = [[UISwitch alloc] init];
            [sw setOn:!self.notificationHasBeenDenied animated:NO];
            sw.onImage = [UIImage imageNamed:@"btn_open"];
            sw.offImage = [UIImage imageNamed:@"btn_close"];
            [sw addTarget:self action:@selector(notificationSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sw;
        }
            break;
            
        case HXSSSettingOptionClearCache:
        {
            CGFloat size = [[SDImageCache sharedImageCache] getSize]/1024.0;
            NSString *text ;
            if(size > 1024) {
                text = [NSString stringWithFormat:@"%.1fMB", size/1024.0];
            }
            else {
                text = [NSString stringWithFormat:@"%.1fKB", size];
            }
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
            cell.detailTextLabel.text = text;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case HXSSSettingOptionAboutUs:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case HXSSSettingOptionVersionUpdate:
            cell.detailTextLabel.text = [[HXAppConfig sharedInstance] appVersion];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
            break;
#if DEBUG
        case HXSSSettingOptionVersionServiceURL:
        {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
#endif
        case HXSSSettingOptionVersionLogOut:
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([HXSUserAccount currentAccount].isLogin) {
        return HXSSSettingOptionCount;
    }
    return HXSSSettingOptionCount  - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingCell";
    
    HXSSSettingOption option = [self optionForIndexPath:indexPath];
    UITableViewCell *cell;
    
    if (option > HXSSSettingOptionVersionUpdate) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        };
    }

    
    [self configureCell:cell option:option];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSSSettingOption option = [self optionForIndexPath:indexPath];
    
    switch (option) {
        case HXSSSettingOptionNotification:
            break;
        case HXSSSettingOptionClearCache:
        {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:@"清除缓存?"
                                                                      leftButtonTitle:@"取消"
                                                                    rightButtonTitles:@"确定"];
            
            [alertView setRightBtnBlock:^(){
                [MBProgressHUD showInView:self.view status:@"清除缓存..."];
                
                // 清理内存
                [[SDImageCache sharedImageCache] clearMemory];
                
                // 清理webview 缓存
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (NSHTTPCookie *cookie in [storage cookies]) {
                    [storage deleteCookie:cookie];
                }
                
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                [config.URLCache removeAllCachedResponses];
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                
                // 清理硬盘
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [self.tableView reloadData];
                }];
 
            }];
            [alertView show];
        }
            break;
        case HXSSSettingOptionAboutUs:
        {
            [HXSUsageManager trackEvent:kUsageEventSettingAboutUs parameter:nil];
            
            HXSDormAboutUsViewController * controller = [[HXSDormAboutUsViewController alloc] initWithNibName:@"HXSDormAboutUsViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case HXSSSettingOptionVersionUpdate:
            break;
#if DEBUG
        case HXSSSettingOptionVersionServiceURL:
        {
            HXSServiceSelectViewController* vc = [[HXSServiceSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.navigationBar.tintColor = [UIColor whiteColor];
            
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
#endif
        case HXSSSettingOptionVersionLogOut:
            [HXSUsageManager trackEvent:kUsageEventSettingLogout parameter:nil];
            
            [self LogoutServicesAction];
            break;
        default:
            break;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    if(indexPath.section == 0) {
//        if(indexPath.row == 0) {
//            HXSDormAboutUsViewController * controller = [[HXSDormAboutUsViewController alloc] initWithNibName:@"HXSDormAboutUsViewController" bundle:nil];
//            [self.navigationController pushViewController:controller animated:YES];
//        }else if(indexPath.row == 1) {
//            //support
//            Class mailClass= (NSClassFromString(@"MFMailComposeViewController"));
//            if (mailClass != nil) {
//                if ([mailClass canSendMail]) {
//                    [self displayComposerSheet];
//                }else {
//                    [self launchMailAppOnDevice];
//                }
//            }else {
//                [self launchMailAppOnDevice];
//            }
//        }else if(indexPath.row == 2) {
//            //review
//            NSURL * url = [NSURL URLWithString:[HXAppConfig sharedInstance].reviewURL];
//            [[UIApplication sharedApplication] openURL:url];
//        }
//        else if(indexPath.row == 4) {
//            HXSServiceSelectViewController* vc = [[HXSServiceSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
//            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            //nav.navigationBar.barTintColor = HXD_DORM_MAIN_COLOR;
//            nav.navigationBar.tintColor = [UIColor whiteColor];
//            
//            [self presentViewController:nav animated:YES completion:nil];
//        }
//    }else if(indexPath.section == 1) {
//        [self LogoutServicesAction];
//    }
//}

////去掉UItableview headerview黏性(sticky)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = SETTINGS_TABLEVIEWCELL_HEAD_HEIGHT;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

//#pragma mark - 发邮件
//- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
//    if (error != nil) {
////        ILSLogError(@"ILSYCSettingsViewController.mailComposeController:didFinishWithResult:error:",@"Mail operation error:%@",[error localizedDescription]);
//        
//        // handle error here
//        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
//                                                                          message:[error localizedFailureReason]
//                                                                  leftButtonTitle:nil
//                                                                rightButtonTitles:NSLocalizedString(@"OK", @"")];
//        [alertView show];
//    }
//    switch (result) {
//        case MFMailComposeResultCancelled:
//            break;
//        case MFMailComposeResultSaved:
//            break;
//        case MFMailComposeResultSent:
//            break;
//        case MFMailComposeResultFailed:
//            break;
//        default:
//            break;
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//-(void)displayComposerSheet
//{
//    MFMailComposeViewController *emailVC = [[MFMailComposeViewController alloc] init];
//    HXMailComponents* components = [HXAppConfig sharedInstance].supportMailComponents;
//    [[HXAppConfig sharedInstance] fillUpMailViewController:emailVC withComponents:components];
//    [emailVC setSubject:NSLocalizedString(@"59store",nil)];
//    emailVC.mailComposeDelegate = self;
//    [self presentViewController:emailVC animated:YES completion:nil];
//}

//-(void)launchMailAppOnDevice
//{
//    NSString *email = [NSString stringWithFormat:@"mailto:%@&subject=%@",[HXAppConfig sharedInstance].supportEmail,NSLocalizedString(@"59store",nil)];
//    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
//}

- (void)LogoutServicesAction
{
    __weak HXSSettingsViewController *weakSelf = self;
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                       message:@"您确定退出当前账号吗？"
                                                               leftButtonTitle:@"取消"
                                                             rightButtonTitles:@"确定"];
    alertView.rightBtnBlock = ^{
        [weakSelf logout];
        
    };
    [alertView show];
}

- (void)logout
{
    DLog(@"settings: %@", @"logout");
    
    [[HXSUserAccount currentAccount] logout];
    //清除社区tabBar Badge
    [[self.tabBarController.tabBar.items objectAtIndex:kHXSTabBarCommunity] setBadgeValue:nil];
}

#pragma mark - Fetch & Update push status

- (void)fetchDevicePushStatus
{
    NSString *deviceIDStr = [HXAppDeviceHelper uniqueDeviceIdentifier];
    __weak typeof(self) weakSelf = self;
    [self.settingsModel fetchReceivePushStatus:deviceIDStr
                                      complete:^(HXSErrorCode code, NSString *message, NSDictionary *pushStatusDic) {
                                          if (kHXSNoError != code) {
                                              [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                 status:message
                                                                             afterDelay:1.5f];
                                              
                                              return ;
                                          }
                                          
                                          if (DIC_HAS_NUMBER(pushStatusDic, @"receive_status")) {
                                              NSNumber *status = [pushStatusDic objectForKey:@"receive_status"];
                                              
                                              // 0 不接收推送  1 接收推送
                                              weakSelf.notificationHasBeenDenied = ![status boolValue];
                                          }
                                          
                                          [weakSelf.tableView reloadData];
                                      }];
}

- (void)updateDevicePushStatus:(NSNumber *)status
{
    NSString *deviceIDStr = [HXAppDeviceHelper uniqueDeviceIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [self.settingsModel updateReceivePushStatusWithDeviceID:deviceIDStr
                                                     status:status
                                                   complete:^(HXSErrorCode code, NSString *message, NSDictionary *pushStatusDic) {
                                                       if (kHXSNoError != code) {
                                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                              status:message
                                                                                          afterDelay:1.5f];
                                                           
                                                           return ;
                                                       }
                                                       
                                                       
                                                   }];
}

#pragma mark - Setter Getter Methods

- (HXSSettingsModel *)settingsModel
{
    if (nil == _settingsModel) {
        _settingsModel = [[HXSSettingsModel alloc] init];
    }
    
    return _settingsModel;
}

@end
