//
//  HXSMyFilesPrintViewController.m
//  store
//
//  Created by J006 on 16/5/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSMyFilesPrintViewController.h"
#import "HXSPrintSettingViewController.h"
#import "CustomQLPreviewControllerViewController.h"
#import "HXSPrintCartViewController.h"
#import "HXSWebViewController.h"

// Views
#import "JCRBlurView.h"
#import "MIBadgeButton.h"
#import "HXSMyFilesPrintTableViewCell.h"
#import "HXSActionSheet.h"
#import "HXSMyFilesPopView.h"

// model
#import "HXSPrintFilesManager.h"
#import "HXSPrintModel.h"
#import "HXSPrintSelectTheShop.h"

// Others
#import "HXSShopManager.h"

@interface HXSMyFilesPrintViewController ()<UIDocumentPickerDelegate,
                                            QLPreviewControllerDataSource,
                                            QLPreviewControllerDelegate,
                                            HXSPrintSettingViewControllerDelegate,
                                            HXSMyFilesPopViewDelegate,
                                            HXSMyFilesPrintTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView                                    *mainTableView;
@property (weak, nonatomic) IBOutlet JCRBlurView                                    *bottomCartView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint                             *bottomCartViewBottomConstraints;
/**确认按钮*/
@property (weak, nonatomic) IBOutlet UIButton                                       *confirmButton;
/**共计加入购物车的个数*/
@property (weak, nonatomic) IBOutlet UILabel                                        *totalItemNumsLabel;
/**当前店铺entity*/
@property (nonatomic, strong) HXSShopEntity                                         *shopEntity;
@property (nonatomic, strong) UIBarButtonItem                                       *postBarButton;
/**左上角后退按钮*/
@property (nonatomic, strong) UIBarButtonItem                                       *backBarButton;
@property (nonatomic, strong) HXSPrintFilesManager                                  *printFilesManager;
/**当前从icloud drive读取的文件集合*/
@property (nonatomic, strong) NSMutableArray<HXSPrintDownloadsObjectEntity *>       *documentEntityArray;
@property (nonatomic, strong) HXSPrintModel                                         *printModel;
@property (nonatomic, strong) NSMutableArray                                        *uploadTaskArray;
/**是否从其他APP打开该界面用以传文件*/
@property (nonatomic, assign) BOOL                                                  isFromOtherApp;
/**原始rootVC界面是否是自己*/
@property (nonatomic, assign) BOOL                                                  originVCIsSelf;
/**从其他APP打开文件的URL*/
@property (nonatomic, strong) NSURL                                                 *fileURLFromOtherApp;
/**购物车集合*/
@property (nonatomic, strong) NSMutableArray                                        *cartArray;
@property (nonatomic, strong) HXSPrintSelectTheShop                                 *printSelectTheShop;
@property (nonatomic, strong) HXSActionSheet                                        *actionSheet;
/**待删除文件*/
@property (nonatomic, strong) HXSPrintDownloadsObjectEntity                         *needToBeRemovedEntity;

@end

@implementation HXSMyFilesPrintViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTheNavigationBar];
    
    [self initTheMainTableView];
    
    [self initTheDocumentEntities];
    
    [self addFileToLocalDocumentFromOtherApp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableArray<HXSPrintDownloadsObjectEntity *> *array = [self.printFilesManager loadTheDownloadFilesToUnArchiveAndReturnArray];
    if(_documentEntityArray
       && array.count > _documentEntityArray.count) {
        _documentEntityArray = array;
    }
     
    [_mainTableView reloadData];
    
    [self checkTheDocumentEntitiesArrayAndSetConstraints];
}

#pragma mark - init

+ (instancetype)createFilesPrintVCWithEntity:(HXSShopEntity *)shopEntity
{
    HXSMyFilesPrintViewController *filesPrintVC = [HXSMyFilesPrintViewController controllerFromXib];
    
    if(nil != shopEntity) {
        filesPrintVC.shopEntity = shopEntity;
    }
    
    return filesPrintVC;
}

