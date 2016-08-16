//
//  HXSPrintMainViewController.m
//  store
//
//  Created by J006 on 16/5/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSPrintMainViewController.h"
#import "HXSShopInfoViewController.h"
#import "TZImagePickerController.h"
#import "HXSMyFilesPrintViewController.h"
#import "HXSMyPhotosPrintCartViewController.h"
#import "HXSLoginViewController.h"

// Model
#import "HXSShopViewModel.h"
#import "HXSMainPrintTypeEntity.h"
#import "HXSPrintModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HXSMyPrintOrderItem.h"
#import "HXSPrintFilesManager.h"

// Views
#import "HXSNoticeView.h"
#import "HXSLocationCustomButton.h"
#import "HXSLoadingView.h"
#import "HXSActionSheet.h"
#import "HXSMyPhotosPrintCartViewController.h"
#import "HXSPrintMainCollectionViewCell.h"
#import "HXSPrintMainCollectionSectionViewCollectionReusableView.h"
#import "HXSPrintMainSingleLabelReusableView.h"

typedef NS_ENUM(NSInteger,HXSPrintMainViewCollectionViewType){
    kHXSPrintMainViewCollectionViewTypePrintSection      = 0,// 打印
    kHXSPrintMainViewCollectionViewTypeScanSection       = 1 // 扫描,复印
};

static NSInteger const kMaxUploadNums = 20; // 最大上传图片数量

@interface HXSPrintMainViewController ()<UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate,
                                         TZImagePickerControllerDelegate,
                                         HXSBannerLinkHeaderViewDelegate,
                                         HXSPrintMainCollectionSectionViewCollectionReusableViewDelegate>
/**店铺公告*/
@property (weak ,nonatomic) IBOutlet HXSNoticeView                              *noticeView;
@property (weak ,nonatomic) IBOutlet UICollectionView                           *mainCollectionView;
/**导航栏主标题即店铺名称*/
@property (nonatomic ,strong) HXSLocationCustomButton                           *locationButton;
/**弹出的店铺信息*/
@property (nonatomic ,strong) HXSShopInfoViewController                         *shopInfoVC;
/**是否已经淡出店铺信息*/
@property (nonatomic ,assign) BOOL                                              hasDisplayShopInfoView;

@property (nonatomic ,strong) HXSShopViewModel                                      *shopModel;
/**当前店铺entity*/
@property (nonatomic ,strong) HXSShopEntity                                     *shopEntity;
/**底部弹出选择照片框*/
@property (nonatomic ,strong) HXSActionSheet                                    *actionSheet;
@property (nonatomic ,strong) TZImagePickerController                           *pickerController;
/**打印类型数组*/
@property (nonatomic ,strong) NSArray<HXSMainPrintTypeEntity *>                 *printTypeArray;
@property (nonatomic ,strong) NSNumber                                          *shopIDIntNum;
@property (nonatomic ,strong) HXSPrintFilesManager                              *printFilesManager;

@property (nonatomic, strong) HXSMyPhotosPrintCartViewController                *printCartVC;
/**欢迎到店体验哦~*/
@property (nonatomic, strong) UILabel                                           *inforLabel;

@property (nonatomic, strong) HXSPrintMainCollectionSectionViewCollectionReusableView *reusableView;

@end

@implementation HXSPrintMainViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initTheShopInfor];
    
    [self initTheCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark init

+ (instancetype)createPrintVCWithShopId:(NSNumber *)shopIdIntNum
{
    HXSPrintMainViewController *printVC = [HXSPrintMainViewController controllerFromXib];
    
    printVC.shopIDIntNum = shopIdIntNum;
    
    return printVC;
}

+ (instancetype)createPrintVC
{
    HXSPrintMainViewController *printVC = [HXSPrintMainViewController controllerFromXib];
    
    return printVC;
}

- (void)initialNavigationBar
{
    self.navigationItem.titleView = self.locationButton;
    
    [_locationButton setTitle:_shopEntity.shopNameStr forState:UIControlStateNormal];

    [self.navigationItem.titleView layoutSubviews];
}

- (void)initTheShopInfor
{
    [self fetchShopInfoNetworking];
}

/**
 *  初始化店铺公告信息
 */
- (void)initTheNoticeView
{
    __weak typeof(self) weakSelf = self;
    if(_shopEntity)
    {
        [_noticeView createWithShopEntity:_shopEntity targetMethod:^{
            [weakSelf onClickTitleView:nil];
        }];
    }
}

/**
 *  店铺名称点击或者店铺信息点击的事件
 *
 *  @param button
 */
- (void)onClickTitleView:(UIButton *)button
{
    if (self.hasDisplayShopInfoView) {
        [_shopInfoVC dismissView];
    } else {
        __weak typeof(self) weakSelf = self;
        self.shopInfoVC.shopEntity = _shopEntity;
        _shopInfoVC.dismissShopInfoView = ^(void) {
            [weakSelf.shopInfoVC.view removeFromSuperview];
            [weakSelf.shopInfoVC removeFromParentViewController];
            [weakSelf.locationButton setImage:[UIImage imageNamed:@"ic_downwardwhite"] forState:UIControlStateNormal];
            weakSelf.hasDisplayShopInfoView = NO;
        };
        [self addChildViewController:_shopInfoVC];
        [self.view addSubview:_shopInfoVC.view];
        [_shopInfoVC.view mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.edges.equalTo(self.view);
         }];
        
        [_shopInfoVC didMoveToParentViewController:self];
        _hasDisplayShopInfoView = YES;
        [_locationButton setImage:[UIImage imageNamed:@"ic_upwardwhite"] forState:UIControlStateNormal];
    }
}

