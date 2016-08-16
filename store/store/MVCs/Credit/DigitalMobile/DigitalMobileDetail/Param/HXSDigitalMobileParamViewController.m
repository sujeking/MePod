//
//  HXSDigitalMobileParamViewController.m
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileParamViewController.h"

// Controllers
#import "HXSDigitalMobileParamModel.h"
// Model

// Views
#import "HXSDigitalMobileParamCollectionViewCell.h"
#import "HXSDigitialMobileParamCollectionReusableView.h"
#import "HXSLoadingView.h"

static NSInteger const kHeightHeaderView = 100;
static NSInteger const kHeightBottomView = 50;
static NSInteger const kTopPadding       = 89;
static NSInteger const kHeightButton     = 30;
static NSInteger const kHeightSection    = 44;
static NSInteger const kPadding          = 30;
static NSString * const kValueName  = @"value_name";
static NSString * const kPropertyId = @"property_id" ;

@interface HXSDigitalMobileParamViewController () <UICollectionViewDelegate,
                                                   UICollectionViewDataSource,
                                                   UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *topClearView;
@property (weak, nonatomic) IBOutlet UIView *paramContentView;
@property (weak, nonatomic) IBOutlet UIImageView *skuImageView;
@property (weak, nonatomic) IBOutlet UILabel *skuNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuPriceLabel;  // "￥0.0"
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *skuBottomPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paramContentViewTopConstraint;

@property (nonatomic, strong) NSNumber *itemIDIntNum;
@property (nonatomic, strong) HXSDigitalMobileParamSKUEntity *hasSelectedSKUEntity;
@property (nonatomic, copy) hasSelectedSKUEntity block;

@property (nonatomic, strong) HXSDigitalMobileParamModel *digitalMobileParamModel;
@property (nonatomic, strong) HXSDigitalMobileParamEntity *digitalMobileParamEntity;
@property (nonatomic, strong) NSMutableArray *hasSelectedValuesMArr;    // each item is one in the section. As {proprty_id:1, value:白色}
@property (nonatomic, strong) NSArray *hasFilterSKUsArr;                // has been filtered by the selected Values


@end

@implementation HXSDigitalMobileParamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addGestureRecognizer];
    
    [self initialCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.block                    = nil;
    self.itemIDIntNum             = nil;
    self.hasSelectedSKUEntity     = nil;
    self.digitalMobileParamModel  = nil;
    self.digitalMobileParamEntity = nil;
}


#pragma mark - Initial Methods

- (void)addGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissViewController:)];
    
    [self.topClearView addGestureRecognizer:tap];
}

- (void)initialCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileParamCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HXSDigitalMobileParamCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitialMobileParamCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HXSDigitialMobileParamCollectionReusableView class])];
}


#pragma mark - Public Methods

- (void)updateItemIDIntNum:(NSNumber *)itemIDIntNum
                       sku:(HXSDigitalMobileParamSKUEntity *)skuEntity
                  complete:(id)hasSelectedSKUEntity
{
    self.hasSelectedSKUEntity = skuEntity;
    self.block = [hasSelectedSKUEntity copy];
    
    if ([self.itemIDIntNum integerValue] != [itemIDIntNum integerValue]) {
        self.itemIDIntNum = itemIDIntNum;
        
        [self fetchAllSKUData];
    }
}


#pragma mark - Target Methods