+ (instancetype)createFilesPrintVCWithURL:(NSURL *)url
{
    HXSMyFilesPrintViewController *filesPrintVC = [HXSMyFilesPrintViewController controllerFromXib];
    
    filesPrintVC.isFromOtherApp = YES;
    
    filesPrintVC.fileURLFromOtherApp = url;
    
    return filesPrintVC;
}

- (void)refreshThePrintVCWithURL:(NSURL *)url
{
    _isFromOtherApp = YES;
    
    _originVCIsSelf = YES;
    
    _fileURLFromOtherApp = url;
    
    [self addFileToLocalDocumentFromOtherApp];
}

- (void)initTheNavigationBar
{
    self.navigationItem.title = @"我的文件";
    
    [self.navigationItem setRightBarButtonItem:self.postBarButton];
    
    [self.navigationItem setLeftBarButtonItem:self.backBarButton];
}

- (void)initTheMainTableView
{
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSMyFilesPrintTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSMyFilesPrintTableViewCell class])];
}

/**
 *  初始化读取本地归档
 */
- (void)initTheDocumentEntities
{
    _documentEntityArray = [self.printFilesManager loadTheDownloadFilesToUnArchiveAndReturnArray];
    
    [_mainTableView reloadData];
    
    [self checkTheDocumentEntitiesArrayAndSetConstraints];
}


#pragma mark - QLPreviewControllerDataSource ,QLPreviewControllerDelegate

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    NSInteger numToPreview = 1;//QLView只读取一张即一个文件的预览
    
    return numToPreview;
}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    CustomQLPreviewControllerViewController *customQLPreviewVC = (CustomQLPreviewControllerViewController *)previewController;
    NSString *urlStr;
    HXSPrintDownloadsObjectEntity *entity = customQLPreviewVC.currentEntity;
    if(entity.archiveDocLocalURLStr) {
        urlStr = entity.archiveDocLocalURLStr;
    } else if(entity.archiveDocPathStr) {
        NSData *docServerData = [NSData dataWithContentsOfURL:[[NSURL alloc]initWithString:entity.archiveDocPathStr]];
        NSString *fileName = [[entity.archiveDocPathStr  lastPathComponent]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];//去空格,变成下划线
        NSString *originName = [entity.archiveDocNameStr stringByDeletingPathExtension];
        NSString *newFileName = [NSString stringWithFormat:@"%@.%@",originName,[fileName pathExtension]];
        NSString *localURL = [self.printFilesManager saveTheDataToLocalWithData:docServerData
                                                                andWithFileName:newFileName
                                                                  andWithEntity:entity];
        if(localURL) {
            localURL = [localURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            entity.archiveDocLocalURLStr = localURL;
            urlStr = entity.archiveDocLocalURLStr;
            [self.printFilesManager saveTheDownloadFileToArchiveWithArray:_documentEntityArray];
        }
    }
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    return fileURL;
}


#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller
  didPickDocumentAtURL:(NSURL *)url
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:HXS_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    BOOL  isAccess = [url startAccessingSecurityScopedResource];
    if(!isAccess)
        return;

    HXSPrintDownloadsObjectEntity *entity = [self.printFilesManager checkTheDataFileTypeAndSetTheEntityWithURL:url
                                                                                             andIsFromOtherApp:_isFromOtherApp
                                                                                                       andView:self.view
                                                                                                  andWithArray:_documentEntityArray];

    if(!_documentEntityArray)
        _documentEntityArray = [[NSMutableArray alloc]init];
    
    if(entity) {
        entity.uploadType = kHXSDocumentDownloadTypeUploading;
        [_documentEntityArray insertObject:entity atIndex:0];
        //[_documentEntityArray addObject:entity];
        [self uploadTheDocumentToServerWithEntity:entity];
        [self.printFilesManager saveTheDownloadFileToArchiveWithArray:_documentEntityArray];
        if(_documentEntityArray.count == 1) {
            [_mainTableView reloadData];
        } else {
            [_mainTableView beginUpdates];
            NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [indexPathArray addObject:indexPath];
            [_mainTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationBottom];
            [_mainTableView endUpdates];
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    if(_documentEntityArray && [_documentEntityArray count] > 0) {
        rows = [_documentEntityArray count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSMyFilesPrintTableViewCell class]) forIndexPath:indexPath];
    
    if(!_documentEntityArray || [_documentEntityArray count] == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxx"];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_documentEntityArray && [_documentEntityArray count] > 0)
    {
        return 90.0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_documentEntityArray && [_documentEntityArray count] > 0)
    {
        return 0.1;
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"img_yunyin_no"];
        return image.size.height;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_yunyin_no"]];
    
    return imageView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_documentEntityArray && [_documentEntityArray count] > 0)
    {
        HXSMyFilesPrintTableViewCell *printTableViewCell = (HXSMyFilesPrintTableViewCell *)cell;
    
        [printTableViewCell initMyFilesPrintTableViewCellWithEntity:[_documentEntityArray objectAtIndex:indexPath.row]];
        
        printTableViewCell.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSPrintDownloadsObjectEntity *entity = [_documentEntityArray objectAtIndex:indexPath.row];
    
    [self previewTheDocumentWithEntity:entity];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.actionSheet show];
        _needToBeRemovedEntity = [_documentEntityArray objectAtIndex:indexPath.row];
    }
}


