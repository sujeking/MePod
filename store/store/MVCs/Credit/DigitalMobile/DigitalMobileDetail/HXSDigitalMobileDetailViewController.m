//
//  HXSDigitalMobileDetailViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileDetailViewController.h"

// Controllers
#import "HXSDigitalMobileCommentViewController.h"
#import "HXSAddressBookViewController.h"
#import "HXSDigitalMobileSpecificationViewController.h"
#import "HXSDigitalMobileParamViewController.h"
#import "HXSDigitalMobileConfirmOrderViewController.h"
#import "HXSDigitalMobileAddressViewController.h"
// Model
#import "HXSDigitalMobileDetailModel.h"
#import "PushAnimator.h"
#import "PushDismissAnimator.h"
#import "HXSDigitalMobileParamEntity.h"
#import "HXSConfirmOrderModel.h"
#import "HXSDigitalMobileParamModel.h"
#import "HXSAddressViewModel.h"
// Views
#import "HXSDigitalMobileHeaderTableViewCell.h"
#import "HXSDigitalMobileSelectionTableViewCell.h"
#import "HXSDigitalMobileAverageTableViewCell.h"
#import "HXSDigitalMobileCommentTableViewCell.h"
#import "HXSShareView.h"
#import "HXSDigitalMobileAddressPickerView.h"


static NSInteger const kHeightDefaultCell =  44;
static NSInteger const kHeightCommentCell = 100;
static CGFloat const kHeightSectionHeader = 10.0f;
static CGFloat const kIntervalAnimation   =0.5f;

static NSString *productDetailCellIdentifier = @"productDetailCellIdentifier";

@interface HXSDigitalMobileDetailViewController () <UITableViewDelegate,
                                                    UITableViewDataSource,
                                                    UIViewControllerTransitioningDelegate,
                                                    HXSAddressControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *specificationView;
@property (weak, nonatomic) IBOutlet UIButton *payNowBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specificationHeightConstraint;

@property (nonatomic, strong) HXSDigitalMobileDetailModel  *digitalMobileDetialModel;
@property (nonatomic, strong) HXSConfirmOrderModel *confirmOrderModel;
@property (nonatomic, strong) HXSDigitalMobileDetailEntity *digitalMobileDetailEntity;
@property (nonatomic, strong) HXSDigitalMobileSpecificationViewController *specificationVC;
@property (nonatomic, strong) HXSDigitalMobileParamViewController *digitalMobileParamVC;
@property (nonatomic, strong) UILabel *infiniteCustomLabel;
/**three entities*/
@property (nonatomic, strong) NSArray *selectedAddressArr;
@property (nonatomic, strong) NSArray *pickerViewDataSource;
@property (nonatomic, strong) HXSDigitalMobileParamSKUEntity *paramSKUEnity;
@property (nonatomic, strong) HXSDigitalMobileParamModel *digitalMobileParamModel;
@property (nonatomic, strong) HXSAddressViewModel *addressModel;
@property (nonatomic, strong) HXSAddressEntity *addressInfo;

@property (nonatomic, strong) NSString *goodsAddressStr;
@property (nonatomic, strong) NSString *parameterStr;
/**the lowest price in the product list*/
@property (nonatomic, strong) NSNumber *lowestPriceFloatNum;

@end

@implementation HXSDigitalMobileDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialTableView];
    
    [self fetchLowestPriceInSKUs];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"分期商城";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_shape"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightBarBtn:)];
}

- (void)initialTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileHeaderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileHeaderTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileSelectionTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileSelectionTableViewCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:productDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileAverageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileAverageTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileCommentTableViewCell class])];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchItemDetial];
    }];
    
    [HXSLoadingView showLoadingInView:self.view];
    [self fetchItemDetial];
    
    UILabel *infiniteCustomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infiniteCustomLabel.textColor = [UIColor colorWithRGBHex:0xADADAD];
    infiniteCustomLabel.font = [UIFont systemFontOfSize:14.0f];
    infiniteCustomLabel.text = @"继续拖动查看图文详情";
    infiniteCustomLabel.textAlignment = NSTextAlignmentCenter;
    infiniteCustomLabel.backgroundColor = [UIColor colorWithRGBHex:0xF2F4F5];
    
    [self.tableView addSubview:infiniteCustomLabel];
    
    self.infiniteCustomLabel = infiniteCustomLabel;
}


