//
//  HXSUpgradeCreditViewController.m
//  store
//
//  Created by ArthurWang on 16/2/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUpdateWalletViewController.h"

// Controller
#import "HXSWebViewController.h"
#import "HXSWalletContactViewController.h"
#import "HXSAuthorizeViewController.h"
#import "HXSInfoSubmitCompleteViewController.h"
#import "HXSCustomTakePhotoViewController.h"

// Model
#import "HXSUpgradeModel.h"
#import "HXSBusinessLoanViewModel.h"
#import "HXSUpdateWalletViewModel.h"
#import "HXSEditDormAddress.h"

// Views
#import "HXSPayHeaderView.h"
#import "HXSUpgradeCreditTableViewCell.h"
#import "HXSUpgradeCreditTableViewFooterView.h"
#import "HXSCardBowserView.h"

static NSString * const UpgradeCreditTableViewCell = @"HXSUpgradeCreditTableViewCell";



@interface HXSUpdateWalletViewController ()<UITableViewDelegate,
                                            UITableViewDataSource,
                                            HXSUpgradeCreditTableViewCellDelegate,
                                            HXSUpgradeCreditTableViewFooterViewDelegate,
                                            HXSCustomTakePhotoViewControllerDelegate,
                                            UINavigationControllerDelegate,
                                            UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) HXSUpgradeModel            *upgradeModel;
@property (nonatomic, strong) HXSUpgradeAuthStatusEntity *authStatusEntity;
@property (nonatomic, strong) HXSUpgradeCreditTableViewFooterView *upgradeCreditTableViewFooterView;
@property (nonatomic, strong) NSMutableArray *cellModelArray;
@property (nonatomic, assign) NSInteger *selectIndex;
@property (nonatomic, assign) HXSCellTypeNum imageType;


@end

@implementation HXSUpdateWalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    [self initialTableView];
    [self initialCellData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchAuthStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"59钱包升级";
}

- (void)initialCellData
{
    self.cellModelArray = [[NSMutableArray alloc] init];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"HXSUpgradeCreditTableViewCellModel" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:bundlePath];
    NSArray *dicts =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    for (int i = 0; i < dicts.count; i++)
    {
        HXSUpgradeCreditTableViewCellModel *model = [[HXSUpgradeCreditTableViewCellModel alloc] init];
        [model setValuesForKeysWithDictionary:dicts[i]];
        [self.cellModelArray addObject:model];
    }
}


- (void)initialTableView
{
    WS(weakSelf);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    
    [self.tableView registerNib:[UINib nibWithNibName:UpgradeCreditTableViewCell bundle:nil]
         forCellReuseIdentifier:UpgradeCreditTableViewCell];
    
    HXSPayHeaderView *header = [[HXSPayHeaderView alloc] init];
    header.backgroundColor = [UIColor colorWithRGBHex:0xF5F6F7];
    header.textLabel.text = @"请完善以下信息，进行59钱包升级~";
    header.textLabel.font = [UIFont systemFontOfSize:13.0f];
    header.textLabel.textColor = [UIColor colorWithRGBHex:0x999999];
    
    
    [headerView addSubview:header];
    [footView addSubview:self.upgradeCreditTableViewFooterView];
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headerView);
    }];
    
    [self.upgradeCreditTableViewFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(footView);
    }];
    
    [self.tableView setTableHeaderView:headerView];
    [self.tableView setTableFooterView:footView];
    
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchAuthStatus];
    }];
}


#pragma mark - HXSCustomTakePhotoViewControllerDelegate