#pragma mark - HXSMyFilesPrintTableViewCellDelegate

- (void)addToCartOrRemovedWithEntity:(HXSPrintDownloadsObjectEntity *)entity
                  andWithContentView:(UIView *)view
{
    if([entity.uploadAndCartDocEntity isAddToCart]) {
        if(!_cartArray) {
            _cartArray = [[NSMutableArray alloc] init];
        }
        entity.uploadAndCartDocEntity.archiveDocTypeNum = entity.archiveDocTypeNum;
        [_cartArray addObject:entity.uploadAndCartDocEntity];
        [self addToCartAnimationWithEntity:entity andWithCellView:view];
    } else {
        if(_cartArray) {
            [_cartArray removeObject:entity.uploadAndCartDocEntity];
        }
        
        [self reloadTheCellWithEntity:entity];
    
        [self checkTheDocumentEntitiesArrayAndSetConstraints];
    }
}

- (void)reUploadTheDocumentWithEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    entity.uploadType = kHXSDocumentDownloadTypeUploading;
    
    [self reloadTheCellWithEntity:entity];
    
    [self uploadTheDocumentToServerWithEntity:entity];
}


#pragma mark - HXSMyFilesPopViewControllerDelegate

- (void)buttonClick:(HXSMyFilesPopViewController *)popViewController
       andWithIndex:(NSInteger)tag
{
    if(tag == 0) { //icloud
        [self jumpToICloudDrive];
    } else {
        NSString *url = [[ApplicationSettings instance] currentPrintURL];
        HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
        webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if(!_isFromOtherApp) {
            RootViewController *tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
            UINavigationController *nav = tabRootCtrl.currentNavigationController;
            
            [nav pushViewController:webVc animated:YES];
        } else {
            [self.navigationController pushViewController:webVc animated:YES];
        }
    }
}


#pragma mark - networking

/**
 *  上传文件到服务器
 *
 *  @param entity
 */
- (void)uploadTheDocumentToServerWithEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    __weak __typeof(self)weakSelf = self;
    __block NSURLSessionDataTask *task = [self.printModel uploadTheDocument:entity
                                                                   complete:^(HXSErrorCode code, NSString *message, HXSMyPrintOrderItem *orderItem){
                                                                       if(!orderItem)
                                                                       {
                                                                           entity.uploadType = kHXSDocumentDownloadTypeUploadFail;
                                                                           if (weakSelf.view && code != kHXSNetworkingCancelError)
                                                                           {
                                                                               [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                                           }
                                                                       }
                                                                       else
                                                                       {
                                                                           entity.uploadAndCartDocEntity = orderItem;
                                                                           entity.uploadType = kHXSDocumentDownloadTypeUploadSucc;
                                                                           entity.upLoadDate = [NSDate date];
                                                                           [weakSelf.printFilesManager removeTheLocalDocFileWithURL:entity.archiveDocLocalURLStr];
                                                                           
                                                                           entity.archiveDocPathStr = orderItem.pdfPathStr;
                                                                           entity.archiveDocLocalURLStr = nil;
                                                                           entity.fileData = nil;//上传成功后,删除文件的Data
                                                                       }
                                                                       [weakSelf.uploadTaskArray removeObject:task];
                                                                       //[weakSelf.mainTableView reloadData];
                                                                       [weakSelf uploadDocumentFinishedAndRefreshCellWithEntity:entity];
                                                                       [weakSelf checkTheDocumentEntitiesArrayAndSetConstraints];
                                                                       [weakSelf.printFilesManager saveTheDownloadFileToArchiveWithArray:weakSelf.documentEntityArray];
                                                                   }];
    entity.task = task;
    if(!_uploadTaskArray)
        _uploadTaskArray = [[NSMutableArray alloc]init];
    [_uploadTaskArray addObject:task];
}


