//
//  HXSPrintSettingViewController.m
//  store
//
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

//view controller
#import "HXSPrintSettingViewController.h"
#import "HXSPrintCheckoutViewController.h"

//view
#import "HXSPrintSettingPrintReduceCell.h"
#import "HXSPrintSettingPagesModifyCell.h"
#import "HXSPrintSettingHeaderView.h"

//model
#import "HXSPrintSettingViewModel.h"
#import "HXSPrintTotalSettingEntity.h"
#import "HXSPrintCartEntity.h"
#import "HXSPrintFilesManager.h"


static const NSInteger SECTIONNUMS   = 3; // 打印与缩印外加一个页数
static const CGFloat HEIGHT_SECTION  = 50;
static const CGFloat HEIGHT_BUTTON   = 20;
static const CGFloat PADDING         = 30;
static const CGFloat ROW_PADDING     = 15;

@interface HXSPrintSettingViewController ()<HXSPrintSettingPagesModifyCellDelegate>

/**顶部view*/
@property (weak, nonatomic) IBOutlet UIButton           *topViewButton;
@property (weak, nonatomic) IBOutlet UIView             *middleView;
@property (weak, nonatomic) IBOutlet UICollectionView   *mainCollectionView;
/**关闭整个界面*/
@property (weak, nonatomic) IBOutlet UIButton           *closeButton;
/**页数*/
@property (weak, nonatomic) IBOutlet UILabel            *pagesNumLabel;
/**文档名称*/
@property (weak, nonatomic) IBOutlet UILabel            *documentNameLabel;
@property (weak, nonatomic) IBOutlet UIView             *bottomEditView;
/**确定按钮*/
@property (weak, nonatomic) IBOutlet UIButton           *editConfirmButton;

@property (nonatomic, strong) HXSPrintDownloadsObjectEntity *printDownloadObjectEntity;
@property (nonatomic, strong) HXSMyPrintOrderItem           *myPrintOrderEntity;
@property (nonatomic, strong) HXSShopEntity                 *currentShopEntity;
@property (nonatomic, strong) HXSPrintTotalSettingEntity    *settingEntity;
/**当前打印份数*/
@property (nonatomic, assign) NSInteger                     currentPrintNums;
/**当前选择的打印类型*/
@property (nonatomic, strong) HXSPrintSettingEntity         *currentSelectSetPrintEntity;
/**当前选择的缩印类型*/
@property (nonatomic, strong) HXSPrintSettingReducedEntity  *currentSelectSetReduceEntity;

/**购物车集合*/
@property (nonatomic, strong) NSMutableArray                *cartArray;
@property (nonatomic, assign) HXSPrintCartSettingType       type;
@property (nonatomic, strong) HXSPrintFilesManager          *printFilesManager;

@end

@implementation HXSPrintSettingViewController


