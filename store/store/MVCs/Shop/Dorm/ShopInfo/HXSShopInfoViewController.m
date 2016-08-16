//
//  HXSShopInfoViewController.m
//  store
//
//  Created by ArthurWang on 16/1/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopInfoViewController.h"

// Model
#import "HXSShop.h"
#import "HXSShopEntity.h"

// Views
#import "HXSShopInfoNameTableViewCell.h"
#import "HXSShopNoticeTableViewCell.h"
#import "HXSShopActivityTableViewCell.h"
#import "HXSAvatarBrowser.h"
#import "HXSShopInfoTableViewCell.h"
#import "HXSShopInfoTitleTableViewCell.h"

static NSString * ShopInfoTableViewCell      = @"HXSShopInfoTableViewCell";
static NSString * ShopInfoTitleTableViewCell = @"HXSShopInfoTitleTableViewCell";

static CGFloat const titleCellHeight  = 44;
static CGFloat const noticeCellHeight = 22;
static CGFloat const toppaddingHeight = 15;
static CGFloat const labelPaddingHeight = 7;


@interface HXSShopInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *shopTableView;

@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (weak, nonatomic) IBOutlet UILabel     *restingLabel;
@property (weak, nonatomic) IBOutlet UILabel     *canBookLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;


@end

@implementation HXSShopInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    [self setupSubViews];
    [self initialTargetMethods];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.contentViewTopConstraint.constant = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.shopEntity          = nil;
    self.dismissShopInfoView = nil;
}


#pragma mark - Initial Methods

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.300];
    
    self.shopIconImageView.layer.cornerRadius = 4;
    self.shopIconImageView.layer.borderColor = [UIColor colorWithRGBHex:0xe1e2e1].CGColor;
    self.shopIconImageView.layer.borderWidth = 1;
    self.shopIconImageView.layer.masksToBounds = YES;
    [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:self.shopEntity.shopLogoURLStr]
                              placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    
    [self.shopIconImageView setUserInteractionEnabled:YES];
    [self.shopIconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(showShopIconTapAction:)]];
    
    
    [self initialTableView];
    
    UIBezierPath *restingLabelMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.restingLabel.bounds
                                                               byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight |
                                          UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                     cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *restingMaskLayer = [[CAShapeLayer alloc] init];
    restingMaskLayer.frame = self.restingLabel.bounds;
    restingMaskLayer.path = restingLabelMaskPath.CGPath;
    self.restingLabel.layer.mask = restingMaskLayer;
    
    UIBezierPath *canBookLabelMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.canBookLabel.bounds
                                                               byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                     cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *canBookMaskLayer = [[CAShapeLayer alloc] init];
    canBookMaskLayer.frame = self.canBookLabel.bounds;
    canBookMaskLayer.path = canBookLabelMaskPath.CGPath;
    self.canBookLabel.layer.mask = canBookMaskLayer;
    [self setShopStatus];
}

- (void)setShopStatus
{
    switch ([self.shopEntity.statusIntNum integerValue]) {
        case 0: // 休息中
        {
            self.restingLabel.hidden = NO;
            self.canBookLabel.hidden = YES;
        }
            break;
            
        case 1: // 营业中
        {
            self.restingLabel.hidden = YES;
            self.canBookLabel.hidden = YES;
        }
            break;
            
        case 2: // 可预订
        {
            self.restingLabel.hidden = YES;
            self.canBookLabel.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)initialTableView
{
    self.shopTableView.tableFooterView = [[UIView alloc] init];
    
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopInfoTableViewCell bundle:nil]
             forCellReuseIdentifier:ShopInfoTableViewCell];
    
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopInfoTitleTableViewCell bundle:nil]
             forCellReuseIdentifier:ShopInfoTitleTableViewCell];

    self.contentViewHeightConstraint.constant += (titleCellHeight + toppaddingHeight);
    
    if (90 > self.contentViewHeightConstraint.constant) {
        self.contentViewHeightConstraint.constant = 90;
    }
    
    self.contentViewTopConstraint.constant = -self.contentViewHeightConstraint.constant;
    
    [self.view layoutIfNeeded];
}

- (void)initialTargetMethods
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissView)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)setupData
{
    self.contentViewHeightConstraint.constant = 0;
    
    //活动
    for (HXSPromotionsEntity *promotionsModel in self.shopEntity.promotionsArr) {
        HXSShopInfoTableViewCellModel *model = [[HXSShopInfoTableViewCellModel alloc] init];
        model.titleStr = promotionsModel.promotionNameStr;
        model.titleColor = promotionsModel.promotionColorStr;
        model.imgurlStr = promotionsModel.promotionImageStr;
        [self.dataSourceArray addObject:model];
        
        self.contentViewHeightConstraint.constant += [self getContentTextHeight:model.titleStr];
    }
    
    //通知
    HXSShopInfoTableViewCellModel *model = [[HXSShopInfoTableViewCellModel alloc] init];
    model.titleStr = self.shopEntity.noticeStr;
    [self.dataSourceArray addObject:model];
    
    self.contentViewHeightConstraint.constant += [self getContentTextHeight:model.titleStr];
}

- (void)dismissView
{
    WS(weakSelf);
    self.contentViewTopConstraint.constant = -self.contentViewHeightConstraint.constant;
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (weakSelf.dismissShopInfoView) {
                             weakSelf.dismissShopInfoView();
                         }
                     }];
}

- (void)showShopIconTapAction:(UITapGestureRecognizer *)sender
{
    if(self.shopEntity.shopTypeIntNum.intValue == 0)
        [HXSUsageManager trackEvent:kUsageEventShopInformationImageClick parameter:@{@"business_type":@"夜猫店"}];
    else if(self.shopEntity.shopTypeIntNum.intValue == 3)
        [HXSUsageManager trackEvent:kUsageEventShopInformationImageClick parameter:@{@"business_type":@"云超市"}];
        
    [HXSAvatarBrowser showImage:self.shopIconImageView];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    
    if (0 == row) {
        HXSShopInfoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopInfoTitleTableViewCell
                                                                              forIndexPath:indexPath];
        cell.addressLabel.text = self.shopEntity.shopAddressStr;
        
        if (self.shopEntity.deliveryStatusIntNum.integerValue == 0) {
            cell.actionTextLabel.text = @"送到寝室";
        } else if (self.shopEntity.deliveryStatusIntNum.integerValue == 1) {
            cell.actionTextLabel.text = @"送到楼下";
        } else if (self.shopEntity.deliveryStatusIntNum.integerValue == 2) {
            cell.actionTextLabel.text = @"只限自取";
        } else {
            cell.actionTextLabel.text = @"";
        }
        
        return cell;
    } else {
        HXSShopInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopInfoTableViewCell
                                                                         forIndexPath:indexPath];
        cell.dataModel = self.dataSourceArray[indexPath.row - 1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 != row) {
        HXSShopInfoTableViewCellModel *model = self.dataSourceArray[row - 1];
        
        return noticeCellHeight > [self getContentTextHeight:model.titleStr] + labelPaddingHeight ?
        noticeCellHeight : [self getContentTextHeight:model.titleStr] + labelPaddingHeight;
    }
    
    return titleCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissView];
}


#pragma mark - Getter

- (CGFloat)getContentTextHeight:(NSString *)titleStr
{
    CGSize size = [titleStr boundingRectWithSize:CGSizeMake(194, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin |        NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                               context:nil].size;
  

    return ceil(size.height);
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray)
    {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}


@end
