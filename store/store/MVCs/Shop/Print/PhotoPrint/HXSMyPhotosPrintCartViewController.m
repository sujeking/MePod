//
//  HXSMyPhotosPrintCartViewController.m
//  store
//
//  Created by J006 on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "TZImagePickerController.h"
#import "HXSMyPhotosPrintCartViewController.h"
#import "HXSShopInfoViewController.h"
#import "HXSPrintSettingViewController.h"
#import "HXSPrintCheckoutViewController.h"

// Model
#import "HXSPrintCartEntity.h"
#import "HXSActionSheet.h"
#import "HXSPrintSettingViewModel.h"
#import "HXSPrintFilesManager.h"
#import "HXSOSSManager.h"

// Views
#import "HXSPrintCartTableViewCell.h"
#import "HXSUploadImageView.h"
#import "HXSCustomAlertView.h"

static NSInteger const maxUploadPhotoNums = 20;// 最大上传图片数量

@interface HXSMyPhotosPrintCartViewController ()<UIImagePickerControllerDelegate,
                                                 UINavigationControllerDelegate,
                                                 TZImagePickerControllerDelegate,
                                                 HXSPrintSettingViewControllerDelegate,
                                                 HXSUploadImageViewDelegate>

/**店铺名称 */
@property (weak, nonatomic) IBOutlet UILabel                        *shopNameLabel;
@property (weak, nonatomic) IBOutlet UITableView                    *mainTableView;
/**合计共计页数 */
@property (weak, nonatomic) IBOutlet UILabel                        *totalPagesNumsLabel;
/**合计价格 */
@property (weak, nonatomic) IBOutlet UILabel                        *totalPriceLabel;
/**确认订单 */
@property (weak, nonatomic) IBOutlet UIButton                       *confirmOrderButton;
/**顶部topView */
@property (weak, nonatomic) IBOutlet UIView                         *topView;
/**继续上传 */
@property (weak ,nonatomic) IBOutlet UIRenderingButton              *continueToUploadButton;

@property (nonatomic, strong) HXSShopEntity                         *shop;
/**购物车 */
@property (nonatomic, strong) NSMutableArray<HXSMyPrintOrderItem *> *cartArray;
/**提交的购物车entity */
@property (nonatomic, strong) HXSPrintCartEntity                    *printCartEntity;
/**弹出的店铺信息 */
@property (nonatomic, strong) HXSShopInfoViewController             *shopInfoVC;
/**是否已经淡出店铺信息 */
@property (nonatomic, assign) BOOL                                  hasDisplayShopInfoView;
/**底部弹出选择照片框 */
@property (nonatomic, strong) HXSActionSheet                        *actionSheet;
/**相册图片选择器 */
@property (nonatomic, strong) TZImagePickerController               *pickerController;

/**待删除文件 */
@property (nonatomic, strong) HXSMyPrintOrderItem                   *needToBeRemovedEntity;
/**打印设置 */
@property (nonatomic, strong) HXSPrintTotalSettingEntity            *settingEntity;
@property (nonatomic, strong) HXSPrintFilesManager                  *printFilesManager;
@property (nonatomic, strong) HXSActionSheet                        *deleteActionSheet;
/**左上角后退按钮 */
@property (nonatomic, strong) UIBarButtonItem                       *backBarButton;
/**阿里云上传对象 */
@property (nonatomic, strong) HXSOSSManager                         *ossManager;
/**所有上传图片的阿里云请求 */
@property (nonatomic, strong) NSMutableArray<OSSPutObjectRequest *> *ossRequestArray;
/**上传图片动画界面 */
@property (nonatomic, strong) HXSUploadImageView                    *uploadImageView;
/**需要上传的图片打印对象集合 */
@property (nonatomic, strong) NSMutableArray<HXSMyPrintOrderItem *> *uploadPrintOrderItemArray;
/**上传失败弹框 */
@property (nonatomic, strong) HXSCustomAlertView                    *uploadFailView;

/**上传线程队列,默认为单个上传 */
@property (nonatomic, strong) NSOperationQueue                      *operationQueue;

@end

@implementation HXSMyPhotosPrintCartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initTableView];
    
    [self initTheShopName];
    
    [self initTheShopVCInfor];
    
    [self fetchThePrintSettingNetworking];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mainTableView reloadData];
    
    [self checkTheCartView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - init

+ (instancetype)createMyPhotosPrintCartViewControllerWithPrintOrderItemArray:(NSMutableArray<HXSMyPrintOrderItem *> *)printOrderItemArray
                                                               andShopEntity:(HXSShopEntity *)shopEntity
{
    HXSMyPhotosPrintCartViewController *vc = [HXSMyPhotosPrintCartViewController controllerFromXib];
    
    vc.cartArray = printOrderItemArray;
    vc.shop      = shopEntity;
    
    return vc;
}

/**
 *  初始化导航栏
 */
- (void)initNavigationBar
{
    self.navigationItem.title = @"购物车";
    
    [self.navigationItem setLeftBarButtonItem:self.backBarButton];
}

/**
 *  初始化商店名称
 */
- (void)initTheShopName
{
    if(_shop) {
        [_shopNameLabel setText:_shop.shopNameStr];
    }
}

/**
 *  初始化tableview
 */
- (void)initTableView
{
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintCartTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSPrintCartTableViewCell class])];
}

/**
 *  初始化并设置底部购物车的价格
 */
- (void)initTheCart
{
    if(!_settingEntity) {
        return;
    }
    
    HXSPrintSettingEntity        *defaultPrintEntity  = [_settingEntity.printSettingArray objectAtIndex:0];
    HXSPrintSettingReducedEntity *defaultReduceEntity = [_settingEntity.reduceSettingArray objectAtIndex:0];
    
    if(_cartArray && _cartArray.count > 0) {
        for (HXSMyPrintOrderItem *orderItem in _cartArray) {
            orderItem.currentSelectSetPrintEntity  = defaultPrintEntity;
            orderItem.currentSelectSetReduceEntity = defaultReduceEntity;
            orderItem.reducedTypeIntNum            = defaultReduceEntity.reduceedTypeNum;
            orderItem.printTypeIntNum              = defaultPrintEntity.printTypeNum;
            orderItem.pageReduceIntNum             = [NSNumber numberWithInteger:1];
            orderItem.quantityIntNum               = [NSNumber numberWithInteger:1];
            
            [self.printFilesManager checkTheCurrentSettingAndGetTheTotalPhotoPrice:orderItem];
        }
    }
    
    [self checkTheCartView];
}

/**
 *  初始化店铺下拉信息
 */
- (void)initTheShopVCInfor
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(onClickTopView:)];
    [_topView addGestureRecognizer:tapGesture];
}

/**
 *  店铺名称点击或者店铺信息点击的事件
 *
 *  @param button
 */
- (void)onClickTopView:(UITapGestureRecognizer *)tap
{
    if (self.hasDisplayShopInfoView) {
        [_shopInfoVC dismissView];
    } else {
        __weak typeof(self) weakSelf = self;
        self.shopInfoVC.shopEntity = _shop;
        _shopInfoVC.dismissShopInfoView = ^(void) {
            [weakSelf.shopInfoVC.view removeFromSuperview];
            [weakSelf.shopInfoVC removeFromParentViewController];
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
    }
}


#pragma mark - networking

/**
 *  网络连接获取打印设置
 */
- (void)fetchThePrintSettingNetworking
{
    HXSPrintSettingViewModel *model = [[HXSPrintSettingViewModel alloc]init];
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [model fetchPhotoPrintSettingWithShopId:_shop.shopIDIntNum
                                   Complete:^(HXSErrorCode status, NSString *message, HXSPrintTotalSettingEntity *entity)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if(entity) {
            weakSelf.settingEntity = entity;
            
            [weakSelf initTheCart];
            
            [weakSelf.mainTableView reloadData];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            if (weakSelf.view) {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
            }
        }
    }];
}

/**
 *  调用阿里云上传图片
 *
 *  @param printOrderItem
 */