#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTheMiddleView];
    
    [self initTheCollectionView];
    
    [self initNetworkingFetchPrintSetting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - init

- (void)initPrintSettingViewControllerWithEntity:(HXSMyPrintOrderItem *)entity
                                     andWithShop:(HXSShopEntity *)shopEntity
                                andWithCartArray:(NSMutableArray *)array
               andWithPrintDownloadsObjectEntity:(HXSPrintDownloadsObjectEntity *)downloadObjectEntity
                                         andType:(HXSPrintCartSettingType)type
{
    _type                       = type;
    _myPrintOrderEntity         = entity;
    _currentShopEntity          = shopEntity;
    _cartArray                  = array;
    
    if(downloadObjectEntity) {
        _printDownloadObjectEntity  = downloadObjectEntity;
    }
    
    _currentPrintNums           = [entity.quantityIntNum integerValue];
}

/**
 *  初始化中部view,更换logo和文件名
 */
- (void)initTheMiddleView
{
    if(!_myPrintOrderEntity) {
        return;
    }
    
    switch (_myPrintOrderEntity.archiveDocTypeNum)
    {
        case HXSDocumentTypePdf:
        {
            [_printDocumentLogoImageView setImage:[UIImage imageNamed:@"img_print_pdf"]];
            break;
        }
        case HXSDocumentTypeDoc:
        {
            [_printDocumentLogoImageView setImage:[UIImage imageNamed:@"img_print_word"]];
            break;
        }
        case HXSDocumentTypeTxt:
        {
            [_printDocumentLogoImageView setImage:[UIImage imageNamed:@"img_print_word"]];
            break;
        }
        case HXSDocumentTypeImageJPEG:
        case HXSDocumentTypeImagePNG:
        case HXSDocumentTypeImageGIF:
        case HXSDocumentTypeImageTIFF:
        case HXSDocumentTypeImageWEBP:
        {
            NSURL *url = [[NSURL alloc]initWithString:[_myPrintOrderEntity originPathStr]];
            [_printDocumentLogoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_print_picture"]];
            break;
        }
        case HXSDocumentTypePPT:
        {
            [_printDocumentLogoImageView setImage:[UIImage imageNamed:@"img_print_ppt"]];
            break;
        }
    }
    
    switch (_type)
    {
        case HXSPrintCartSettingTypeDoc:
        {
            if(_myPrintOrderEntity.pageIntNum)
            {
                NSString *pageNums = [_myPrintOrderEntity.pageIntNum stringValue];
                [_pagesNumLabel setText:[NSString stringWithFormat:@"%@页",pageNums]];
            }
            if(_myPrintOrderEntity.fileNameStr)
            {
                [_documentNameLabel setText:_myPrintOrderEntity.fileNameStr];
            }
            break;
        }
        case HXSPrintCartSettingTypePic:
        {
            [_documentNameLabel setText:_myPrintOrderEntity.fileNameStr];
            
            [_printDocumentLogoImageView setImage:_myPrintOrderEntity.picImage];
            break;
        }
    }
}

/**
 *  初始化网络请求打印样式、缩印样式设置
 */
- (void)initNetworkingFetchPrintSetting
{
    [MBProgressHUD showInView:self.view];
    __weak __typeof(self)weakSelf = self;
    HXSPrintSettingViewModel *model = [[HXSPrintSettingViewModel alloc]init];
    
    switch (_type) {
        case HXSPrintCartSettingTypeDoc:
        {
            [model fetchPrintSettingWithShopId:[_currentShopEntity shopIDIntNum]
                                      Complete:^(HXSErrorCode status, NSString *message, HXSPrintTotalSettingEntity *entity)
             {
                 [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                 weakSelf.settingEntity = entity;
                 [weakSelf initTheSettingTypeWithPrintTotalSettingEntity];
                 [weakSelf.mainCollectionView reloadData];
             } failure:^(NSString *errorMessage)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:NO];
                 if (weakSelf.view)
                     [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:errorMessage afterDelay:1.5];
             }];
        }
            
            break;
            
        default:
        {
            [model fetchPhotoPrintSettingWithShopId:[_currentShopEntity shopIDIntNum]
                                           Complete:^(HXSErrorCode status, NSString *message, HXSPrintTotalSettingEntity *entity)
            {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                
                if(entity) {
                    weakSelf.settingEntity = entity;
                    [weakSelf initTheSettingTypeWithPrintTotalSettingEntity];
                    [weakSelf.mainCollectionView reloadData];
                } else {
                    if (weakSelf.view) {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                    }
                }
            }];
        }
            break;
    }
}

- (void)initTheCollectionView
{
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintSettingPrintReduceCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HXSPrintSettingPrintReduceCell class])];
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintSettingPagesModifyCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HXSPrintSettingPagesModifyCell class])];
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintSettingHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HXSPrintSettingHeaderView class])];
}

/**
 *  设置初始化打印与缩印
 */
