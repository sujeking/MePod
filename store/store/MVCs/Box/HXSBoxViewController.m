//
//  HXSBoxDetailViewController.m
//  store
//
//  Created by ArthurWang on 15/7/22.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBoxViewController.h"
#import "HXSBoxMacro.h"
// Controllers
#import "HXSLoginViewController.h"
#import "HXSApplyBoxViewController.h"
#import "HXSBoxDispatchViewController.h"
#import "HXSBoxSaleViewController.h"
#import "HXSBoxCheckViewController.h"
#import "HXSSubmitApplyViewController.h"

#import "HXSBoxManageSharerViewController.h"
#import "HXSBoxShareViewController.h"
#import "HXSBoxAssignmentViewController.h"

// Model
#import "HXSBoxModel.h"
#import "HXSBoxCarManager.h"

// Views
#import "HXSLoadingView.h"
#import "HXSBoxMenu.h"
#import "HXSActionSheet.h"

#import "HXSModifyBoxInfoViewController.h"



typedef NS_ENUM(NSInteger, kBoxOwnerMenuItemIndex)
{
    kBoxOwnerMenuItemIndex_UserManager = 0,         //使用管理
    kBoxOwnerMenuItemIndex_Assignment  = 1,         //转让盒子
    kBoxOwnerMenuItemIndex_Share       = 2,         //分享盒子
    kBoxOwnerMenuItemIndex_ConnctionShopManager     //联系店长
};

typedef NS_ENUM(NSInteger, kBoxUerMenuItemIndex)
{
    kBoxUerMenuItemIndex_ExitBox = 0,             //退出盒子
    kBoxUerMenuItemIndex_ConnctionShopManager     //联系店长
};



@interface HXSBoxViewController ()<HXSBoxMenuDelegate>

@property (nonatomic, strong) HXSBoxModel *boxModel;
@property (nonatomic, strong) HXSBoxInfoEntity *boxInfoEntity;
@property (nonatomic, strong) HXSBoxMenu *boxMenu;
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) UIBarButtonItem *moreBarItem;

@end

@implementation HXSBoxViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialNotification];
    
    [self initialBoxInfo];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginCompleted
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLogoutCompleted
                                                  object:nil];
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.moreBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(moreBarItemClickAction)];
}

#pragma mark - private Methods

- (void)moreBarItemClickAction
{
    if ([self.boxInfoEntity.isBoxerNum boolValue]) {
        [HXSUsageManager trackEvent:kUsageEventBoxRightMoreButton parameter:@{@"user_type":@"盒主"}];
    } else {
        [HXSUsageManager trackEvent:kUsageEventBoxRightMoreButton parameter:@{@"user_type":@"分享人"}];
    }
    
    if(self.boxInfoEntity){
        if(self.boxInfoEntity.statusNum.intValue > kHXSBoxStatusNormal){
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc]initWithTitle:nil
                                                                             message:@"清点中，请稍候..." leftButtonTitle:@"确定" rightButtonTitles:nil];
            
            [alertView show];
            
        }else{
            [self.boxMenu show];
        }
        
    }

}

- (void)initialNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginCompleted)
                                                 name:kLoginCompleted
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutCompleted)
                                                 name:kLogoutCompleted
                                               object:nil];
}