- (void)uploadTheImageNetworking:(HXSMyPrintOrderItem *)printOrderItem
{
    if(!printOrderItem) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    __block OSSPutObjectRequest *ossRequest = [self.ossManager uploadThePrintImage:printOrderItem.picImage
                            andImageName:printOrderItem.fileNameStr
                                andBlock:^(NSString *fileURLName,NSString *errorFileName)
    {
        if(fileURLName) {
            printOrderItem.isUploadSuccess = YES;
            printOrderItem.pdfPathStr = fileURLName;
            printOrderItem.originPathStr = fileURLName;
            printOrderItem.pdfMd5Str = @"";
            printOrderItem.originMd5Str = @"";
            [weakSelf refreshTheUploadProgressViewAnimation];
        } else {
            [weakSelf.operationQueue cancelAllOperations];
            for (OSSPutObjectRequest *ossRequest in weakSelf.ossRequestArray) {
                [ossRequest cancel];
            }
            [weakSelf.ossRequestArray removeAllObjects];
            [weakSelf.uploadImageView removeFromSuperview];
            [weakSelf.uploadFailView setMessageStr:printOrderItem.fileNameStr];
            [weakSelf.uploadFailView show];
        }
    }
                             andProgress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend)
    {
        CGFloat tempTotalByteSent            = (CGFloat)totalByteSent;
        CGFloat tempTotalBytesExpectedToSend = (CGFloat)totalBytesExpectedToSend;
        CGFloat currentProgress              = tempTotalByteSent / tempTotalBytesExpectedToSend;
        printOrderItem.currentProgress       = floorf(printOrderItem.preProgress * currentProgress * 100) / 100;
        
        [weakSelf refreshTheUploadProgressViewAnimation];
    }];
    
    [self.ossRequestArray addObject:ossRequest];
}

/**
 *  增加上传动画
 */
- (void)addUploadProgressAnamation
{
    _uploadImageView = [[HXSUploadImageView alloc]initWithFrame:self.view.bounds];
    _uploadImageView.delegate = self;
    [_uploadImageView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_uploadImageView];
    //上传图片数量
    [_uploadImageView.uploadContentLabel setText:[NSString stringWithFormat:@"0/%zd",_uploadPrintOrderItemArray.count]];
}

/**
 *  刷新上传动画
 */
- (void)refreshTheUploadProgressViewAnimation
{
    if(!_ossRequestArray || _ossRequestArray.count == 0) {
        return;
    }
    
    CGFloat currentProgress  = 0;
    NSInteger succUploadNums = 0;
    
    for (HXSMyPrintOrderItem *item in _uploadPrintOrderItemArray) {
        currentProgress += item.currentProgress;
        if(item.isUploadSuccess) {
            succUploadNums++;
        }
    }
    
    if(succUploadNums == _uploadPrintOrderItemArray.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_uploadImageView.uploadContentLabel
             setText:[NSString stringWithFormat:@"%zd/%zd",succUploadNums,_uploadPrintOrderItemArray.count]];
            [_uploadImageView setProgress:1];
        });
    } else {
        if(_uploadImageView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_uploadImageView.uploadContentLabel
                 setText:[NSString stringWithFormat:@"%zd/%zd",succUploadNums,_uploadPrintOrderItemArray.count]];
                [_uploadImageView setProgress:currentProgress];
            });
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if(_cartArray && _settingEntity && [_cartArray count] > 0) {
        rows = [_cartArray count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintCartTableViewCell class]) forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSPrintCartTableViewCell *printTableViewCell = (HXSPrintCartTableViewCell *)cell;
    
    [printTableViewCell initPrintCartTableViewCellWithEntity:[_cartArray objectAtIndex:indexPath.row]
                                                     andType:kHXSPrintCartCellSettingTypePic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self jumpToSettingViewWithEntity:[_cartArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.deleteActionSheet show];
        _needToBeRemovedEntity = [_cartArray objectAtIndex:indexPath.row];
    }
}

#pragma mark - HXSPrintSettingViewControllerDelegate

- (void)confirmCartWithOrderItem:(HXSMyPrintOrderItem *)entity
andWithPrintDownloadsObjectEntity:(HXSPrintDownloadsObjectEntity *)objectEntity
{
    [self.printFilesManager checkTheCurrentSettingAndGetTheTotalPhotoPrice:entity];
    
    NSInteger index = [_cartArray indexOfObject:entity];
    NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [indexPathArray addObject:indexPath];
    
    [_mainTableView beginUpdates];
    [_mainTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    [_mainTableView endUpdates];
    
    [self checkTheCartView];
}


#pragma mark - JumpAction

/**
 *  跳转到设置界面
 *
 *  @param entity
 */
- (void)jumpToSettingViewWithEntity:(HXSMyPrintOrderItem *)entity
{
    HXSPrintSettingViewController *printSettingVC = [HXSPrintSettingViewController controllerFromXib];
    [printSettingVC initPrintSettingViewControllerWithEntity:entity
                                                 andWithShop:_shop
                                            andWithCartArray:_cartArray
                           andWithPrintDownloadsObjectEntity:nil
                                                     andType:HXSPrintCartSettingTypePic];
    printSettingVC.delegate = self;
    
    self.definesPresentationContext = YES;
    [printSettingVC.view setBackgroundColor:[UIColor clearColor]];
    printSettingVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:printSettingVC animated:YES completion:nil];
}