- (void)initTheSettingTypeWithPrintTotalSettingEntity
{
    _currentSelectSetPrintEntity  = _myPrintOrderEntity.currentSelectSetPrintEntity;
    _currentSelectSetReduceEntity = _myPrintOrderEntity.currentSelectSetReduceEntity;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    switch (indexPath.section)
    {
        case 1:
        {
            HXSPrintSettingReducedEntity *reduceSettingEntity = [_settingEntity.reduceSettingArray objectAtIndex:indexPath.row];
            NSString *buttonTitle = reduceSettingEntity.reduceedNameStr;
            CGFloat textWidth = [buttonTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, HEIGHT_BUTTON)
                                                          options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                          context:nil].size.width;
            CGFloat widthOfCell = textWidth + PADDING;
            size = CGSizeMake(widthOfCell, HEIGHT_BUTTON);
        }
            break;
            
        case 2:
        {
            //底部打印份数的高宽
            size = CGSizeMake(85, 24);
        }
            
            break;
            
        default:
        {
            HXSPrintSettingEntity *printSettingEntity = [_settingEntity.printSettingArray objectAtIndex:indexPath.row];
            NSString *buttonTitle = [NSString stringWithFormat:@"%@ ¥%.2f",printSettingEntity.printNameStr,[printSettingEntity.unitPriceNum doubleValue]];
            CGFloat textWidth = [buttonTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, HEIGHT_BUTTON)
                                                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                                       context:nil].size.width;
            CGFloat widthOfCell = textWidth + PADDING;
            size = CGSizeMake(widthOfCell, HEIGHT_BUTTON);
        }
            break;
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, HEIGHT_SECTION);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0, ROW_PADDING, 0, ROW_PADDING);
    
    return edge;
}

/**
 *Cell最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    NSInteger space = ROW_PADDING;//每个items之间的最小行间距
    if(section == 2)
        space = 0;
    return space;
}

/**
 *Cell最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    NSInteger space = ROW_PADDING;//每个items之间的最小列间距
    if(section == 2)
        space = 0;
    return space;
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sections = 0;
    if(_settingEntity)
        sections = SECTIONNUMS;
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger items = 0;
    switch (section)
    {
        case 1:
        {
            if(_settingEntity && _settingEntity.reduceSettingArray) {
                items = [_settingEntity.reduceSettingArray count];
            }
        
        }
        break;
            
        case 2:
        {
            items = 1;
        }
            break;
            
        default:
        {
            if(_settingEntity && _settingEntity.printSettingArray) {
                items = [_settingEntity.printSettingArray count];
            }
        }
            break;
    }
    
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 1:
        {
            HXSPrintSettingPrintReduceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSPrintSettingPrintReduceCell class]) forIndexPath:indexPath];
            HXSPrintSettingReducedEntity *reducedSettingEntity = [_settingEntity.reduceSettingArray objectAtIndex:indexPath.row];
            HXSPrintSettingButtonStatus status = [self currentReduceStatusWithindexPath:indexPath];
            [cell setupCellWithReduceEntity:reducedSettingEntity status:status];
            return cell;
        }
            break;
            
        case 2:
        {
            HXSPrintSettingPagesModifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSPrintSettingPagesModifyCell class]) forIndexPath:indexPath];
            [cell initPrintSettingPagesModifyCellWithHXSMyPrintOrderItem:_myPrintOrderEntity
                                                   andWithQuantityIntNum:[[NSNumber alloc]initWithInteger:_currentPrintNums]];
            cell.delegate = self;
            return cell;
        }
            break;
            
        default:
        {
            HXSPrintSettingPrintReduceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSPrintSettingPrintReduceCell class]) forIndexPath:indexPath];
            HXSPrintSettingEntity *printSettingEntity = [_settingEntity.printSettingArray objectAtIndex:indexPath.row];
            HXSPrintSettingButtonStatus status = [self currentPrintStatusWithindexPath:indexPath];
            [cell setupCellWithPrintEntity:printSettingEntity status:status];
            return cell;
            
        }
            break;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HXSPrintSettingHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HXSPrintSettingHeaderView class]) forIndexPath:indexPath];
        reusableView = view;
        
        [self reusableViewContentSetting:view.contentLabel andIndexPath:indexPath];
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 1:
        {
            HXSPrintSettingReducedEntity *reducedSettingEntity = [_settingEntity.reduceSettingArray objectAtIndex:indexPath.row];
            _currentSelectSetReduceEntity = reducedSettingEntity;
        }
            break;
            
        default:
        {

            HXSPrintSettingEntity *printSettingEntity = [_settingEntity.printSettingArray objectAtIndex:indexPath.row];
            _currentSelectSetPrintEntity = printSettingEntity;
        }
            break;
    }
    [collectionView reloadData];
}


#pragma mark - HXSPrintSettingPagesModifyCellDelegate

- (void)confirmPrintNumsWithNums:(NSInteger)nums
{
    _currentPrintNums = nums;
}


#pragma mark - Button Action

/**
 *  关闭当前设置界面
 *
 *  @param sender
 */