- (void)takePhotoDoneFinishAndGetImage:(UIImage *)image
{
    WS(weakSelf);
    
    HXSUploadPhotoParamModel *uploadPhotoParamModel = [[HXSUploadPhotoParamModel alloc] init];
    uploadPhotoParamModel.image = image;
    uploadPhotoParamModel.statusNum = @(1);
    switch (self.imageType) {
        case HXSCellTypeNumIDCardUP:
        {
            uploadPhotoParamModel.uploadTypeNum = @(1);
        }
            break;
        case HXSCellTypeNumIDCardDown:
        {
            uploadPhotoParamModel.uploadTypeNum = @(2);
        }
            break;
            
        case HXSCellTypeNumIDCardHandle:
        {
            uploadPhotoParamModel.uploadTypeNum = @(3);
        }
            break;
        default:
            break;
    }
    
    [[HXSBusinessLoanViewModel sharedManager] uploadThePhotoWithParam:uploadPhotoParamModel
                                                             Complete:^(HXSErrorCode code, NSString *message, NSString *urlStr) {
                                                                 if (code == kHXSNoError)
                                                                 {
                                                                     [weakSelf fetchAuthStatus];
                                                                 }
                                                                 else
                                                                 {
                                                                     [MBProgressHUD showInView:weakSelf.view customView:nil status:message afterDelay:3];
                                                                 }
    }];
    
}


#pragma mark - HXSUpgradeCreditTableViewCellDelegate

- (void)upgradeCreditTableViewCellImageViewTap:(UIImageView *)imageView
{
    WS(weakSelf);
    HXSUpgradeCreditTableViewCell *cell = (HXSUpgradeCreditTableViewCell *)imageView.superview.superview;
    __block HXSUpgradeCreditTableViewCellModel *model = cell.model;
    self.imageType = model.cellTypeNum;
    HXSCardBowserView *cardBowserView = [[HXSCardBowserView alloc] init];
    [cardBowserView showImage:imageView];
    [cardBowserView setReTakePhotoBlock:^{
        [weakSelf reTakePhotoAction:model];
    }];
}

-(void)reTakePhotoAction:(HXSUpgradeCreditTableViewCellModel *)model
{
    if (model.cellTypeNum ==HXSCellTypeNumIDCardUP)
    {
        [self jumpToTakePhotoView:kHXSTakePhotoTypeCardUp];
    }
    else if (model.cellTypeNum ==HXSCellTypeNumIDCardDown)
    {
        [self jumpToTakePhotoView:kHXSTakePhotoTypeCardDown];
    }
    else if (model.cellTypeNum ==HXSCellTypeNumIDCardHandle)
    {
        [self jumpToTakePhotoView:kHXSTakePhotoTypeCardHandle];
    }
}

- (void)upgradeCreditTableViewCellButtonClick:(HXSUpgradeCreditTableViewCellModel*)model
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    
    
    switch (model.cellTypeNum) {
        case HXSCellTypeNumGPS:
        case HXSCellTypeNumContackBook:
        {
            HXSAuthorizeViewController *authorizeViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HXSAuthorizeViewController class])];
            [self.navigationController pushViewController:authorizeViewController animated:YES];
        }
            break;
        case HXSCellTypeNumZhimaCredit:
        {
            HXSWebViewController * controller = [HXSWebViewController controllerFromXib];
            [controller setUrl:[NSURL URLWithString:[ApplicationSettings instance].currentZmCreditURL]];
            controller.title = @"芝麻信用";
            
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case HXSCellTypeNumEmergencyContact:
        {
            HXSWalletContactViewController *walletContactViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HXSWalletContactViewController class])];
            
            [self.navigationController pushViewController:walletContactViewController animated:YES];
        }
            break;
        case HXSCellTypeNumDormAddress:
        {
            HXSEditDormAddress *editDormAddress = [HXSEditDormAddress controllerFromXib];
            [self.navigationController pushViewController:editDormAddress animated:YES];
        }
            break;
        case HXSCellTypeNumIDCardUP:
        {
            self.imageType = HXSCellTypeNumIDCardUP;
            [self jumpToTakePhotoView:kHXSTakePhotoTypeCardUp];
        }
            break;
        case HXSCellTypeNumIDCardDown:
        {
            self.imageType = HXSCellTypeNumIDCardDown;
            [self jumpToTakePhotoView:kHXSTakePhotoTypeCardDown];
        }
            break;
        case HXSCellTypeNumIDCardHandle:
        {
             self.imageType = HXSCellTypeNumIDCardHandle;
            [self jumpToTakePhotoView:kHXSTakePhotoTypeCardHandle];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - HXSUpgradeCreditTableViewFooterViewDelegate

- (void)submitButonClickAction
{
    WS(weakSelf);
    [HXSUpdateWalletViewModel authorizeNextComplete:^(HXSErrorCode status, NSString *message) {
        if (status == kHXSNoError) {
            HXSInfoSubmitCompleteViewController *infoSubmitCompleteViewController = [HXSInfoSubmitCompleteViewController controllerFromXib];
            
            [weakSelf.navigationController pushViewController:infoSubmitCompleteViewController animated:YES];
        } else {
            [MBProgressHUD showInView:weakSelf.view customView:nil status:message afterDelay:3];
        }
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD showInView:weakSelf.view customView:nil status:errorMessage afterDelay:3];
    }];
}