#pragma mark - UIBarButtonItem Action

/**
 *  弹出选项:使用iCloud上传,帮助引导
 */
- (void)postBarButtonAction:(UIBarButtonItem *)postBarButton
{
    NSArray<NSString *> *btnNamesArray = [NSArray arrayWithObjects:@"使用iCloud上传",@"帮助引导", nil];
    UIView *view = [postBarButton valueForKey:@"view"];
    
    HXSMyFilesPopView *popView = [HXSMyFilesPopView initTheMyFilesPopViewWithBtnNameArray:btnNamesArray
                                                                               targetView:view
                                                                              andDelegate:self
                                                                         popViewDirection:HXSMyFilesPopViewDirectionDown
                                                                          popViewRotation:HXSMyFilesPopViewRotationLeft];
    
    [popView showThePopView];
}

/**
 *  跳转到iCloud界面
 */
- (void)jumpToICloudDrive
{
    [self checkTheICloudIsAvailable];
}

#pragma mark - iCloud

/**
 *  检测iCloud是否可用
 */
- (void)checkTheICloudIsAvailable
{
    [MBProgressHUD showInView:self.view];
    /**
     *  "Important: Do not call this method from your app’s main thread.
     *  Because this method might take a nontrivial amount of time to set up iCloud and return the requested URL, you should always call it from a secondary thread.
     *To determine if iCloud is available, especially at launch time, call the ubiquityIdentityToken method instead.
     *iCloud的检测很推荐放到一个线程中单独执行
     */
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *iCloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
        if(iCloudURL && [[UIDevice currentDevice].systemVersion floatValue] > 8.0f)
        {
            NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
            [iCloudStore setString:@"Success" forKey:@"iCloudStatus"];
            [iCloudStore synchronize];
            DLog(@"iCloud status : %@", [iCloudStore stringForKey:@"iCloudStatus"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [weakSelf presentDocumentPicker];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc]initWithTitle:@"提示"
                                                                                 message:@"请开启iCloudDrive并且保证iOS版本大于8.0~"
                                                                         leftButtonTitle:@"确定"
                                                                       rightButtonTitles:nil];
                [alertView show];
            });
        }
    });
}

#pragma mark - JumpAction method

/**
 *  跳转到iCloud Drive界面
 */