#pragma mark - Target Methods

- (IBAction)onClickBuyNowBtn:(id)sender
{
    // If don't login, should login at first
    if (![[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
        return;
    }
    
    if (nil == self.goodsAddressStr) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"请选择地址"
                                       afterDelay:1.0f];
        
        return;
    }
    
    if (nil == self.parameterStr) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"请选择商品"
                                       afterDelay:1.0f];
        
        return;
    }
    
    // Address has been changed
    BOOL hasChanged = [self hasChangedAddress];
    if (hasChanged) {
        
        [self jumpToEditAddressViewcontroller];
        
        return;
    }
    
    HXSDigitalMobileConfirmOrderViewController *confirmOrderVC = [HXSDigitalMobileConfirmOrderViewController controllerFromXib];
    
    [confirmOrderVC initData:self.paramSKUEnity
              andAddressInfo:self.selectedAddressArr];
    
    [self.navigationController pushViewController:confirmOrderVC animated:YES];
}

- (void)fetchItemDetial
{
    __weak typeof(self) weakSelf = self;
    [self.digitalMobileDetialModel fetchItemDetailWithItemID:self.itemIDIntNum
                                                    complete:^(HXSErrorCode status, NSString *message, HXSDigitalMobileDetailEntity *entity) {
                                                        
                                                        if (kHXSNoError != status) {
                                                            [weakSelf.tableView endRefreshing];
                                                            [HXSLoadingView closeInView:weakSelf.view];
                                                            
                                                            if (weakSelf.isFirstLoading) {
                                                                [HXSLoadingView showLoadFailInView:weakSelf.view block:^{
                                                                    [weakSelf fetchItemDetial];
                                                                }];
                                                            } else {
                                                                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                   status:message
                                                                                               afterDelay:1.5f];
                                                            }
                                                            
                                                            return ;
                                                        }
                                                        
                                                        weakSelf.firstLoading = NO;
                                                        
                                                        weakSelf.digitalMobileDetailEntity = entity;
                                                        
                                                        [weakSelf fetchAddressInfo];
                                                        
                                                    }];
}

- (void)fetchAddressInfo
{
    __weak typeof(self) weakSelf = self;
    [self.addressModel fetchAddressWithComplete:^(HXSErrorCode code, NSString *message, HXSAddressEntity *addressInfo) {
        
        [weakSelf.tableView endRefreshing];
        [HXSLoadingView closeInView:weakSelf.view];
        
        if (kHXSNoError != code) {
            // Just update views, don't display the error message
            [weakSelf.tableView reloadData];
            
            return ;
        }
        
        weakSelf.addressInfo = addressInfo;
        
        // 地址信息
        HXSDigitalMobileAddressEntity *provinceEntity = [[HXSDigitalMobileAddressEntity alloc] init];
        provinceEntity.provinceIDIntNum = addressInfo.provinceId;
        provinceEntity.provinceNameStr = addressInfo.province;
        HXSDigitalMobileCityAddressEntity *cityEntity = [[HXSDigitalMobileCityAddressEntity alloc] init];
        cityEntity.cityIDIntNum = addressInfo.cityId;
        cityEntity.cityNameStr = addressInfo.city;
        HXSDigitalMobileCountryAddressEntity *countyEntity = [[HXSDigitalMobileCountryAddressEntity alloc] init];
        countyEntity.countryIDIntNum = addressInfo.countyId;
        countyEntity.countryNameStr = addressInfo.county;
        
        NSMutableArray *addressMArr = [[NSMutableArray alloc] initWithCapacity:5];
        [addressMArr addObject:provinceEntity];
        [addressMArr addObject:cityEntity];
        [addressMArr addObject:countyEntity];
        
        weakSelf.selectedAddressArr = addressMArr;
        weakSelf.goodsAddressStr = [NSString stringWithFormat:@"%@ %@ %@",addressInfo.province, addressInfo.city, addressInfo.county];
        
        [weakSelf.tableView reloadData];
        
    }];
    
    
}