- (void)loadWalletProtocalVC
{
    HXSWebViewController * controller = [HXSWebViewController controllerFromXib];
    [controller setUrl:[NSURL URLWithString:[ApplicationSettings instance].currentZmCreditURL]];
    controller.title = @"芝麻信用";
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSUpgradeCreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UpgradeCreditTableViewCell
                                                                          forIndexPath:indexPath];
    
    cell.model = self.cellModelArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}


#pragma mark - Fetch Auth Info

- (void)fetchAuthStatus
{
    WS(weakSelf);
    
    [self.upgradeModel fetchCreditCardAuthStatus:^(HXSErrorCode status, NSString *message, HXSUpgradeAuthStatusEntity *entity) {
        
        [weakSelf.tableView endRefreshing];
        
        if (kHXSNoError != status) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
            
            return ;
        }
        
        NSArray *upgradeAuthStatusEntityProperties = [weakSelf getUpgradeAuthStatusEntityAllProperties];
        
        for (int i = 0; i<[weakSelf.cellModelArray count]; i++)
        {
            HXSUpgradeCreditTableViewCellModel *model = weakSelf.cellModelArray[i];
            
            id value = [entity valueForKey:[NSString stringWithFormat:@"%@",upgradeAuthStatusEntityProperties[i]]];
            if ([value isKindOfClass:[NSNumber class]])
            {
                model.cellDoneNum = value;
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                if (value)
                {
                    model.cellDoneNum = @(1);
                    model.cellImageURLStr = value;
                }
                else
                {
                    model.cellDoneNum = @(0);
                }
            }
            [weakSelf.cellModelArray replaceObjectAtIndex:i withObject:model];
        }
        
        [self.tableView reloadData];
        [self updateButtonsStatus];
    }];
}

/**
 *  跳转到相机或者相册界面
 *
 *  @param isCamera
 */
- (void)jumpToTakePhotoView:(HXSTakePhotoType)type
{
    HXSCustomTakePhotoViewController *customTakePhotoViewController = [[HXSCustomTakePhotoViewController alloc] initWithNibName:@"HXSCustomTakePhotoViewController" bundle:nil];
    customTakePhotoViewController.delegate = self;
    customTakePhotoViewController.takePhotoType = type;
    [self presentViewController:customTakePhotoViewController animated:YES completion:nil];
}


/**
 *  更新提交按钮状态
 */
- (void)updateButtonsStatus
{
    BOOL submitStatus = NO;
    for (HXSUpgradeCreditTableViewCellModel *model in self.cellModelArray)
    {
        if (!model.cellDoneNum.boolValue)
        {
            submitStatus = NO;
            break;
        }
        else
        {
            submitStatus = YES;
        }
    }
    
    [self.upgradeCreditTableViewFooterView setCanSubmitStatus:submitStatus];
}


#pragma mark - GET

- (HXSUpgradeCreditTableViewFooterView *)upgradeCreditTableViewFooterView
{
    if (!_upgradeCreditTableViewFooterView) {
        _upgradeCreditTableViewFooterView = [[NSBundle mainBundle] loadNibNamed:@"HXSUpgradeCreditTableViewFooterView"
                                                                          owner:nil
                                                                        options:nil].firstObject;
        _upgradeCreditTableViewFooterView.delegate = self;
    }
    return _upgradeCreditTableViewFooterView;
}

- (HXSUpgradeModel *)upgradeModel
{
    if (nil == _upgradeModel)
    {
        _upgradeModel = [[HXSUpgradeModel alloc] init];
    }
    return _upgradeModel;
}

- (NSArray *)getUpgradeAuthStatusEntityAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([HXSUpgradeAuthStatusEntity class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

@end