#pragma mark - check cart

/**
 *  检查并计算所有打印页面的总数和价格
 */
- (void)checkTheCartView
{
    NSInteger totalPage = 0;
    double totalPrice   = 0.00;
    
    if(_cartArray && _cartArray.count > 0) {
        self.printCartEntity.itemsArray = (NSMutableArray<HXSMyPrintOrderItem> *)_cartArray;
        for (HXSMyPrintOrderItem *orderItem in _cartArray) {
            NSInteger quantityNum = [orderItem.quantityIntNum integerValue];
            double    tempPrice   = [orderItem.priceDoubleNum doubleValue];
            totalPage  += quantityNum;
            totalPrice += tempPrice;
        }
        
        [_confirmOrderButton setEnabled:YES];
    } else {
        [_confirmOrderButton setEnabled:NO];
    }
    
    [_totalPagesNumsLabel setText:[NSString stringWithFormat:@"%zd张",totalPage]];
    [_totalPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",totalPrice]];
    NSNumber *totalPriceNumber = [[NSNumber alloc]initWithDouble:totalPrice];
    NSNumber *totalPageNumber  = [[NSNumber alloc]initWithInteger:totalPage];
    self.printCartEntity.itemsArray          = (NSMutableArray<HXSMyPrintOrderItem> *)_cartArray;
    _printCartEntity.totalAmountDoubleNum    = totalPriceNumber;
    _printCartEntity.deliveryAmountDoubleNum = totalPriceNumber;
    _printCartEntity.documentAmountDoubleNum = totalPriceNumber;
    _printCartEntity.printPagesIntNum        = totalPageNumber;
    _printCartEntity.shopIdIntNum = [_shop shopIDIntNum];
    _printCartEntity.docTypeNum = @(0);//类型:图片
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        HXSMyPrintOrderItem *printOrderItem = [[HXSMyPrintOrderItem alloc]init];
        
        printOrderItem.fileNameStr = [self.printFilesManager createCameraImageNameByDate];
        printOrderItem.picImage = editedImage;
        
        HXSPrintSettingEntity        *defaultPrintEntity  = [_settingEntity.printSettingArray objectAtIndex:0];
        HXSPrintSettingReducedEntity *defaultReduceEntity = [_settingEntity.reduceSettingArray objectAtIndex:0];
        
        printOrderItem.currentSelectSetPrintEntity  = defaultPrintEntity;
        printOrderItem.currentSelectSetReduceEntity = defaultReduceEntity;
        printOrderItem.reducedTypeIntNum            = defaultReduceEntity.reduceedTypeNum;
        printOrderItem.printTypeIntNum              = defaultPrintEntity.printTypeNum;
        printOrderItem.quantityIntNum               = [NSNumber numberWithInteger:1];
        printOrderItem.pageReduceIntNum             = [NSNumber numberWithInteger:1];        
        
        [weakSelf.cartArray addObject:printOrderItem];
  
        [weakSelf.printFilesManager checkTheCurrentSettingAndGetTheTotalPhotoPrice:printOrderItem];
        
        [weakSelf.mainTableView reloadData];
        
        [weakSelf checkTheCartView];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
                        infos:(NSArray<NSDictionary *> *)infos
{
    if(!photos || [photos count] == 0) {
        return;
    }
    
    for (UIImage *image in photos) {
        HXSMyPrintOrderItem *printOrderItem = [[HXSMyPrintOrderItem alloc]init];
        printOrderItem.picImage             = image;
        
        HXSPrintSettingEntity        *defaultPrintEntity  = [_settingEntity.printSettingArray objectAtIndex:0];
        HXSPrintSettingReducedEntity *defaultReduceEntity = [_settingEntity.reduceSettingArray objectAtIndex:0];
        
        printOrderItem.currentSelectSetPrintEntity  = defaultPrintEntity;
        printOrderItem.currentSelectSetReduceEntity = defaultReduceEntity;
        printOrderItem.reducedTypeIntNum            = defaultReduceEntity.reduceedTypeNum;
        printOrderItem.printTypeIntNum              = defaultPrintEntity.printTypeNum;
        printOrderItem.quantityIntNum               = [NSNumber numberWithInteger:1];
        printOrderItem.pageReduceIntNum             = [NSNumber numberWithInteger:1];
        
        printOrderItem.fileNameStr = [self.printFilesManager createCameraImageNameByDate];
        
        [self.printFilesManager checkTheCurrentSettingAndGetTheTotalPhotoPrice:printOrderItem];
        
        [_cartArray addObject:printOrderItem];
    }
    
    [_mainTableView reloadData];
    
    [self checkTheCartView];
}


#pragma mark - HXSUploadImageViewDelegate

- (void)confirmUploadFinished
{
    [self jumpToCheckOutViewController];
}


#pragma mark - Button Action

/**
 *  继续添加
 *
 *  @param sender
 */
- (IBAction)continueAddToCartAction:(id)sender
{
    if(_cartArray && _cartArray.count == maxUploadPhotoNums)
    {
        NSString *message = [NSString stringWithFormat:@"最大上传不能超过%zd张~",maxUploadPhotoNums];
        [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5];
        return;
    }
    
    [self.actionSheet show];
}

/**
 *  确认订单
 *
 *  @param sender
 */
- (IBAction)confirmCartButtonAction:(id)sender
{
    if(!_cartArray || [_cartArray count] == 0 || !_settingEntity) {
        NSString *noCartStr = @"购物车中没有商品,无法确认订单~";
        if (self.view) {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:noCartStr afterDelay:1.5];
        }
        return;
    }
    
    if(_uploadPrintOrderItemArray) {
        [_uploadPrintOrderItemArray removeAllObjects];
    } else {
        _uploadPrintOrderItemArray = [[NSMutableArray<HXSMyPrintOrderItem *> alloc]init];
    }
    
    NSInteger needToUploadItemNums = 0;
    
    for (HXSMyPrintOrderItem *pringOrderItem in _cartArray) {
        if(!pringOrderItem.isUploadSuccess) {
            needToUploadItemNums++ ;
            [_uploadPrintOrderItemArray addObject:pringOrderItem];
        }
    }
    
    CGFloat subTotalProgress = 0.00;
    
    if(needToUploadItemNums == 0) { // 无需上传,直接提交到确认订单.
        [self jumpToCheckOutViewController];
        return;
    } else {
        subTotalProgress = 1.00 / needToUploadItemNums;
    }
    
    [self addUploadProgressAnamation];
    
    _operationQueue = [[NSOperationQueue alloc] init];
    
    _operationQueue.maxConcurrentOperationCount = 1;
    
    for (HXSMyPrintOrderItem *pringOrderItem in _uploadPrintOrderItemArray) {
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            pringOrderItem.preProgress = subTotalProgress;
            [self uploadTheImageNetworking:pringOrderItem];
        }];
        
        [_operationQueue addOperation:blockOperation];
    }
}