- (void)initialBoxInfo
{
    [HXSLoadingView showLoadingInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    [HXSLoginViewController showLoginController:self
                                loginCompletion:^{
                                    [weakSelf fetchBoxInfo];
                                } loginCanceled:^{
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }];
    
}


#pragma mark - Notification Methods

- (void)loginCompleted
{
}

- (void)logoutCompleted
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Fetch Box Info

- (void)fetchBoxInfo
{
    __weak typeof(self) weakSelf = self;
    [HXSBoxModel fetchBoxInfo:^(HXSErrorCode code, NSString *message, HXSBoxInfoEntity *boxInfoEntity) {
        if (code != kHXSNoError) {
            weakSelf.navigationItem.rightBarButtonItem = nil;
            [HXSLoadingView showLoadFailInView:weakSelf.view
                                         block:^{
                                             [weakSelf fetchBoxInfo];
                                         }];
            return ;
        }
        weakSelf.navigationItem.rightBarButtonItem = weakSelf.moreBarItem;

        weakSelf.boxInfoEntity = boxInfoEntity;
        
        [weakSelf updateChildViewControllers];
        
        [weakSelf fetchBoxMessage];
    }];
}

- (void)fetchBoxMessage
{
    [HXSLoadingView closeInView:self.view];
    WS(weakSelf);
    [HXSBoxModel fetchBoxMessageListWithMessageStatus:@(kHXSBoxMessageStatusUnread)
                                                 size:@(1)
                                                 page:@(1)
                                             complete:^(HXSErrorCode code, NSString *message, NSArray *messageList) {
        if(kHXSNoError == code){
            if(messageList&&messageList.count > 0){
                
                HXSBoxMessageModel *message = [messageList objectAtIndex:0];
                if(message.event.typeNum.intValue == kHXSBoxMessageEventTypeShare){
                    [weakSelf alertHandleSharedMessage:message];
                }else if(message.event.typeNum.intValue == kHXSBoxMessageEventTypeTransfer){
                    [weakSelf alertHandleTransterMessage:message];
                }else{
                
                }
            }
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

- (void)messageReaded:(HXSBoxMessageModel *)message{
    WS(weakSelf);
    [HXSBoxModel setMessageReadedWithMessageId:message.messageIdStr
                                      complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                          if(kHXSNoError == code){
                                          
                                          }else{
                                              [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                          }
        
    }];
}

// 处理被共享消息
- (void)handleSharedMessage:(HXSBoxMessageModel *)message
                     action:(NSNumber *)action{
    
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    
    [HXSBoxModel hanleBoxSharedWithBoxId:self.boxInfoEntity.boxIdNum
                                     uid:[HXSUserAccount currentAccount].userID
                                  action:action
                               messageId:message.messageIdStr
                                complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                    
                                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                    if(kHXSNoError == code){
                                        
                                        [weakSelf fetchBoxInfo];
                                        
                                    }else{
                                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                    }
    }];
}

// 处理被转让消息
- (void)handleTransterMessage:(HXSBoxMessageModel *)message
                       action:(NSNumber *)action{
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    
    [HXSBoxModel handleBoxTransterWithBoxId:self.boxInfoEntity.boxIdNum
                                        uid:[HXSUserAccount currentAccount].userID
                                     action:action
                                  messageId:message.messageIdStr
                              boxUserEntity:[[HXSBoxUserEntity alloc]init]
                                   complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                       
                                       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                       if(kHXSNoError == code){
                                           
                                           [weakSelf fetchBoxInfo];
                                           
                                       }else{
                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                       }
        
    }];
}

#pragma mark - Target/Action

- (void)alertHandleSharedMessage:(HXSBoxMessageModel *)message{
    
    NSNumber *leftButtonNum = [message.event.buttonArr objectAtIndex:0];
    
    NSString *leftButtonTitle = leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeSure?@"确定":(leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeReject?@"拒绝":@"确定");
    
    NSNumber *rightButtonNum = [message.event.buttonArr objectAtIndex:1];
    NSString *rightButtonTitle;
    if(rightButtonNum){
        rightButtonTitle = leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeReject?@"确定":@"拒绝";
    }else{
        rightButtonTitle = nil;
    }
    
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:message.titleStr
                                                                 message:message.contentStr
                                                         leftButtonTitle:leftButtonTitle
                                                       rightButtonTitles:rightButtonTitle];
    WS(weakSelf);
    if(leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeReject){
        alert.leftBtnBlock = ^{
            
            [HXSUsageManager trackEvent:kUsageEventBoxSharedReceiveDialogButtonClick parameter:@{@"button":@"拒绝"}];

            [weakSelf handleSharedMessage:message action:@(kHXSBoxMessageEventButtonTypeReject)];
        };
        alert.rightBtnBlock = ^{
            
            [HXSUsageManager trackEvent:kUsageEventBoxSharedReceiveDialogButtonClick parameter:@{@"button":@"确定"}];
            [weakSelf handleSharedMessage:message action:@(kHXSBoxMessageEventButtonTypeAccept)];
        };
    }else if(leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeAccept){
        alert.rightBtnBlock = ^{
            
            [HXSUsageManager trackEvent:kUsageEventBoxSharedReceiveDialogButtonClick parameter:@{@"button":@"确定"}];

            [weakSelf handleSharedMessage:message action:@(kHXSBoxMessageEventButtonTypeAccept)];
        };
        alert.leftBtnBlock = ^{
            
            [HXSUsageManager trackEvent:kUsageEventBoxSharedReceiveDialogButtonClick parameter:@{@"button":@"拒绝"}];

            [weakSelf handleSharedMessage:message action:@(kHXSBoxMessageEventButtonTypeReject)];
        };
    }else{
        alert.leftBtnBlock = ^{
            [weakSelf messageReaded:message];
        };
    }
    [alert show];
}

- (void)alertHandleTransterMessage:(HXSBoxMessageModel *)message{
    
    NSNumber *leftButtonNum = [message.event.buttonArr objectAtIndex:0];
    
    NSString *leftButtonTitle = leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeSure?@"确定":(leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeReject?@"拒绝":@"确定");
    NSNumber *rightButtonNum = [message.event.buttonArr objectAtIndex:1];
    NSString *rightButtonTitle;
    if(rightButtonNum){
        rightButtonTitle = leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeReject?@"确定":@"拒绝";
    }else{
        rightButtonTitle = nil;
    }
    
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:message.titleStr
                                                                 message:message.contentStr
                                                         leftButtonTitle:leftButtonTitle
                                                       rightButtonTitles:rightButtonTitle];
    WS(weakSelf);
    if(leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeReject){
        alert.leftBtnBlock = ^{
            [HXSUsageManager trackEvent:kUsageEventBoxTransferReceiveDialogButtonClick parameter:@{@"button":@"拒绝"}];
            [weakSelf handleTransterMessage:message action:@(kHXSBoxMessageEventButtonTypeReject)];
        };
        alert.rightBtnBlock = ^{
            [HXSUsageManager trackEvent:kUsageEventBoxTransferReceiveDialogButtonClick parameter:@{@"button":@"确定"}];
            
            HXSModifyBoxInfoViewController *vc = [HXSModifyBoxInfoViewController controllerWithBoxInfo:self.boxInfoEntity messageId:message.messageIdStr];
            WS(weakSelf);
            vc.transterSuccessedBlock = ^{
                [weakSelf fetchBoxInfo];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }else if(leftButtonNum.intValue == kHXSBoxMessageEventButtonTypeAccept){
        alert.rightBtnBlock = ^{
            [HXSUsageManager trackEvent:kUsageEventBoxTransferReceiveDialogButtonClick parameter:@{@"button":@"确定"}];
            HXSModifyBoxInfoViewController *vc = [HXSModifyBoxInfoViewController controllerWithBoxInfo:self.boxInfoEntity messageId:message.messageIdStr];
            WS(weakSelf);
            vc.transterSuccessedBlock = ^{
                [weakSelf fetchBoxInfo];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        alert.leftBtnBlock = ^{
            [HXSUsageManager trackEvent:kUsageEventBoxTransferReceiveDialogButtonClick parameter:@{@"button":@"拒绝"}];
            [weakSelf handleTransterMessage:message action:@(kHXSBoxMessageEventButtonTypeReject)];
        };
    }else{
        alert.leftBtnBlock = ^{
            [weakSelf messageReaded:message];
        };
    }
    [alert show];
}

#pragma mark - Child VCs Methods

- (void)updateChildViewControllers
{
    UIViewController *viewController = nil;
    
    __weak typeof(self) weakSelf = self;
    switch ([self.boxInfoEntity.statusNum integerValue]) {
        case kHXSBoxStatusNormal:
        {
            self.navigationItem.rightBarButtonItem = self.moreBarItem;

            [HXSUsageManager trackEvent:kUsageEventBoxEntrance parameter:@{@"user_status":@"已登录已开通零食子"}];
            HXSBoxSaleViewController *boxSaleVC = [HXSBoxSaleViewController createBoxSaleVCWithBoxInfo:self.boxInfoEntity
                                                                                               refresh:^{
                                                                                                   [weakSelf fetchBoxInfo];
                                                                                               }];
            
            viewController = boxSaleVC;
        }
            break;
            
        case kHXSBoxStatusNotApply:
        {
            self.navigationItem.rightBarButtonItem = nil;

             [HXSUsageManager trackEvent:kUsageEventBoxEntrance parameter:@{@"user_status":@"已登录未开通零食子"}];
            HXSApplyBoxViewController *applyBoxVC = [HXSApplyBoxViewController createApplyBoxVCWithBoxInfo:self.boxInfoEntity
                                                                                                   refresh:^{
                                                                                                       [weakSelf fetchBoxInfo];
                                                                                                   }];
            
            viewController = applyBoxVC;
        }
            break;
            
        case kHXSBoxStatusApplyed:
        {
            self.navigationItem.rightBarButtonItem = nil;

            [HXSUsageManager trackEvent:kUsageEventBoxEntrance parameter:@{@"user_status":@"已登录已开通零食子"}];
            HXSSubmitApplyViewController *submitApplyVC = [HXSSubmitApplyViewController createSubmitApplyVCWithBoxInfo:self.boxInfoEntity
                                                                                                            refresh:^{
                                                                                                                [weakSelf fetchBoxInfo];
                                                                                                            }];
            
            viewController = submitApplyVC;
        }
            break;
            
        case kHXSBoxStatusDispath:
        {
            self.navigationItem.rightBarButtonItem = nil;

            [HXSUsageManager trackEvent:kUsageEventBoxEntrance parameter:@{@"user_status":@"已登录已开通零食子"}];
            HXSBoxDispatchViewController *boxDispathVC = [HXSBoxDispatchViewController createBoxDispatchVCWithBoxInfo:self.boxInfoEntity
                                                                                                              refresh:^{
                                                                                                                  [weakSelf fetchBoxInfo];
                                                                                                              }];
            
            viewController = boxDispathVC;
        }
            break;
            
        case kHXSBoxStatusChecking:
        {
            self.navigationItem.rightBarButtonItem = self.moreBarItem;

            [HXSUsageManager trackEvent:kUsageEventBoxEntrance parameter:@{@"user_status":@"已登录已开通零食子"}];
            HXSBoxCheckViewController *boxCheckVC = [HXSBoxCheckViewController createBoxCheckVCWithBoxInfo:self.boxInfoEntity
                                                                                                   refresh:^{
                                                                                                       [weakSelf fetchBoxInfo];
                                                                                                   }];
            
            viewController = boxCheckVC;
        }
            break;
        case kHXSBoxStatusClearing:
        {
            self.navigationItem.rightBarButtonItem = self.moreBarItem;

            [HXSUsageManager trackEvent:kUsageEventBoxEntrance parameter:@{@"user_status":@"已登录已开通零食子"}];
            HXSBoxCheckViewController *boxCheckVC = [HXSBoxCheckViewController createBoxCheckVCWithBoxInfo:self.boxInfoEntity
                                                                                                   refresh:^{
                                                                                                       [weakSelf fetchBoxInfo];
                                                                                                   }];
            
            viewController = boxCheckVC;
        }
            break;
            
        default:
            self.navigationItem.rightBarButtonItem = nil;

            break;
    }
    
    
    
    if (nil == self.currentVC) {
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        
        [viewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [viewController didMoveToParentViewController:self];
        
        self.currentVC = viewController;
        
        [self refreshChildViewController];
    } else if ([viewController isKindOfClass:[self.currentVC class]]) {
        [self refreshChildViewController];
    } else {
        [self addChildViewController:viewController];
        
        [self transitionFromViewController:self.currentVC
                          toViewController:viewController
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [weakSelf.currentVC.view removeFromSuperview];
                                    
                                    [weakSelf.view addSubview:viewController.view];
                                    
                                    [viewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                                        make.edges.equalTo(weakSelf.view);
                                    }];
                                } completion:^(BOOL finished) {
                                    [viewController didMoveToParentViewController:weakSelf];
                                    [weakSelf.currentVC willMoveToParentViewController:nil];
                                    [weakSelf.currentVC removeFromParentViewController];
                                    
                                    weakSelf.currentVC = viewController;
                                }];
    }
}

- (void)refreshChildViewController
{
    if ([self.currentVC isKindOfClass:[HXSBoxSaleViewController class]]) {
        HXSBoxSaleViewController *boxSaleVC = (HXSBoxSaleViewController *)self.currentVC;

        [boxSaleVC refresh];
    } else if ([self.currentVC isKindOfClass:[HXSApplyBoxViewController class]]) {
        HXSApplyBoxViewController *applyBoxVC = (HXSApplyBoxViewController *)self.currentVC;
        
        [applyBoxVC refresh];
    } else if ([self.currentVC isKindOfClass:[HXSSubmitApplyViewController class]]) {
        HXSSubmitApplyViewController *submitApplyVC = (HXSSubmitApplyViewController *)self.currentVC;
        
        [submitApplyVC refresh];
    } else if ([self.currentVC isKindOfClass:[HXSBoxDispatchViewController class]]) {
        HXSBoxDispatchViewController *boxDispatchVC = (HXSBoxDispatchViewController *)self.currentVC;
        
        [boxDispatchVC refresh];
    } else if ([self.currentVC isKindOfClass:[HXSBoxCheckViewController class]]) {
        HXSBoxCheckViewController *boxCheckVC = (HXSBoxCheckViewController *)self.currentVC;
        
        [boxCheckVC refresh];
    }
}


#pragma mark  - HXSBoxMenuDelegate
- (void)boxMenuItemClickAction:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if ([self.boxInfoEntity.isBoxerNum boolValue]) {
        
        switch (row) {
            case kBoxOwnerMenuItemIndex_UserManager: {
                HXSBoxManageSharerViewController *viewController = [HXSBoxManageSharerViewController controllerWithBoxInfoEntity:self.boxInfoEntity];

                [self pushToSubViewController:viewController];
            
            } break;
            case kBoxOwnerMenuItemIndex_Assignment: {
                HXSBoxAssignmentViewController *viewController = [HXSBoxAssignmentViewController controllerWithBoxId:self.boxInfoEntity.boxIdNum batchId:self.boxInfoEntity.batchNoNum];
                [self pushToSubViewController:viewController];
            
            } break;
            case kBoxOwnerMenuItemIndex_Share: {
                HXSBoxShareViewController *viewController = [HXSBoxShareViewController controllerFromXib];
                [self pushToSubViewController:viewController];
            
            } break;
            case kBoxOwnerMenuItemIndex_ConnctionShopManager: {
                [self connectDormAction];
            } break;
            default:break;
        }
        
    } else {
        switch (row) {
            case kBoxUerMenuItemIndex_ExitBox:{
                [self exitBoxAction];
            } break;
            case kBoxUerMenuItemIndex_ConnctionShopManager:{
                [self connectDormAction];
            } break;
            default:break;
        }
    }
}


/**
 *  联系店长
 */
- (void)connectDormAction
{
    __block HXSBoxRelatedEntity *dormInfo = self.boxInfoEntity.dormInfo;
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = dormInfo.phoneStr;
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity handler:^(HXSAction *action) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",dormInfo.phoneStr]]];
    }];
    [sheet addAction:callAction];
    [sheet show];
}

/**
 *  退出盒子
 */
- (void)exitBoxAction
{
    NSString *message = [NSString stringWithFormat:@"确定退出%@的零食盒",self.boxInfoEntity.boxerInfo.userNameStr];
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"确定退出"
                                                                 message:message
                                                         leftButtonTitle:@"取消"
                                                       rightButtonTitles:@"确定"];
    WS(weakSelf);
    alert.rightBtnBlock = ^{
        [weakSelf sharerQuiteBox];
    };
    [alert show];
}