- (void)dismissViewController:(UIGestureRecognizer *)gesture
{    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickCloseBtn:(id)sender
{
    [self dismissViewController:nil];
}

- (IBAction)onClickPayBtn:(id)sender
{
    if (nil != self.block) {
        self.block(self.hasSelectedSKUEntity);
    }
    
    [self dismissViewController:nil];
}


#pragma mark - Fetch Data

- (void)fetchAllSKUData
{
    [HXSLoadingView showLoadingInView:self.paramContentView];
    
    __weak typeof(self) weakSelf = self;
    [self.digitalMobileParamModel fetchItemAllSKUWithItemID:self.itemIDIntNum
                                                   complete:^(HXSErrorCode status, NSString *message, HXSDigitalMobileParamEntity *paramEntity) {
                                                       
                                                       if (kHXSNoError != status) {
                                                           [HXSLoadingView showLoadFailInView:weakSelf.collectionView
                                                                                        block:^{
                                                                                            [weakSelf fetchAllSKUData];
                                                                                        }];
                                                           
                                                           return ;
                                                       }
                                                       
                                                       [HXSLoadingView closeInView:weakSelf.paramContentView];
                                                       
                                                       weakSelf.digitalMobileParamEntity = paramEntity;
                                                       
                                                       [weakSelf refreshSubViews];
                                                   }];
}

- (void)refreshSubViews
{
    [self updateFilterArr];
    
    [self updateSelectedSKUEntity];
    
    [self updateHeaderView];
    
    [self updateBottomView];
    
    [self updateCollectionViewHeight];
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDigitalMobileParamPropertyEntity *propertyEntity = [self.digitalMobileParamEntity.availablePropertiesArr objectAtIndex:indexPath.section];
    HXSDigitalMobileParamPropertyValueEntity *valueEntity = [propertyEntity.valuesArr objectAtIndex:indexPath.row];
    
    CGFloat widthOfCell = 0.0;
    if (0 < [valueEntity.widthFloatNum floatValue]) {
        widthOfCell = [valueEntity.widthFloatNum floatValue];
    } else {
        CGFloat textWidth = [valueEntity.valueNameStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kHeightButton)
                                                                   options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                                   context:nil].size.width;
        
        widthOfCell = textWidth + kPadding;
    }
    
    return CGSizeMake(widthOfCell, kHeightButton);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, kHeightSection);
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.digitalMobileParamEntity.availablePropertiesArr count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HXSDigitalMobileParamPropertyEntity *propertyEntity = [self.digitalMobileParamEntity.availablePropertiesArr objectAtIndex:section];
    
    return [propertyEntity.valuesArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDigitalMobileParamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSDigitalMobileParamCollectionViewCell class]) forIndexPath:indexPath];
    
    HXSDigitalMobileParamPropertyEntity *propertyEntity = [self.digitalMobileParamEntity.availablePropertiesArr objectAtIndex:indexPath.section];
    HXSDigitalMobileParamPropertyValueEntity *valueEntity = [propertyEntity.valuesArr objectAtIndex:indexPath.row];
    
    NSDictionary *clickedValueDic = @{
                                      kPropertyId : propertyEntity.propertyIDIntNum,
                                      kValueName  : valueEntity.valueNameStr
                                      };
    HXSDigitalMobileButtonStatus buttonStatus = [self dealWithButtonStatusWithClickedValueDic:clickedValueDic
                                                                                     indexPath:indexPath];
    
    [cell setupCellWithEntity:valueEntity status:buttonStatus];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HXSDigitialMobileParamCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:NSStringFromClass([HXSDigitialMobileParamCollectionReusableView class])
                                                                 forIndexPath:indexPath];
        
        HXSDigitalMobileParamPropertyEntity *propertyEntity = [self.digitalMobileParamEntity.availablePropertiesArr objectAtIndex:indexPath.section];
        view.contentLabel.text = propertyEntity.propertyNameStr;
        
        reusableView = view;
    }
    
    return reusableView;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDigitalMobileParamCollectionViewCell *cell = (HXSDigitalMobileParamCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (kHXSDigitalMobileButtonStatusUnable == cell.status) {
        return NO;
    }
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self udpateSelectedValuesArrWhenClickedIndexpath:indexPath];
    
    [self refreshSubViews];
}


#pragma mark - Deal With Value Status