- (void)onClickRightBarBtn:(UIButton *)button
{
    HXSDigitalMobileDetailImageEntity *imageEntity = [self.digitalMobileDetailEntity.imagesArr firstObject];
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    parameter.shareTypeArr = @[@(kHXSShareTypeQQMoments), @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends), @(kHXSShareTypeWechatMoments),
                               @(kHXSShareTypeSina)];
    
    HXSShareView *shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter callBack:nil];
    shareView.shareParameter.titleStr = @"59花不完";
    shareView.shareParameter.textStr = @"我正在59花不完，零首付分期棒棒哒！";
    shareView.shareParameter.imageURLStr = imageEntity.imageURLStr;
    shareView.shareParameter.shareURLStr = @"http://yemao.59store.com/share?hxfrom=59huabuwan";
    
    [shareView show];
}


#pragma mark - Jump To VC Methods

- (void)jumpToSpecification
{
    if (nil == self.specificationVC.view.superview) {
        [self.specificationView addSubview:self.specificationVC.view];
        [self.specificationVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.specificationView);
        }];
    }
    
    self.specificationHeightConstraint.constant = self.tableView.height;
    [UIView animateWithDuration:kIntervalAnimation
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)jumpToEditAddressViewcontroller
{
    HXSDigitalMobileAddressEntity *provinceEntity      = [self.selectedAddressArr objectAtIndex:0];
    HXSDigitalMobileCityAddressEntity *cityEntity      = [self.selectedAddressArr objectAtIndex:1];
    HXSDigitalMobileCountryAddressEntity *countyEntity = [self.selectedAddressArr objectAtIndex:2];
    
    HXSAddressEntity *addressEntity = [[HXSAddressEntity alloc] init];
    addressEntity.name        = self.addressInfo.name;
    addressEntity.phone       = self.addressInfo.phone;
    addressEntity.provinceId  = provinceEntity.provinceIDIntNum;
    addressEntity.province    = provinceEntity.provinceNameStr;
    addressEntity.cityId      = cityEntity.cityIDIntNum;
    addressEntity.city        = cityEntity.cityNameStr;
    addressEntity.countyId    = countyEntity.countryIDIntNum;
    addressEntity.county      = countyEntity.countryNameStr;
    

    HXSDigitalMobileAddressViewController *addressController = [[HXSDigitalMobileAddressViewController alloc] init];
    addressController.delegate = self;
    [addressController initData:addressEntity];
    
    [self.navigationController pushViewController:addressController animated:YES];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (nil == self.digitalMobileDetailEntity) {
        return 0;
    }
    
    if (0 < [self.digitalMobileDetailEntity.commentsArr count]) {
        return 4;  // 1 头部  2 地址&配置 3 介绍 4 评价
    } else {
        return 3;  // 1 头部  2 地址&配置 3 介绍
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 1;
            break;
            
        case 1: return 2; // 1 地址 2 配置
            break;
            
        case 2: return 1;
            break;
            
        case 3: return 1 + [self.digitalMobileDetailEntity.commentsArr count];
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: return [HXSDigitalMobileHeaderTableViewCell heightOfHeaderViewForOrder:self.digitalMobileDetailEntity];
            break;
            
        case 1: return kHeightDefaultCell; // 默认
            break;
            
        case 2: return kHeightDefaultCell;
            break;
            
        case 3:
        {
            if (0 == indexPath.row) {
                return kHeightDefaultCell;
            } else {
                return kHeightCommentCell;
            }
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.1f;
    }
    
    return kHeightSectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileHeaderTableViewCell class]) forIndexPath:indexPath];
        }
            break;
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileSelectionTableViewCell class]) forIndexPath:indexPath];
        }
            break;
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:productDetailCellIdentifier forIndexPath:indexPath];
            if (nil == cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productDetailCellIdentifier];
            }
        }
            break;
            
        case 3:
        {
            if (0 == indexPath.row) {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileAverageTableViewCell class]) forIndexPath:indexPath];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileCommentTableViewCell class]) forIndexPath:indexPath];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            HXSDigitalMobileHeaderTableViewCell *headerCell = (HXSDigitalMobileHeaderTableViewCell *)cell;
            
            [headerCell setupCellWithEntity:self.digitalMobileDetailEntity];
        }
            break;
            
        case 1:
        {
            HXSDigitalMobileSelectionTableViewCell *selectionCell = (HXSDigitalMobileSelectionTableViewCell *)cell;
            
            if (0 == indexPath.row) {
                [selectionCell setupCellWithTitile:@"送至：" content:self.goodsAddressStr type:kSelectionContentTypeAddress];
            } else {
                if (0 < [self.parameterStr length]) {
                    [selectionCell setupCellWithTitile:@"已选：" content:self.parameterStr type:kSelectionContentTypeParam];
                } else {
                    [selectionCell setupCellWithTitile:@"属性：" content:self.parameterStr type:kSelectionContentTypeParam];
                }
                
            }
        }
            break;
            
        case 2:
        {
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
            cell.textLabel.text = @"商品详情介绍";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 3:
        {
            if (0 == indexPath.row) {
                HXSDigitalMobileAverageTableViewCell *averageCell = (HXSDigitalMobileAverageTableViewCell *)cell;
                averageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                [averageCell setupCellWithAverageScore:self.digitalMobileDetailEntity.averageScoreFloatNum];
            } else {
                HXSDigitalMobileCommentTableViewCell *commentCell = (HXSDigitalMobileCommentTableViewCell *)cell;
                
                if ((indexPath.row - 1) < [self.digitalMobileDetailEntity.commentsArr count]) {
                    HXSDigitalMobileDetailCommentEntity *commentEntity = [self.digitalMobileDetailEntity.commentsArr objectAtIndex:(indexPath.row - 1)];
                    [commentCell setupCellWithEntity:commentEntity];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: // Do Nothing
            break;
            
        case 1:
        {
            if (0 == indexPath.row) {
                __weak typeof(self) weakSelf = self;
                [HXSDigitalMobileAddressPickerView showWithPickerViewDataSource:self.pickerViewDataSource selected:self.selectedAddressArr toolBarColor:[UIColor whiteColor] completeBlock:^(NSArray *pickerViewDataSource, NSArray *selectedAddressArr) {
                    weakSelf.pickerViewDataSource = pickerViewDataSource;
                    weakSelf.selectedAddressArr = selectedAddressArr;
                    
                    [weakSelf updateAddressCellAtIndexPath:indexPath];
                    
                    // Update button status
                    [weakSelf updateBottomView];
                }];
            } else {
                __weak typeof(self) weakSelf = self;
                
                [self presentViewController:self.digitalMobileParamVC
                                   animated:YES
                                 completion:nil];
                
                [self.digitalMobileParamVC updateItemIDIntNum:self.itemIDIntNum
                                                          sku:self.paramSKUEnity
                                                     complete:^(HXSDigitalMobileParamSKUEntity *paramSKUEntity){
                                                         
                                                         weakSelf.paramSKUEnity = paramSKUEntity;
                                                         
                                                         NSMutableString *paramMStr = [[NSMutableString alloc] initWithCapacity:5];
                                                         for (HXSDigitalMobileParamSKUPropertyEntity *propertyEntiy in paramSKUEntity.propertiesArr) {
                                                             [paramMStr appendFormat:@"%@ ", propertyEntiy.valueNameStr];
                                                         }
                                                         
                                                         weakSelf.parameterStr = paramMStr;
                                                         [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                         
                                                         // Update button status
                                                         [weakSelf updateBottomView];
                                                         
                                                     }];
            }
        }
            break;
            
        case 2:
        {
            HXSDigitalMobileSpecificationViewController *specificationVC = [HXSDigitalMobileSpecificationViewController controllerFromXib];
            specificationVC.itemIDIntNum = self.digitalMobileDetailEntity.itemIDIntNum;
            
            [self.navigationController pushViewController:specificationVC animated:YES];
        }
            break;
            
        case 3:
        {
            if (0 == indexPath.row) {
                HXSDigitalMobileCommentViewController *commentVC = [HXSDigitalMobileCommentViewController controllerFromXib];
                
                commentVC.itemIDIntNum = self.digitalMobileDetailEntity.itemIDIntNum;
                commentVC.averageScoreFloatNum = self.digitalMobileDetailEntity.averageScoreFloatNum;
                
                [self.navigationController pushViewController:commentVC animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (0 < scrollView.contentSize.height) {
        CGFloat scrollOffsetThreshold = scrollView.contentSize.height - scrollView.bounds.size.height;
        
        if (scrollView.contentOffset.y > (scrollOffsetThreshold + 100)) {
            [self jumpToSpecification];
        }
        
        self.infiniteCustomLabel.frame = CGRectMake(0, scrollView.contentSize.height, scrollView.bounds.size.width, kHeightDefaultCell);
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PushAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[PushDismissAnimator alloc] init];
}



#pragma mark - Update Cell & Bottom View

- (void)updateAddressCellAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDigitalMobileAddressEntity *proviceEntity = [self.selectedAddressArr objectAtIndex:0];
    HXSDigitalMobileCityAddressEntity *cityEntity = [self.selectedAddressArr objectAtIndex:1];
    HXSDigitalMobileCountryAddressEntity *countryEntity = [self.selectedAddressArr objectAtIndex:2];
    self.goodsAddressStr = [NSString stringWithFormat:@"%@ %@ %@", proviceEntity.provinceNameStr, cityEntity.cityNameStr, countryEntity.countryNameStr];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateBottomView
{
    if (nil != self.paramSKUEnity) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [self.paramSKUEnity.priceFloatNum floatValue]];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [self.lowestPriceFloatNum floatValue]];
    }
    
    [self checkGoodsStock];
}

- (void)updatePayNowBtnWithStock:(BOOL)hasStock
{
    if (hasStock) {
        self.payNowBtn.enabled = YES;
        [self.payNowBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [self.payNowBtn setBackgroundColor:[UIColor colorWithRGBHex:0xF9A502]];
    }else {
        self.payNowBtn.enabled = NO;
        [self.payNowBtn setTitle:@"暂无库存" forState:UIControlStateNormal];
        [self.payNowBtn setBackgroundColor:[UIColor colorWithRGBHex:0xE1E2E3]];
    }
}


#pragma mark - HXSAddressControllerDelegate

- (void)didSaveAddress:(HXSAddressEntity *)addressInfo
{
    self.addressInfo = addressInfo;
}


#pragma mark - Fetch Stock

- (void)checkGoodsStock
{
    if ((nil == self.selectedAddressArr)
        || (nil == self.paramSKUEnity)) {
        return;  // Don't fetch when has enough data
    }
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    HXSDigitalMobileAddressEntity *proviceEntity = [weakSelf.selectedAddressArr objectAtIndex:0];
    HXSDigitalMobileCityAddressEntity *cityEntity = [weakSelf.selectedAddressArr objectAtIndex:1];
    HXSDigitalMobileCountryAddressEntity *countryEntity = [weakSelf.selectedAddressArr objectAtIndex:2];
    NSString *addressStr = [NSString stringWithFormat:@"%@_%@_%@", proviceEntity.provinceIDIntNum, cityEntity.cityIDIntNum, countryEntity.countryIDIntNum];
    [self.confirmOrderModel checkGoodsStockWithGoodsId:self.paramSKUEnity.skuIDIntNum
                                        andAddressCode:addressStr
                                              Complete:^(HXSErrorCode code, NSString *message, NSDictionary *stockInfo) {
                                                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                  
                                                  if (kHXSNoError != code) {
                                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                         status:message
                                                                                     afterDelay:1.0f];
                                                      
                                                      return ;
                                                  };
                                                  
                                                  BOOL isHaveStock = [[stockInfo valueForKey:@"stock"] boolValue];
                                                  [weakSelf updatePayNowBtnWithStock:isHaveStock];
                                              }];
}

- (void)fetchLowestPriceInSKUs
{
    __weak typeof(self) weakSelf = self;
    [self.digitalMobileParamModel fetchItemAllSKUWithItemID:self.itemIDIntNum
                                                   complete:^(HXSErrorCode status, NSString *message, HXSDigitalMobileParamEntity *paramEntity) {
                                                       
                                                       NSNumber *priceFloatNum = nil;
                                                       for (HXSDigitalMobileParamSKUEntity *entity in paramEntity.skusArr) {
                                                           if ((nil == priceFloatNum)
                                                               || ([priceFloatNum floatValue] > [entity.priceFloatNum floatValue])) {
                                                               priceFloatNum = entity.priceFloatNum;
                                                           }
                                                       }
                                                       
                                                       weakSelf.lowestPriceFloatNum = priceFloatNum;
                                                       
                                                       [weakSelf updateBottomView];

                                                   }];
}


#pragma mark - Private Methods

- (BOOL)hasChangedAddress
{
    BOOL hasChanged = NO;
    
    if (nil == self.selectedAddressArr) {
        return NO; // Did not changed
    }
    
    HXSDigitalMobileAddressEntity *provinceEntity = [self.selectedAddressArr objectAtIndex:0];
    if ([provinceEntity.provinceIDIntNum integerValue] != [self.addressInfo.provinceId integerValue]) {
        hasChanged = YES;
    }
    
    HXSDigitalMobileCityAddressEntity *cityEntity = [self.selectedAddressArr objectAtIndex:1];
    if ([cityEntity.cityIDIntNum integerValue] != [self.addressInfo.cityId integerValue]) {
        hasChanged = YES;
    }
    
    HXSDigitalMobileCountryAddressEntity *countyEntity = [self.selectedAddressArr objectAtIndex:2];
    if ([countyEntity.countryIDIntNum integerValue] != [self.addressInfo.countyId integerValue]) {
        hasChanged = YES;
    }
    
    
    return hasChanged;
}


#pragma mark - Setter Getter Methods

- (HXSDigitalMobileDetailModel *)digitalMobileDetialModel
{
    if (nil == _digitalMobileDetialModel) {
        _digitalMobileDetialModel = [[HXSDigitalMobileDetailModel alloc] init];
    }
    
    return _digitalMobileDetialModel;
}

- (HXSDigitalMobileSpecificationViewController *)specificationVC
{
    if (nil == _specificationVC) {
        __weak typeof(self) weakSelf = self;
        _specificationVC = [HXSDigitalMobileSpecificationViewController controllerFromXib];
        _specificationVC.itemIDIntNum = self.digitalMobileDetailEntity.itemIDIntNum;
        _specificationVC.hasPullDown = ^(void){
            weakSelf.specificationHeightConstraint.constant = 0;
            [UIView animateWithDuration:kIntervalAnimation
                             animations:^{
                                 [weakSelf.view layoutIfNeeded];
                             }];
        };
    }
    
    return _specificationVC;
}

- (HXSDigitalMobileParamViewController *)digitalMobileParamVC
{
    if (nil == _digitalMobileParamVC) {
        _digitalMobileParamVC = [HXSDigitalMobileParamViewController controllerFromXib];
        _digitalMobileParamVC.transitioningDelegate = self;
        _digitalMobileParamVC.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return _digitalMobileParamVC;
}

- (HXSConfirmOrderModel *)confirmOrderModel
{
    if (nil == _confirmOrderModel) {
        _confirmOrderModel = [[HXSConfirmOrderModel alloc] init];
    }
    
    return _confirmOrderModel;
}

- (HXSDigitalMobileParamModel *)digitalMobileParamModel
{
    if (nil == _digitalMobileParamModel) {
        _digitalMobileParamModel = [[HXSDigitalMobileParamModel alloc] init];
    }
    
    return _digitalMobileParamModel;
}

- (HXSAddressViewModel *)addressModel
{
    if (nil == _addressModel) {
        _addressModel = [[HXSAddressViewModel alloc] init];
    }
    
    return _addressModel;
}




@end