- (IBAction)closeButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  确认
 *
 *  @param sender
 */
- (IBAction)editConfirmAction:(id)sender
{
    _myPrintOrderEntity.currentSelectSetPrintEntity   = _currentSelectSetPrintEntity;
    _myPrintOrderEntity.printTypeIntNum               = _currentSelectSetPrintEntity.printTypeNum;
    _myPrintOrderEntity.currentSelectSetReduceEntity  = _currentSelectSetReduceEntity;
    _myPrintOrderEntity.reducedTypeIntNum             = _currentSelectSetReduceEntity.reduceedTypeNum;
    _myPrintOrderEntity.quantityIntNum    = [[NSNumber alloc]initWithInteger:_currentPrintNums];
    
    switch (_type)
    {
        case HXSPrintCartSettingTypeDoc:
        {
            [self.printFilesManager checkTheCurrentSettingAndGetTheTotalPrice:_myPrintOrderEntity];
            break;
        }
        case HXSPrintCartSettingTypePic:
        {
            [self.printFilesManager checkTheCurrentSettingAndGetTheTotalPhotoPrice:_myPrintOrderEntity];
            break;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmCartWithOrderItem:andWithPrintDownloadsObjectEntity:)]) {
        [self.delegate confirmCartWithOrderItem:_myPrintOrderEntity
              andWithPrintDownloadsObjectEntity:_printDownloadObjectEntity];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private methods

/**
 *  根据当前打印设置的选中索引值确认参数指定的items是否是被选中的
 *
 *  @param indexPath 打印设置按钮的索引值
 *
 *  @return
 */
- (HXSPrintSettingButtonStatus)currentPrintStatusWithindexPath:(NSIndexPath *)indexPath
{
    HXSPrintSettingEntity *printSettingEntity = [_settingEntity.printSettingArray objectAtIndex:indexPath.row];
    HXSDocumentSetPrintType printTypeIntNum = printSettingEntity.printTypeNum;
    if(_currentSelectSetPrintEntity.printTypeNum == printTypeIntNum)
        return kHXSPrintSettingButtonStatusSelected;
    else
        return kHXSPrintSettingButtonStatusNormal;
    return kHXSPrintSettingButtonStatusNormal;
}

/**
 *  根据当前缩印设置的选中索引值确认参数指定的items是否是被选中的
 *
 *  @param indexPath 缩印设置按钮的索引值
 *
 *  @return
 */
- (HXSPrintSettingButtonStatus)currentReduceStatusWithindexPath:(NSIndexPath *)indexPath
{
    HXSPrintSettingReducedEntity *reducedSettingEntity = [_settingEntity.reduceSettingArray objectAtIndex:indexPath.row];
    HXSDocumentSetReduceType reduceTypeIntNum = reducedSettingEntity.reduceedTypeNum;
    if(_currentSelectSetReduceEntity.reduceedTypeNum == reduceTypeIntNum)
        return kHXSPrintSettingButtonStatusSelected;
    else
        return kHXSPrintSettingButtonStatusNormal;
    return kHXSPrintSettingButtonStatusNormal;
}

/**
 *  设置顶部可复用内容信息
 *
 *  @param label
 *  @param indexPath
 */
- (void)reusableViewContentSetting:(UILabel *)label andIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 1:
        {
            if(_type == HXSPrintCartSettingTypeDoc) {
                [label setText:@"缩印"];
            } else if(_type == HXSPrintCartSettingTypePic) {
                [label setText:@"相纸款式"];
            }
        }
            break;
            
        case 2:
        {
            [label setText:@"打印份数"];
        }
            break;
            
        default:
        {
            if(_type == HXSPrintCartSettingTypeDoc) {
                [label setText:@"打印样式(元/张)"];
            } else if(_type == HXSPrintCartSettingTypePic) {
                [label setText:@"相纸尺寸"];
            }
        }
            break;
    }
}

#pragma mark getter setter

- (HXSPrintFilesManager *)printFilesManager
{
    if(!_printFilesManager) {
        _printFilesManager = [[HXSPrintFilesManager alloc]init];
    }
    return _printFilesManager;
}

@end
