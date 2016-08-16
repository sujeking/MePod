//
//  HXSBoxCheckOutViewController.m
//  store
//
//  Created by  黎明 on 16/6/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

//view controller
#import "HXSBoxCheckOutViewController.h"
#import "HXSPaymentOrderViewController.h"

//view
#import "HXSBoxCheckOutTitleView.h"
#import "HXSDrinkCheckoutFoodCell.h"
#import "HXSDrinkCheckoutSupplementCell.h"

//model
#import "HXSBoxModel.h"
#import "HXSBoxCarManager.h"
#import "HXSBoxOrderModel.h"
#import "HXSBoxBalanceView.h"
#import "HXSCreateOrderParams.h"
#import "HXSBoxOrderEntity.h"
#import "HXSOrderInfo.h"

static NSString * const DrinkCheckoutFoodCell = @"HXSDrinkCheckoutFoodCell";
static NSString * const DrinkCheckoutSupplementCell = @"HXSDrinkCheckoutSupplementCell";
static NSString * const TitleStr = @"确认订单";

@interface HXSBoxCheckOutViewController () <UITableViewDelegate,
                                            UITableViewDataSource,
                                            HXSBoxBalanceViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
//支付View
@property (weak, nonatomic) IBOutlet HXSBoxBalanceView  *boxBalanceView;
@property (strong, nonatomic) HXSBoxCarManager          *boxCarManager;
@property (strong, nonatomic) NSNumber                  *boxIdNum;
@property (strong, nonatomic) NSString *boxOwnerNameStr;
@end

@implementation HXSBoxCheckOutViewController

- (instancetype)initViewControllerWithBoxId:(NSNumber *)boxId boxOwnerName:(NSString *)name
{
    HXSBoxCheckOutViewController *viewController = [HXSBoxCheckOutViewController controllerFromXib];
    viewController.boxIdNum = boxId;
    viewController.boxOwnerNameStr = name;
    return viewController;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - init Method

- (void)setupSubView
{
    [self initNavgationBar];
    [self initTableview];
    
    self.boxBalanceView.delegate = self;
}

- (void)initNavgationBar
{
    self.navigationItem.title = TitleStr;
}

- (void)initTableview
{
    [self.tableView registerNib:[UINib nibWithNibName:DrinkCheckoutFoodCell bundle:nil]
         forCellReuseIdentifier:DrinkCheckoutFoodCell];
    [self.tableView registerNib:[UINib nibWithNibName:DrinkCheckoutSupplementCell bundle:nil]
         forCellReuseIdentifier:DrinkCheckoutSupplementCell];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.937 green:0.941 blue:0.945 alpha:1.000];
    
    UIView *footerView = [UIView new];
    [self.tableView setTableFooterView:footerView];
}


#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [[self.boxCarManager getBoxAllItems] count];
    }
    else
    {
        return 1;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0)
    {
        HXSDrinkCheckoutFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:DrinkCheckoutFoodCell];
        HXSBoxOrderItemModel *boxItemModel = [[self.boxCarManager getBoxAllItems] objectAtIndex:row];
        HXSDrinkCartItemEntity *foodItem = [[HXSDrinkCartItemEntity alloc] init];
        foodItem.amountNum = boxItemModel.amountDoubleNum;
        foodItem.imageMediumStr = boxItemModel.imageMediumStr;
        foodItem.ridNum = boxItemModel.itemIdNum;
        foodItem.nameStr = boxItemModel.nameStr;
        foodItem.priceNum = boxItemModel.priceDoubleNum;
        foodItem.quantityNum = boxItemModel.quantityNum;
        cell.foodItem = foodItem;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        
        return cell;
        
    }
    else
    {
        HXSDrinkCheckoutSupplementCell *cell = [tableView dequeueReusableCellWithIdentifier:DrinkCheckoutSupplementCell];
        
    
        cell.leftLabel.text = [NSString stringWithFormat:@"共%@件商品",self.boxCarManager.totalCount];
        cell.rightLabel.text = [NSString stringWithFormat:@"￥%0.02f", self.boxCarManager.totalPrice.floatValue];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 &&
       indexPath.row < [[self.boxCarManager getBoxAllItems] count])
    {
        return 50;
    }
    else
    {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 45.0f;
    }
    else
    {
        return 1.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        HXSBoxCheckOutTitleView *boxCheckOutTitleView = [[[NSBundle mainBundle]
                                                          loadNibNamed:NSStringFromClass([HXSBoxCheckOutTitleView class])
                                                          owner:nil options:nil] firstObject];
        boxCheckOutTitleView.boxOwnerNameLabel.text = [self.boxOwnerNameStr stringByAppendingString:@"的零食盒"];
        return boxCheckOutTitleView;
    }
    else
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.937 green:0.941 blue:0.945 alpha:1.000];
        return line;
    }
}

#pragma mark - HXSBoxBalanceViewDelegate

- (void)createOrderAction
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    NSArray *items = [self.boxCarManager getBoxAllItems];

    [HXSBoxModel createBoxOrderWithItemList:items
                                      boxId:self.boxIdNum
                                   complete:^(HXSErrorCode code, NSString *message, HXSBoxOrderModel *boxOrderInfo)
    {
        [HXSLoadingView closeInView:weakSelf.view];
        if (code == kHXSNoError)
        {
            if (boxOrderInfo.orderPayArr == nil)
            {
                HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] initWithOrderInfo:boxOrderInfo];
                orderInfo.order_amount = boxOrderInfo.payAmountDoubleNum;
                orderInfo.order_sn = boxOrderInfo.orderIdStr;
                orderInfo.typeName = @"零食盒";
                orderInfo.type = boxOrderInfo.bizTypeNum.intValue;
                orderInfo.add_time = boxOrderInfo.createTimeNum;
                HXSPaymentOrderViewController *paymentOrderViewController = [HXSPaymentOrderViewController createPaymentOrderVCWithOrderInfo:orderInfo installment:YES];
                [weakSelf replaceCurrentViewControllerWith:paymentOrderViewController animated:YES];
                
                [weakSelf.boxCarManager emptyCart];
            }
        }
        else
        {
            [MBProgressHUD showInView:weakSelf.view customView:nil status:message afterDelay:0.3f];
        }
    }];
}

#pragma mark - GET

- (HXSBoxCarManager *)boxCarManager
{
    return [HXSBoxCarManager sharedManager];
}

@end