/**
 *  跳转到打印确认页面
 */
- (void)jumpToCheckOutViewController
{
    HXSPrintCheckoutViewController *checkoutViewController = [HXSPrintCheckoutViewController controllerFromXib];
    [checkoutViewController initPrintCheckoutViewControllerWithEntity:_printCartEntity andWithShopEntity:_shop];
    __weak typeof(self) weakSelf = self;
    checkoutViewController.clearPrintStoreCart = ^{
        NSMutableArray *arr =[NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
        [arr removeObject:weakSelf];
        weakSelf.navigationController.viewControllers = arr;
    };
    [self.navigationController pushViewController:checkoutViewController animated:YES];
}


#pragma mark - TakePhoto or Camera

/**
 *  拍照
 */
- (void)cameraAction
{
    [self jumpToTakePhotoViewOrAlbumView:YES];
}

/**
 *  从相册选择图片
 */
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
        NSInteger photoNums = 0;
        if(_cartArray)
        {
            photoNums = [_cartArray count];
        }
        _pickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:maxUploadPhotoNums - photoNums
                                                                          delegate:self];
        _pickerController.allowPickingVideo = NO;
        _pickerController.allowPickingOriginalPhoto = NO;
        
        [self presentViewController:_pickerController animated:YES completion:nil];
    }
}