- (HXSDigitalMobileButtonStatus)dealWithButtonStatusWithClickedValueDic:(NSDictionary *)clickedValueDic
                                                               indexPath:(NSIndexPath *)indexPath
{
    HXSDigitalMobileButtonStatus buttonStatus = kHXSDigitalMobileButtonStatusNormal;
    
    // 是否被包含
    BOOL isContained = NO;
    for (HXSDigitalMobileParamSKUEntity *skuEntity in self.hasFilterSKUsArr) {
        BOOL isContian = [self digitalMobileParamSKUEntity:skuEntity
                            containSKUWithSelectedValueDic:clickedValueDic];
        if (isContian) {
            isContained = YES;
            break;
        }
    }
    
    if (!isContained) {
        buttonStatus = kHXSDigitalMobileButtonStatusUnable;
        
        return buttonStatus;
    }
    
    // 是否被选中
    NSDictionary *selectedValueDic = [self.hasSelectedValuesMArr objectAtIndex:indexPath.section];
    if ([selectedValueDic isKindOfClass:[NSDictionary class]]) {
        NSString *selectedValueNameStr = [selectedValueDic objectForKey:kValueName];
        NSNumber *selectedPropertyIDIntNum = [selectedValueDic objectForKey:kPropertyId];
        NSString *clickedValueNameStr = [clickedValueDic objectForKey:kValueName];
        NSNumber *clickedPropertyIDIntNum = [clickedValueDic objectForKey:kPropertyId];
        if ([selectedValueNameStr isEqualToString:clickedValueNameStr]
            && ([selectedPropertyIDIntNum integerValue] == [clickedPropertyIDIntNum integerValue])) {
            buttonStatus = kHXSDigitalMobileButtonStatusSelected;
        }
    }
    
    return buttonStatus;
}


#pragma mark - Update Selected Arr

- (void)udpateSelectedValuesArrWhenClickedIndexpath:(NSIndexPath *)indexPath
{
    HXSDigitalMobileParamPropertyEntity *propertyEntity = [self.digitalMobileParamEntity.availablePropertiesArr objectAtIndex:indexPath.section];
    HXSDigitalMobileParamPropertyValueEntity *valueEntity = [propertyEntity.valuesArr objectAtIndex:indexPath.row];
    NSDictionary *indexPathSelectedValueDic = @{
                                                kValueName  : valueEntity.valueNameStr,
                                                kPropertyId : propertyEntity.propertyIDIntNum
                                                };
    
    NSDictionary *hasSelectedDic = [self.hasSelectedValuesMArr objectAtIndex:indexPath.section];
    if ([hasSelectedDic isKindOfClass:[NSDictionary class]]) { // has saved
        NSString *valueStr = [hasSelectedDic objectForKey:kValueName];
        if ([valueEntity.valueNameStr isEqualToString:valueStr]) {
            [self.hasSelectedValuesMArr replaceObjectAtIndex:indexPath.section withObject:@""]; // remove the has selected value
        } else {
            [self.hasSelectedValuesMArr replaceObjectAtIndex:indexPath.section withObject:indexPathSelectedValueDic];
        }
    } else {
        [self.hasSelectedValuesMArr replaceObjectAtIndex:indexPath.section withObject:indexPathSelectedValueDic];
    }
}

- (void)updateFilterArr
{
    NSMutableArray *filterSKUsMArr = [[NSMutableArray alloc] initWithArray:self.digitalMobileParamEntity.skusArr];
    
    for (NSDictionary *dic in self.hasSelectedValuesMArr) {
        NSMutableArray *notInSKUsMArr = [[NSMutableArray alloc] initWithCapacity:5];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            for (HXSDigitalMobileParamSKUEntity *skuEntity in filterSKUsMArr) {
                BOOL isContian = [self digitalMobileParamSKUEntity:skuEntity
                                    containSKUWithSelectedValueDic:dic];
                if (!isContian) {
                    [notInSKUsMArr addObject:skuEntity];
                }
            }
            
            [filterSKUsMArr removeObjectsInArray:notInSKUsMArr];
        }
    }
    
    self.hasFilterSKUsArr = filterSKUsMArr;
}

- (void)updateSelectedSKUEntity
{
    // the one is been selected
    if (1 == [self.hasFilterSKUsArr count]) {
        self.hasSelectedSKUEntity = [self.hasFilterSKUsArr firstObject];
    } else {
        self.hasSelectedSKUEntity = nil;
    }
}