- (void)sharerQuiteBox{
    WS(weakSelf);

    [HXSLoadingView showLoadingInView:self.view];
    [HXSBoxModel sharerQuitBoxWithUid:[HXSUserAccount currentAccount].userID boxId:self.boxInfoEntity.boxIdNum complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
        [HXSLoadingView closeInView:weakSelf.view];
        
        if(kHXSNoError == code){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

/**
 *  跳转到子视图
 *
 *  @param viewController
 */
- (void)pushToSubViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark  - super method

- (void)back {
    WS(weakSelf);
    
    HXSBoxCarManager *boxCarManager = [HXSBoxCarManager sharedManager];
    
    if (![boxCarManager isEmpty])
    {
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"清空购物车"
                                                                          message:@"你确定不要这些东西了吗?"
                                                                  leftButtonTitle:@"取消"
                                                                rightButtonTitles:@"清空"];
        [alertView show];
        [alertView setRightBtnBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [boxCarManager emptyCart];
        }];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Setter Getter

- (HXSBoxModel *)boxModel
{
    if (nil == _boxModel)
    {
        _boxModel = [[HXSBoxModel alloc] init];
    }
    
    return _boxModel;
}

- (HXSBoxMenu *)boxMenu
{
    if (!_boxMenu) {
        NSArray *icons,*titles;
        CGRect rect = CGRectMake(SCREEN_WIDTH - 122, 50, 117, 95);
        
        if ([self.boxInfoEntity.isBoxerNum boolValue]) {
            titles = @[@"使用管理",@"转让盒子",@"分享盒子",@"联系店长"];
            icons = @[[UIImage imageNamed:@"ic_box_gongxiangguanli"],
                      [UIImage imageNamed:@"ic_box_zhuanrang"],
                      [UIImage imageNamed:@"ic_box_fenxiang"],
                      [UIImage imageNamed:@"ic_box_lianxidianzhang"]];
        } else {
            titles = @[@"退出盒子",@"联系店长"];
            icons = @[[UIImage imageNamed:@"ic_box_tuichu"],
                      [UIImage imageNamed:@"ic_box_lianxidianzhang"]];

        }
        
        _boxMenu = [HXSBoxMenu initWithItemArray:icons itemTitles:titles frame:rect];
        _boxMenu.delegate = self;
    }
    
    return _boxMenu;
}







@end