#pragma mark - deleteSheetAction

/**
 *  删除图片
 *
 *  @param entity
 */
- (void)deleteSheetAction
{
    [self removedFromCartWithEntity:_needToBeRemovedEntity];
}

- (void)removedFromCartWithEntity:(HXSMyPrintOrderItem *)entity
{
    NSInteger index = [_cartArray indexOfObject:entity];
    
    [_cartArray removeObject:entity];
    
    entity.isAddToCart = NO;
    
    if(_cartArray.count == 0) {
        [_mainTableView reloadData];
    } else {
        [_mainTableView beginUpdates];
        NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPathArray addObject:indexPath];
        [_mainTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        [_mainTableView endUpdates];
    }
    
    [self checkTheCartView];
}


#pragma mark - Override Navigtaion Left Item Methods

- (void)backBarButtonAction
{
    if(!_cartArray || _cartArray.count == 0 || !_settingEntity) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc]initWithTitle:@"确定退出购物车?" message:@"注意:该操作会清空购物车" leftButtonTitle:@"取消" rightButtonTitles:@"退出"];
    __weak typeof(self) weakSelf = self;
    alertView.rightBtnBlock = ^{
        
        for (OSSPutObjectRequest *request in weakSelf.ossRequestArray) {
            [request cancel];
        }
        
        [weakSelf.ossRequestArray removeAllObjects];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    };
    [alertView show];
}


#pragma mark - getter/setter

- (HXSPrintCartEntity *)printCartEntity
{
    if(!_printCartEntity) {
        _printCartEntity = [[HXSPrintCartEntity alloc]init];
    }
    return _printCartEntity;
}

- (HXSShopInfoViewController *)shopInfoVC
{
    if (!_shopInfoVC) {
        _shopInfoVC = [HXSShopInfoViewController controllerFromXib];
    }
    
    return _shopInfoVC;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet) {
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

- (HXSActionSheet *)deleteActionSheet
{
    if(!_deleteActionSheet) {
        HXSActionSheetEntity *deleteEntity = [[HXSActionSheetEntity alloc] init];
        deleteEntity.nameStr = @"删除";
        __weak typeof(self) weakSelf = self;
        HXSAction *deleteAction = [HXSAction actionWithMethods:deleteEntity
                                                       handler:^(HXSAction *action){
                                                           [weakSelf deleteSheetAction];
                                                           
                                                       }];
        
        _deleteActionSheet = [HXSActionSheet actionSheetWithMessage:@"确定将该文件从购物车中删除?"
                                            cancelButtonTitle:@"取消"];
        [_deleteActionSheet addAction:deleteAction];
    }
    return _deleteActionSheet;
}

- (HXSPrintFilesManager *)printFilesManager
{
    if(!_printFilesManager) {
        _printFilesManager = [[HXSPrintFilesManager alloc]init];
    }
    return _printFilesManager;
}

- (UIBarButtonItem *)backBarButton
{
    if(!_backBarButton) {
        UIImage *backImage = [UIImage imageNamed:@"btn_back_normal"];
        _backBarButton =[[UIBarButtonItem alloc] initWithImage:backImage
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backBarButtonAction)];
        
    }
    return _backBarButton;
}

- (HXSOSSManager *)ossManager
{
    if(!_ossManager) {
        _ossManager = [[HXSOSSManager alloc]init];
        [_ossManager initTheHXSOSSManager];
    }
    return _ossManager;
}

- (NSMutableArray<OSSPutObjectRequest *> *)ossRequestArray
{
    if(!_ossRequestArray) {
        _ossRequestArray = [[NSMutableArray<OSSPutObjectRequest *> alloc] init];
    }
    return _ossRequestArray;
}

- (HXSCustomAlertView *)uploadFailView
{
    if(!_uploadFailView) {
        _uploadFailView = [[HXSCustomAlertView alloc]initWithTitle:@"该照片上传失败"
                                                           message:@""
                                                   leftButtonTitle:@"取消"
                                                 rightButtonTitles:@"重试"];
        
        __weak typeof(self) weakSelf = self;
        _uploadFailView.rightBtnBlock = ^{
            [weakSelf confirmCartButtonAction:nil];
        };
    }
    return _uploadFailView;
}

@end