- (void)presentDocumentPicker
{
    NSArray *documentTypes = @[@"public.jpeg",
                               @"public.png",
                               @"com.adobe.pdf",
                               @"com.microsoft.word.doc",
                               @"com.microsoft.powerpoint.ppt",
                               @"org.openxmlformats.presentationml.presentation",
                               @"org.openxmlformats.wordprocessingml.document"];//可读取的文件格式,不符合的则是灰色
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

/**
 *  跳转到购物车界面
 */
- (IBAction)jumpToCartViewController:(id)sender
{
    HXSPrintCartViewController *cartVC = [HXSPrintCartViewController controllerFromXib];
    
    if(nil == self.shopEntity) {
        __weak __typeof(self)weakSelf = self;
        [self.printSelectTheShop selectTheShopEntityAndWithVC:self andPrintBlock:^(HXSShopEntity *entity) {
            weakSelf.shopEntity = entity;
            [cartVC initPrintCartViewWithShopEntity:self.shopEntity andWithCartArray:_cartArray];
            [weakSelf.navigationController pushViewController:cartVC animated:YES];
        }];
    } else {
        [cartVC initPrintCartViewWithShopEntity:self.shopEntity andWithCartArray:_cartArray];
        [self.navigationController pushViewController:cartVC animated:YES];
    }
}

#pragma mark - PreviewAndDeleteAction

/**
 *  弹出框的删除操作
 */
- (void)deleteSheetAction
{
    [self deleteTheDocumentWithEntity:_needToBeRemovedEntity];
}

/**
 *  删除操作
 *
 *  @param entity
 */
- (void)deleteTheDocumentWithEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    NSInteger index = [_documentEntityArray indexOfObject:entity];
    
    [self.printFilesManager removeTheDownloadDocument:entity
                                      inTheTotalArray:_documentEntityArray
                                         andCartArray:_cartArray];
    
    if(_documentEntityArray.count == 0) {
        [_mainTableView reloadData];
    } else {
        [_mainTableView beginUpdates];
        NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPathArray addObject:indexPath];
        [_mainTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        [_mainTableView endUpdates];
    }
    [self checkTheDocumentEntitiesArrayAndSetConstraints];
}

/**
 *  预览操作
 *
 *  @param entity
 */
- (void)previewTheDocumentWithEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    CustomQLPreviewControllerViewController *qlPreviewVC = [[CustomQLPreviewControllerViewController alloc]init];
    [qlPreviewVC initCustomQLPreviewWithEntity:entity];
    qlPreviewVC.dataSource = self;
    qlPreviewVC.delegate   = self;
    [self.navigationController pushViewController:qlPreviewVC animated:YES];
}

#pragma mark - Animation

/**
 *  上传文档成功并且动画刷新cell
 */
- (void)uploadDocumentFinishedAndRefreshCellWithEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    [self reloadTheCellWithEntity:entity];
}

/**
 *  加入购物车动画
 */
- (void)addToCartAnimationWithEntity:(HXSPrintDownloadsObjectEntity *)entity
                     andWithCellView:(UIView *)cellView
{
    CGRect rectNow = [self getFrameInWindow:cellView];
    UIView *newView = [cellView snapshotViewAfterScreenUpdates:YES];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:newView];
    [newView setFrame:rectNow];
    
    [self startAddToCartAnimationWithView:newView
                                andEntity:entity];
}

/**
 *  Group Animation
 *
 *  @param view
 *  @param entity
 */
- (void)startAddToCartAnimationWithView:(UIView *)view
                              andEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    //半透明动画
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.1]];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    fadeOutAnimation.duration = 0.5;
    fadeOutAnimation.beginTime = 0;
    
    //缩放动画
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    resizeAnimation.fromValue = @(1);
    [resizeAnimation setToValue:@(0.66)];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;
    resizeAnimation.beginTime = 0;
    resizeAnimation.duration = 0.2;
    
    //初始移动
    CABasicAnimation *moveAnimationFirst = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimationFirst.fromValue = [NSValue valueWithCGPoint:view.layer.position];
    CGPoint toPoint = view.layer.position;
    toPoint.x += 18;
    toPoint.y += 11;
    [moveAnimationFirst setToValue:[NSValue valueWithCGPoint:toPoint]];
    moveAnimationFirst.fillMode = kCAFillModeForwards;
    moveAnimationFirst.removedOnCompletion = NO;
    moveAnimationFirst.beginTime = 0;
    moveAnimationFirst.duration = 0.3;
    
    
    //路径移动
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint startPoint  = view.layer.position;
    
    CGPoint firstPoint  = CGPointMake(startPoint.x + 0, startPoint.y + 0);
    CGPoint secondPoint = CGPointMake(firstPoint.x + 0, firstPoint.y + 0);
    CGPoint finishPoint = CGPointMake(secondPoint.x, self.view.frame.size.height);
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath,NULL,firstPoint.x,firstPoint.y);
    
    CGPathAddCurveToPoint(thePath,NULL,firstPoint.x,firstPoint.y,
                          secondPoint.x,secondPoint.y,
                          finishPoint.x,finishPoint.y);
    moveAnimation.path = thePath;
    moveAnimation.duration = 0.3;
    moveAnimation.beginTime = 0.2;
    moveAnimation.delegate = self;
    [moveAnimation setRemovedOnCompletion:YES];
    [CATransaction setCompletionBlock:^{
        [view removeFromSuperview];
        [self reloadTheCellWithEntity:entity];
        [self checkTheDocumentEntitiesArrayAndSetConstraints];
    }];
    
    //缩放动画2
    CABasicAnimation *resizeAnimationSecond = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    resizeAnimationSecond.fromValue = @(0.66);
    [resizeAnimationSecond setToValue:@(0.6)];
    resizeAnimationSecond.fillMode = kCAFillModeForwards;
    resizeAnimationSecond.removedOnCompletion = NO;
    resizeAnimationSecond.beginTime = 0.2;
    resizeAnimationSecond.duration = 0.3;
    
    //总动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation,resizeAnimation,moveAnimation,resizeAnimationSecond, nil]];
    group.duration = 0.5f;
    group.delegate = self;
    [group setValue:view forKey:@"imageViewBeingAnimated"];
    
    [view.layer addAnimation:group forKey:@"savingAnimation"];
    
    CGPathRelease(thePath);
}