- (BOOL)digitalMobileParamSKUEntity:(HXSDigitalMobileParamSKUEntity *)skuEntity containSKUWithSelectedValueDic:(NSDictionary *)selectedValueDic
{
    BOOL isContained = NO;
    NSNumber *propertyIDIntNum = [selectedValueDic objectForKey:kPropertyId];
    NSString *valueNameStr = [selectedValueDic objectForKey:kValueName];
    
    for (HXSDigitalMobileParamSKUPropertyEntity *propertyEntity in skuEntity.propertiesArr) {
        if ([propertyEntity.propertyIDIntNum integerValue] == [propertyIDIntNum integerValue]) {
            if ([propertyEntity.valueNameStr isEqualToString:valueNameStr]) {
                isContained = YES;
            }
            
            break;
        }
    }
    
    return isContained;
}


#pragma mark - Update Header View

- (void)updateHeaderView
{
    HXSDigitalMobileParamSKUEntity *selectedSKUEntity = nil;
    if (nil == self.hasSelectedSKUEntity) {
        selectedSKUEntity = [self.digitalMobileParamEntity.skusArr firstObject];
    } else {
        selectedSKUEntity = self.hasSelectedSKUEntity;
    }
    
    // 图片
    [self.skuImageView sd_setImageWithURL:[NSURL URLWithString:selectedSKUEntity.skuImageURLStr]
                         placeholderImage:nil];
    
    // 名字
    self.skuNameLabel.text = selectedSKUEntity.nameStr;
    
    // 价格
    self.skuPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [selectedSKUEntity.priceFloatNum floatValue]];
}

- (void)updateBottomView
{
    HXSDigitalMobileParamSKUEntity *selectedSKUEntity = nil;
    if (nil == self.hasSelectedSKUEntity) {
        selectedSKUEntity = [self.digitalMobileParamEntity.skusArr firstObject];
    } else {
        selectedSKUEntity = self.hasSelectedSKUEntity;
    }
    
    self.skuBottomPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [selectedSKUEntity.priceFloatNum floatValue]];
}

- (void)updateCollectionViewHeight
{
    CGFloat totalHeaderViewHeight = kHeightSection * [self.digitalMobileParamEntity.availablePropertiesArr count];
    
    CGFloat totalParamHeight = 0.0;
    for (HXSDigitalMobileParamPropertyEntity *entity  in self.digitalMobileParamEntity.availablePropertiesArr) {
        NSInteger lines = 0;
        NSInteger valuesCount = [entity.valuesArr count];
        if (0 == (valuesCount % 3)) {
            lines = valuesCount / 3;
        } else {
            lines = (valuesCount / 3) + 1;
        }
        
        totalParamHeight += lines * kHeightButton; // 3 items is almost one line Just so so
    }
    
    CGFloat contentHeight = totalHeaderViewHeight + totalParamHeight + kHeightHeaderView + kHeightBottomView + kPadding;
    
    if (contentHeight < (SCREEN_HEIGHT - kTopPadding)) {
        self.paramContentViewTopConstraint.constant = SCREEN_HEIGHT - contentHeight;
    } else {
        self.paramContentViewTopConstraint.constant = kTopPadding;
    }
    
    [self.view layoutIfNeeded];
}


#pragma mark - Setter Getter Methods

- (HXSDigitalMobileParamModel *)digitalMobileParamModel
{
    if (nil == _digitalMobileParamModel) {
        _digitalMobileParamModel = [[HXSDigitalMobileParamModel alloc] init];
    }
    
    return _digitalMobileParamModel;
}

- (NSMutableArray *)hasSelectedValuesMArr
{
    if (nil == _hasSelectedValuesMArr) {
        NSMutableArray *tempMArr = [[NSMutableArray alloc] initWithCapacity:5];
        NSInteger count = [self.digitalMobileParamEntity.availablePropertiesArr count];
        while (count) {
            [tempMArr addObject:@""];
            
            count--;
        }
        
        _hasSelectedValuesMArr = tempMArr;
    }
    
    return _hasSelectedValuesMArr;
}


@end
