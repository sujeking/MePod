//
//  HXSBoxDispatchViewController.m
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxDispatchViewController.h"
#import "HXSBoxMacro.h"

// Controllers
#import "HXSBoxLastBillViewController.h"
#import "HXSBoxManageSharerViewController.h"

// Model
#import "HXSBoxInfoEntity.h"

// Views
#import "HXSActionSheet.h"

@interface HXSBoxDispatchViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *lastBillBtn;

@property (nonatomic, strong) HXSBoxInfoEntity *boxInfoEntity;

@property (nonatomic, copy) void (^refreshBoxInfo)(void);

@end

@implementation HXSBoxDispatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self intialNavigationBar];
    
    [self initialScrollView];
    
    [self initialButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Public Methods

+ (instancetype)createBoxDispatchVCWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity refresh:(void (^)(void))refreshBoxInfo
{
    HXSBoxDispatchViewController *boxDispatchVC = [HXSBoxDispatchViewController controllerFromXib];
    
    boxDispatchVC.boxInfoEntity = boxInfoEntity;
    boxDispatchVC.refreshBoxInfo = refreshBoxInfo;
    
    return boxDispatchVC;
}

- (void)refresh
{
    [self.scrollView endRefreshing];
}

#pragma mark - Overrive Methods

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Initial Methods

- (void)intialNavigationBar
{
    self.parentViewController.navigationItem.title = @"零食盒派送中";
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initialScrollView
{
    __weak typeof(self) weakSelf = self;
    [self.scrollView addRefreshHeaderWithCallback:^{
        if (nil != weakSelf.refreshBoxInfo) {
            weakSelf.refreshBoxInfo();
        }
    }];
}

- (void)initialButtons
{
    if (self.boxInfoEntity.hasLastBillNum.intValue == HXSBoxLastBillStatusYes) {
        [self.lastBillBtn setHidden:NO];
    } else {
        [self.lastBillBtn setHidden:YES];
    }
}


#pragma mark - Target Methods

- (IBAction)contactDormManager:(id)sender
{
    
    NSString *phone = self.boxInfoEntity.dormInfo.phoneStr;
    
    if (phone.length > 0) {
        HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
        
        HXSActionSheetEntity *phoneEntity = [[HXSActionSheetEntity alloc] init];
        phoneEntity.nameStr = phone;
        HXSAction *selectAction = [HXSAction actionWithMethods:phoneEntity handler:^(HXSAction *action) {
            [HXSUsageManager trackEvent:kUsageEventBoxDelieveyContanctDorm parameter:nil];
            NSString *phoneNumber = [@"tel://" stringByAppendingString:phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }];
        
        [sheet addAction:selectAction];
        [sheet show];
    }
    else {
        HXSCustomAlertView *alert = [[HXSCustomAlertView alloc] initWithTitle:@"提示" message:@"暂无店长电话" leftButtonTitle:@"确定" rightButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)onClickLastBillBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventBoxCheckPriorPeriodInventory parameter:nil];
    self.boxInfoEntity.batchNoNum = @(self.boxInfoEntity.batchNoNum.intValue - 1);
    HXSBoxManageSharerViewController *boxManageSharerViewController = [HXSBoxManageSharerViewController controllerWithBoxInfoEntity:self.boxInfoEntity];
    
    [self.navigationController pushViewController:boxManageSharerViewController animated:YES];
}


@end