- (CGRect)getFrameInWindow:(UIView *)view
{
    // 改用[UIApplication sharedApplication].keyWindow.rootViewController.view，防止present新viewController坐标转换不准问题
    return [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

#pragma mark - private method

/**
 *  检查并计算所有打印页面的总数和价格,返回一个购物车对象
 */
- (HXSPrintCartEntity *)checkTheCartAndReturnTheEntity
{
    if(!_cartArray) {
        return nil;
    }
    HXSPrintCartEntity *printCartEntity = [[HXSPrintCartEntity alloc]init];
    NSInteger totalPage = 0;
    double totalPrice = 0.00;
    for (HXSMyPrintOrderItem *orderItem in _cartArray) {
        NSInteger pageIntNum  = [orderItem.pageIntNum integerValue];
        NSInteger quantityNum = [orderItem.quantityIntNum integerValue];
        NSInteger temptotalPageNums = pageIntNum * quantityNum;
        double tempPrice = [orderItem.amountDoubleNum doubleValue];
        totalPage  += temptotalPageNums;
        totalPrice += tempPrice;
    }
    printCartEntity.itemsArray = (NSMutableArray<HXSMyPrintOrderItem> *)self.cartArray;
    NSNumber *totalPriceNumber = [[NSNumber alloc]initWithDouble:totalPrice];
    printCartEntity.totalAmountDoubleNum    = totalPriceNumber;//购物车中的打印总价
    printCartEntity.deliveryAmountDoubleNum = totalPriceNumber;
    printCartEntity.documentAmountDoubleNum = totalPriceNumber;
    printCartEntity.shopIdIntNum = [self.shopEntity shopIDIntNum];
    
    return printCartEntity;
}

/**
 *  检测文件集合设置底部栏位置
 */
- (void)checkTheDocumentEntitiesArrayAndSetConstraints
{
    if(!_documentEntityArray || _documentEntityArray.count == 0) {
        _bottomCartViewBottomConstraints.constant = -50;
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _bottomCartViewBottomConstraints.constant = 0;
        }];
    }
    
    NSInteger filesNums = 0;
    
    if(_cartArray) {
        filesNums = _cartArray.count;
    }
    
    [_totalItemNumsLabel setText:[NSString stringWithFormat:@"已选%zd个文件",filesNums]];
    
    if(filesNums == 0) {
        [_confirmButton setEnabled:NO];
    } else {
        [_confirmButton setEnabled:YES];
    }
}

/**
 *  重新刷新某条cell
 *
 *  @param entity
 */
- (void)reloadTheCellWithEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    NSInteger index = [_documentEntityArray indexOfObject:entity];
    NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [indexPathArray addObject:indexPath];
    
    [_mainTableView beginUpdates];
    [_mainTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    [_mainTableView endUpdates];
}

#pragma mark - AddFileToLocal

/**
 *  从其他APP读取文件并拷贝到本地
 */