/**
 *  初始化可支持的打印功能
 */
- (void)initThePrintTypeArray
{
    _printTypeArray = [HXSPrintModel createTheMainPrintTypeArray];
    [_mainCollectionView reloadData];
}

- (void)initTheCollectionView
{
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintMainCollectionViewCell class]) bundle:nil]
           forCellWithReuseIdentifier:NSStringFromClass([HXSPrintMainCollectionViewCell class])];
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintMainCollectionSectionViewCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HXSPrintMainCollectionSectionViewCollectionReusableView class])];
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintMainSingleLabelReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HXSPrintMainSingleLabelReusableView class])];
    
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger counts = 2;//每section 2个
    
    return counts;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    HXSPrintMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSPrintMainCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell initPrintMainCollectionViewCellWithEntity:[_printTypeArray objectAtIndex:indexPath.row + indexPath.section * 2]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if(indexPath.section == kHXSPrintMainViewCollectionViewTypePrintSection) {
            HXSPrintMainCollectionSectionViewCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HXSPrintMainCollectionSectionViewCollectionReusableView class]) forIndexPath:indexPath];
            reusableView.headerBannerView.eventDelegate = self;
            reusableView.delegate = self;
            
            self.reusableView = reusableView;
            
            return reusableView;
        } else if(indexPath.section == kHXSPrintMainViewCollectionViewTypeScanSection) {
            HXSPrintMainSingleLabelReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HXSPrintMainSingleLabelReusableView class]) forIndexPath:indexPath];
            
            return reusableView;
        }
    }

    return nil;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case kHXSPrintMainViewCollectionViewTypePrintSection:
        {
            switch (indexPath.row) {
                case kHXSMainPrintTypePhoto://照片打印
                {
                    [self.actionSheet show];
                }
                    break;
                    
                default://文档打印
                {
                    __weak typeof(self) weakSelf = self;
                    if (![HXSUserAccount currentAccount].isLogin){
                        [HXSLoginViewController showLoginController:self loginCompletion:^{
                            HXSMyFilesPrintViewController *filesPrintVC = [HXSMyFilesPrintViewController
                                                                           createFilesPrintVCWithEntity:weakSelf.shopEntity];
                            
                            [weakSelf.navigationController pushViewController:filesPrintVC animated:YES];
                        }];
                    }else{
                        HXSMyFilesPrintViewController *filesPrintVC = [HXSMyFilesPrintViewController
                                                                       createFilesPrintVCWithEntity:_shopEntity];
                        
                        [weakSelf.navigationController pushViewController:filesPrintVC animated:YES];
                    }

                }
                    break;
            }
        }
            
            break;
            
        default:
        {
            NSString *message = @"欢迎到店体验哦~";
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2];
        }
        break;
    }
}


#pragma mark UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = UIEdgeInsetsZero;
    
    if(section == kHXSPrintMainViewCollectionViewTypeScanSection)
    {
        edge = UIEdgeInsetsMake(0, 0, 20, 0);
    }
    
    return edge;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(SCREEN_WIDTH/2,((SCREEN_WIDTH/2)-15-10));
    
    return size;
}

/**
 *Cell最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat space = 0;
    
    return space;
}

/**
 *Cell最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat space = 0;
    
    return space;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;
    if(section == kHXSPrintMainViewCollectionViewTypePrintSection)
    {
        size = CGSizeMake(SCREEN_WIDTH, SINGLE_LABEL_HEIGHT + self.reusableView.heightOfBannerFloat);
    }
    else if(section == kHXSPrintMainViewCollectionViewTypeScanSection)
    {
        size = CGSizeMake(SCREEN_WIDTH, SINGLE_LABEL_HEIGHT);
    }
    return size;
}


#pragma mark HXSBannerLinkHeaderViewDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark HXSPrintMainCollectionSectionViewCollectionReusableViewDelegate

- (void)refreshTheCollectionViewHasBanner:(BOOL)hasBanner
{
    if(!hasBanner) {
        self.reusableView.heightOfBannerFloat = 0;
    }
    
    [_mainCollectionView reloadData];
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        HXSMyPrintOrderItem *printOrderItem = [[HXSMyPrintOrderItem alloc]init];
        
        printOrderItem.fileNameStr = [self.printFilesManager createCameraImageNameByDate];
        
        printOrderItem.picImage = editedImage;
        
        NSMutableArray<HXSMyPrintOrderItem *> *array = [[NSMutableArray<HXSMyPrintOrderItem *> alloc] init];
        
        [array addObject:printOrderItem];
        
        HXSMyPhotosPrintCartViewController *printCartVC = [HXSMyPhotosPrintCartViewController createMyPhotosPrintCartViewControllerWithPrintOrderItemArray:array andShopEntity:_shopEntity];
        [weakSelf.navigationController pushViewController:printCartVC animated:YES];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
                        infos:(NSArray<NSDictionary *> *)infos
{
    if(!photos || [photos count] == 0) {
        return;
    }
    
    NSMutableArray<HXSMyPrintOrderItem *> *array = [[NSMutableArray<HXSMyPrintOrderItem *> alloc] init];
    
    for (UIImage *image in photos) {
        HXSMyPrintOrderItem *printOrderItem = [[HXSMyPrintOrderItem alloc]init];
        printOrderItem.picImage = image;
        
        printOrderItem.fileNameStr = [self.printFilesManager createCameraImageNameByDate];

        [array addObject:printOrderItem];
    }
    
    HXSMyPhotosPrintCartViewController *printCartVC = [HXSMyPhotosPrintCartViewController createMyPhotosPrintCartViewControllerWithPrintOrderItemArray:array andShopEntity:_shopEntity];
    
    [self.navigationController pushViewController:printCartVC animated:YES];
}


#pragma mark networking

/**
 *  初始化获取店铺信息网络接口
 */
