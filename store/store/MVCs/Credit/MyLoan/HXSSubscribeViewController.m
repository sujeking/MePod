//
//  HXSSubscribeViewController.m
//  59dorm
//
//  Created by J006 on 16/7/7.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeViewController.h"

//vc
#import "HXSSubscribeIDViewController.h"
#import "HXSSubscribeStudentViewController.h"
#import "HXSSubscribeBankCardViewController.h"
#import "HXSSubscribeAuthorizeViewController.h"
#import "HXSCreditPayRegisterSuccessViewController.h"

#import "HXMyLoan.h"

@interface HXSSubscribeViewController ()<HXSSubscribeIDViewControllerDelegate,
                                         HXSSubscribeStudentViewControllerDelegate,
                                         HXSSubscribeBankCardViewControllerDelegate,
                                         HXSSubscribeAuthorizeViewControllerDelegate>

@property (nonatomic, strong) UIViewController                          *currentVC;
/**当前步骤索引 */
@property (nonatomic, assign) HXSSubscribeStepIndex                     stepNowIndex;
@property (nonatomic, strong) NSMutableArray<UIViewController                          *> *totalVCArray;
/**身份信息 */
@property (nonatomic, strong) HXSSubscribeIDViewController              *subscribeIDVC;
/**学籍信息 */
@property (nonatomic, strong) HXSSubscribeStudentViewController         *subscribeStudentVC;
/**银行卡信息 */
@property (nonatomic, strong) HXSSubscribeBankCardViewController        *subscribeBankCardVC;
/**授权信息 */
@property (nonatomic, strong) HXSSubscribeAuthorizeViewController       *subscribeAuthorizeVC;
/**提交成功 */
@property (nonatomic, strong) HXSCreditPayRegisterSuccessViewController *subscribeSuccessVC;

@end

@implementation HXSSubscribeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialStepIndex];
    
    [self initTheCurrentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Create

+ (instancetype)createSubscribeVC;
{
    HXSSubscribeViewController *vc = [HXSSubscribeViewController controllerFromXib];
    
    return vc;
}


#pragma mark - init

- (void)initialNavigationBar
{
    [self.navigationItem setTitle:@"申请开通59钱包"];
}

- (void)initialStepIndex
{
    NSNumber *applyStepIntNum = [HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.applyStepIntNum;
    
    self.stepNowIndex = [applyStepIntNum integerValue] - 1; // array the first index 0, so minus 1
}

- (void)initTheCurrentViewController
{
    [self addChildViewController:self.subscribeIDVC];
    [self.totalVCArray addObject:_subscribeIDVC];
    
    [self addChildViewController:self.subscribeStudentVC];
    [self.totalVCArray addObject:_subscribeStudentVC];
    
    [self addChildViewController:self.subscribeBankCardVC];
    [self.totalVCArray addObject:_subscribeBankCardVC];
    
    [self addChildViewController:self.subscribeAuthorizeVC];
    [self.totalVCArray addObject:_subscribeAuthorizeVC];
    
    [self addChildViewController:self.subscribeSuccessVC];
    [self.totalVCArray addObject:_subscribeSuccessVC];
    
    [self checkCurrentProgress];
}


#pragma mark - HXSSubscribeIDViewControllerDelegate

- (void)subscribeIDNextStep
{
    [self moveToTheNextStepWithVC:self.subscribeAuthorizeVC];
}


#pragma mark - HXSSubscribeAuthorizeViewControllerDelegate

- (void)subscribeAuthoruzeNextStep
{
    [self moveToTheNextStepWithVC:self.subscribeStudentVC];
}


#pragma mark - HXSSubscribeStudentViewControllerDelegate

- (void)subscribeStudentNextStep
{
    [self moveToTheNextStepWithVC:self.subscribeBankCardVC];
}


#pragma mark - HXSSubscribeBankCardViewControllerDelegate

- (void)subscribeBankNextStep
{
    [self.navigationController pushViewController:self.subscribeSuccessVC animated:YES];
}


#pragma mark - MoveToTheNextStep

/**
 *  跳转到下一个vc
 *
 *  @param vc 目标VC
 */
- (void)moveToTheNextStepWithVC:(UIViewController *)vc
{
    
    CGFloat width = self.view.frame.size.width;
    
    [self.view addSubview:vc.view];
    
    [vc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_right);
        make.right.equalTo(self.view.mas_right).offset(width);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [self transitionFromViewController:_currentVC
                      toViewController:vc
                              duration:0.4
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                
                                [weakSelf.currentVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(self.view.mas_left).offset(-width);
                                    make.right.equalTo(self.view.mas_left);
                                    make.top.equalTo(self.view);
                                    make.bottom.equalTo(self.view);
                                }];
                                
                                [vc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.edges.equalTo(self.view);
                                }];
                                
                                [self.view layoutIfNeeded];
                                
                            } completion:^(BOOL finished) {
                                [weakSelf.currentVC.view removeFromSuperview];

                                [vc didMoveToParentViewController:self];
                                [weakSelf.currentVC willMoveToParentViewController:nil];
                                weakSelf.currentVC = vc;
                                weakSelf.stepNowIndex++;
                            }];
}


#pragma mark - check Current step

/**
 *  获取当前申请流程进行的步骤
 */
- (void)checkCurrentProgress
{
    self.currentVC = [self.totalVCArray objectAtIndex:self.stepNowIndex];
    
    [self.view addSubview:self.currentVC.view];
    [self.currentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.currentVC didMoveToParentViewController:self];
}


#pragma mark - Getter

- (NSMutableArray<UIViewController *> *)totalVCArray
{
    if(!_totalVCArray) {
        _totalVCArray = [[NSMutableArray alloc]init];
    }
    return _totalVCArray;
}

- (HXSSubscribeIDViewController *)subscribeIDVC
{
    if(!_subscribeIDVC) {
        _subscribeIDVC = [HXSSubscribeIDViewController createSubscribeIDVC];
        _subscribeIDVC.delegate = self;
    }
    
    return _subscribeIDVC;
}

- (HXSSubscribeStudentViewController *)subscribeStudentVC
{
    if(!_subscribeStudentVC) {
        _subscribeStudentVC = [HXSSubscribeStudentViewController createSubscribeStudentVC];
        _subscribeStudentVC.delegate = self;
    }
    
    return _subscribeStudentVC;
}

- (HXSSubscribeBankCardViewController *)subscribeBankCardVC
{
    if(!_subscribeBankCardVC) {
        _subscribeBankCardVC = [HXSSubscribeBankCardViewController createSubscribeBankCardVC];
        _subscribeBankCardVC.delegate = self;
    }
    
    return _subscribeBankCardVC;
}

- (HXSSubscribeAuthorizeViewController *)subscribeAuthorizeVC
{
    if(!_subscribeAuthorizeVC) {
        _subscribeAuthorizeVC = [HXSSubscribeAuthorizeViewController createSubscribeAuthorizeVC];
        _subscribeAuthorizeVC.delegate = self;
    }
    
    return _subscribeAuthorizeVC;
}

- (HXSCreditPayRegisterSuccessViewController *)subscribeSuccessVC
{
    if(!_subscribeSuccessVC) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:[NSBundle mainBundle]];
        _subscribeSuccessVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HXSCreditPayRegisterSuccessViewController class])];
    }
    
    return _subscribeSuccessVC;
}

@end