- (void)addFileToLocalDocumentFromOtherApp
{
    if(!_fileURLFromOtherApp) {
        return;
    }
    
    HXSPrintDownloadsObjectEntity *entity = [self.printFilesManager checkTheDataFileTypeAndSetTheEntityWithURL:_fileURLFromOtherApp
                                                                                             andIsFromOtherApp:_isFromOtherApp
                                                                                                       andView:self.view
                                                                                                  andWithArray:_documentEntityArray];
    if(!_documentEntityArray) {
        _documentEntityArray = [[NSMutableArray alloc]init];
    }
    
    if(entity) {
        entity.uploadType = kHXSDocumentDownloadTypeUploading;
        [_documentEntityArray addObject:entity];
        [self uploadTheDocumentToServerWithEntity:entity];
        [self.printFilesManager saveTheDownloadFileToArchiveWithArray:_documentEntityArray];
        [_mainTableView reloadData];
    }
}

#pragma mark - Override Navigtaion Left Item Methods

- (void)backBarButtonAction
{
    BOOL isDownloading = NO;
    for (HXSPrintDownloadsObjectEntity *entity in _documentEntityArray) {
        if(entity.uploadType == kHXSDocumentDownloadTypeUploading) {
            isDownloading = YES;
            break;
        }
    }
    if(isDownloading) {
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc]initWithTitle:@"提示" message:@"有文件正在上传,确定要后退吗?" leftButtonTitle:@"取消" rightButtonTitles:@"确定"];
        __weak typeof(self) weakSelf = self;
        alertView.rightBtnBlock = ^{
            for (HXSPrintDownloadsObjectEntity *entity in weakSelf.documentEntityArray) {
                if(entity.uploadType == kHXSDocumentDownloadTypeUploading) {
                    if(entity.task)
                        [entity.task cancel];
                    entity.uploadType = kHXSDocumentDownloadTypeUploadFail;
                }
            }
            
            [self turnBack];
            
        };
        [alertView show];
    } else {
        [self turnBack];
    }
}

#pragma mark - getter setter

- (UIBarButtonItem *)postBarButton
{
    if(!_postBarButton) {
        _postBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_gengduo"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(postBarButtonAction:)];
    }
    return _postBarButton;
}

- (HXSPrintFilesManager *)printFilesManager
{
    if(!_printFilesManager) {
        _printFilesManager = [[HXSPrintFilesManager alloc]init];
    }
    return _printFilesManager;
}

- (HXSPrintModel *)printModel
{
    if(!_printModel) {
        _printModel = [[HXSPrintModel alloc]init];
    }
    return _printModel;
}

- (HXSPrintSelectTheShop *)printSelectTheShop
{
    if(!_printSelectTheShop) {
        _printSelectTheShop = [[HXSPrintSelectTheShop alloc]init];
    }
    return _printSelectTheShop;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet) {
        HXSActionSheetEntity *deleteEntity = [[HXSActionSheetEntity alloc] init];
        deleteEntity.nameStr = @"删除";
        __weak typeof(self) weakSelf = self;
        HXSAction *deleteAction = [HXSAction actionWithMethods:deleteEntity
                                                       handler:^(HXSAction *action){
                                                           [weakSelf deleteSheetAction];
                                                           
                                                       }];
        
        _actionSheet = [HXSActionSheet actionSheetWithMessage:@"确定将该文件从我的文件中删除?"
                                            cancelButtonTitle:@"取消"];
        [_actionSheet addAction:deleteAction];
    }
    return _actionSheet;
}

- (UIBarButtonItem *)backBarButton
{
    if(!_backBarButton) {
        UIImage *backImage;
        
        if(_isFromOtherApp) {
            backImage = [UIImage imageNamed:@"icon_back_down"];
        } else {
            backImage = [UIImage imageNamed:@"btn_back_normal"];
        }
        _backBarButton =[[UIBarButtonItem alloc] initWithImage:backImage
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backBarButtonAction)];
        
    }
    return _backBarButton;
}

- (HXSShopEntity *)shopEntity
{
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    _shopEntity = shopManager.currentEntry.shopEntity;
    
    return _shopEntity;
}

@end