- (void)fetchShopInfoNetworking
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    HXSLocationManager *manager = [HXSLocationManager manager];
    [self.shopModel fetchShopInfoWithSiteId:manager.currentSite.site_id
                                   shopType:@(2)
                                dormentryId:manager.buildingEntry.dormentryIDNum
                                     shopId:_shopIDIntNum
                                   complete:^(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity)
    {
        [HXSLoadingView closeInView:weakSelf.view];
        
        if (kHXSNoError != status) {
            [HXSLoadingView showLoadFailInView:weakSelf.view
                                         block:^{
                                             [weakSelf fetchShopInfoNetworking];
                                         }];
            
            return ;
        }
        
        weakSelf.shopEntity = shopEntity;
        
        [weakSelf initialNavigationBar];
        
        [weakSelf initTheNoticeView];
        
        [weakSelf initThePrintTypeArray];
    }];
}


#pragma mark TakePhoto or Camera

- (void)cameraAction
{
    [self jumpToTakePhotoViewOrAlbumView:YES];
}

- (void)takePhotoFromAlbumAction
{
    [self jumpToTakePhotoViewOrAlbumView:NO];
}

/**
 *  跳转到相机或者相册界面
 *
 *  @param isCamera
 */
- (void)jumpToTakePhotoViewOrAlbumView:(BOOL)isCamera
{
    if(isCamera) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;//设置不可编辑
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        _pickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:kMaxUploadNums delegate:self];
        _pickerController.allowPickingVideo = NO;
        _pickerController.allowPickingOriginalPhoto = NO;
        
        [self presentViewController:_pickerController animated:YES completion:nil];
    }
}


#pragma mark getter setter

- (HXSLocationCustomButton *)locationButton
{
    if(!_locationButton) {
        _locationButton = [HXSLocationCustomButton buttonWithType:UIButtonTypeCustom];
        [_locationButton addTarget:self action:@selector(onClickTitleView:) forControlEvents:UIControlEventTouchUpInside];
        [_locationButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];
        [_locationButton setImage:[UIImage imageNamed:@"ic_downwardwhite"] forState:UIControlStateNormal];
        [_locationButton setTitle:_shopEntity.shopNameStr forState:UIControlStateNormal];
    }
    return _locationButton;
}

- (HXSShopInfoViewController *)shopInfoVC
{
    if (!_shopInfoVC) {
        _shopInfoVC = [HXSShopInfoViewController controllerFromXib];
    }
    
    return _shopInfoVC;
}

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet){
        HXSActionSheetEntity *cameraEntity = [[HXSActionSheetEntity alloc] init];
        cameraEntity.nameStr = @"拍照";
        HXSActionSheetEntity *photoEntity = [[HXSActionSheetEntity alloc] init];
        photoEntity.nameStr = @"打开本地相册";
        __weak typeof(self) weakSelf = self;
        HXSAction *cameraAction = [HXSAction actionWithMethods:cameraEntity
                                                       handler:^(HXSAction *action){
                                                           [weakSelf cameraAction];
                                                           
                                                       }];
        HXSAction *photoAction = [HXSAction actionWithMethods:photoEntity
                                                      handler:^(HXSAction *action){
                                                          [weakSelf takePhotoFromAlbumAction];
                                                      }];
        
        _actionSheet = [HXSActionSheet actionSheetWithMessage:@""
                                            cancelButtonTitle:@"取消"];
        [_actionSheet addAction:photoAction];
        [_actionSheet addAction:cameraAction];
    }
    return _actionSheet;
}

- (HXSPrintFilesManager *)printFilesManager
{
    if(!_printFilesManager) {
        _printFilesManager = [[HXSPrintFilesManager alloc]init];
    }
    return _printFilesManager;
}

@end
