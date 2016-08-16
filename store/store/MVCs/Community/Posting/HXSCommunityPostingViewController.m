//
//  HXSCommunityPostingViewController.m
//  store
//
//  Created by J.006 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSCommunityPostingViewController.h"
#import "HXSCommunityPhotosBrowserViewController.h"
#import "HXSCommunityDetailViewController.h"

// Views
#import "HXSCommunityPostingViewCell.h"
#import "HXSCommunityPostingPhotoCell.h"
#import "HXSTopicSelectView.h"
#import "HXSActionSheet.h"
#import "HXSLoadTopicItemFailedView.h"
#import "UINavigationBar+AlphaTransition.h"
#import "HXSCustomPickerView.h"
#import "TZImagePickerController.h"
#import "HXSCustomAlertView.h"

// Model
#import "HXSCommunityPostingParamEntity.h"
#import "HXSCommunityPostingModel.h"
#import "HXSCommunitUploadImageEntity.h"

// Other
#import <AssetsLibrary/AssetsLibrary.h>
#import "HXSLocationManager.h"
#import "HXSCommunitTopicEntity.h"

static NSString *const textViewPlaceholdStr = @"请输入正文";
static CGFloat   const maxImageSizeM       = 300;// 最大上传限制为300K
static NSInteger const maxUploadPhotoNums  = 9;// 最大上传图片数量
static NSInteger const MAX_INPUT_NUMS      = 500;// 最大输入字数
static CGFloat const tableHeaderViewHeight = 150.0f;//表头高度
static CGFloat const marginWidth           = 15.0f;
static CGFloat const titleCellheight       = 48.0f;


typedef NS_ENUM(NSInteger, kPostingSection)
{
    kPostingSection_Content = 0,
    kPostingSection_Topic = 1,
    kPostingSection_Count = 2
};




#define collectionCellDefaultHeight (SCREEN_WIDTH-2*paddingCollection-4*linePaddingCollection)/5
#define collectionDefaulttHeight    ((SCREEN_WIDTH-2*paddingCollection-4*linePaddingCollection)/5)*2+linePaddingCollection

@interface HXSCommunityPostingViewController ()<
                                                UIImagePickerControllerDelegate,
                                                UINavigationControllerDelegate,
                                                UIScrollViewDelegate,
                                                UITextViewDelegate,
                                                TZImagePickerControllerDelegate
                                                >

@property (strong, nonatomic) UITextView  *inputTextView;// 输入文字
@property (weak, nonatomic  ) IBOutlet UITableView *tableView;// 话题与学校

@property (nonatomic ,readwrite) dispatch_group_t               dispatchGroup;
@property (nonatomic ,strong   ) NSMutableArray<HXSCommunitUploadImageEntity       *> *photoTotalArray;// 图片地址对象数组
@property (nonatomic ,strong   ) UIBarButtonItem                *postBarButton;// 右上角提交按钮
@property (nonatomic ,strong   ) UIBarButtonItem                *leftBackBarButton;// 左上角回退按钮
@property (nonatomic ,strong   ) HXSCommunityPostingParamEntity *paramEntity;
@property (nonatomic ,strong   ) HXSCommunityPostingModel       *postModel;
@property (nonatomic ,strong   ) NSMutableArray                 *topicsListArray;
@property (nonatomic ,strong   ) HXSCustomPickerView            *pickerView;
@property (nonatomic ,strong   ) TZImagePickerController        *pickerController;
@property (nonatomic ,strong   ) HXSTopicSelectView             *topicSelectView;
@property (nonatomic ,strong   ) HXSLoadTopicItemFailedView     *loadTopicItemFailedView;
@property (nonatomic ,strong   ) HXSCommunityPostingPhotoCell   *communityPostingPhotoCell;


@end

@implementation HXSCommunityPostingViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initialNavigation];
    
    [self initTheTableView];
    
    [self initInputNotify];
    
    [self addObserverForParamEntity];
}

- (void)addObserverForParamEntity
{
    self.postBarButton.enabled = NO;
    
    [self.paramEntity addObserver:self forKeyPath:@"contentStr" options:NSKeyValueObservingOptionNew context:nil];
    [self.paramEntity addObserver:self forKeyPath:@"topicIDStr" options:NSKeyValueObservingOptionNew context:nil];
    [self.paramEntity addObserver:self forKeyPath:@"schoolIDStr" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchTheTopicsListNetworking];
    
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:_inputTextView];
    
    [self.paramEntity removeObserver:self forKeyPath:@"contentStr"];
    [self.paramEntity removeObserver:self forKeyPath:@"topicIDStr"];
    [self.paramEntity removeObserver:self forKeyPath:@"schoolIDStr"];
}

#pragma mark init

- (void)initialNavigation
{
    [self.navigationItem setTitle:@"发表帖子"];
    [self.navigationItem setRightBarButtonItem:self.postBarButton];
    [self.navigationItem setLeftBarButtonItem:self.leftBackBarButton];
}


- (void)initTheTableView
{
    UIView *inputTextBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableHeaderViewHeight)];
    [inputTextBgView addSubview:self.inputTextView];
    
    [self.tableView setTableHeaderView:inputTextBgView];

    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCommunityPostingViewCell class])
                                           bundle:nil]
     forCellReuseIdentifier:NSStringFromClass([HXSCommunityPostingViewCell class])];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCommunityPostingPhotoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSCommunityPostingPhotoCell class])];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([object class] == [HXSCommunityPostingParamEntity class])
    {
        HXSCommunityPostingParamEntity *entity = (HXSCommunityPostingParamEntity *)object;
        if (entity.contentStr.length != 0 &&
            entity.schoolIDStr.length !=0 &&
            entity.topicIDStr.length !=0)
        {
            self.postBarButton.enabled = YES;
        }
        else
        {
            self.postBarButton.enabled = NO;
        }
    }
}

/**
 *  增加对键盘输入的监听
 */
- (void)initInputNotify
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:_inputTextView];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPostingSection_Content)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  kPostingSection_Count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    WS(weakSelf);
    if (section == 0)
    {
        if (row == 0)
        {
            self.communityPostingPhotoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCommunityPostingPhotoCell class])
                                                                             forIndexPath:indexPath];
            
            [self.communityPostingPhotoCell setImages:self.photoTotalArray];
            
            [self.communityPostingPhotoCell setImageViewTapBlock:^(UIImageView *imageView)
            {
               [weakSelf chooisePhotoes:imageView];
            }];
    
            return self.communityPostingPhotoCell;
        }
        else
        {
            HXSCommunityPostingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCommunityPostingViewCell class])
                                                                                forIndexPath:indexPath];
            NSString *schoolName;
            if(self.paramEntity.schoolIDStr)
            {
                schoolName = self.paramEntity.schoolNameStr;
            }
            else
            {
                schoolName = [[HXSLocationManager manager]currentSite].name;
                self.paramEntity.schoolNameStr = schoolName;
                self.paramEntity.schoolIDStr   = [[[HXSLocationManager manager]currentSite].site_id stringValue];
            }
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 1)];
            line.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
            [cell initHXSCommunityPostingViewCellWithType:kHXSCommunityPostTopicOrSchoolTypeSchool andWithTitle:schoolName];
            [cell addSubview:line];
            return cell;
        }
    }
    else
    {
        HXSCommunityPostingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCommunityPostingViewCell class])
                                                                            forIndexPath:indexPath];
        NSString *topicName;
        if(self.paramEntity.topicTitileStr)
        {
            topicName = self.paramEntity.topicTitileStr;
        }
        [cell initHXSCommunityPostingViewCellWithType:kHXSCommunityPostTopicOrSchoolTypeTopic andWithTitle:topicName];

        return cell;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kPostingSection_Content)
    {
        if (row == 0)
        {
            HXSCommunityPostingPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCommunityPostingPhotoCell class])];
            
            //根据图片的数量计算cell的高度
            [cell setImages:self.photoTotalArray];
            
            return cell.cellHeight;
        }
        else
        {
            return titleCellheight;
        }
    }
    else
    {
        return titleCellheight;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == kPostingSection_Content)
    {
        return 0.01;
    }
    else
    {
        return 10.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(indexPath.section == kPostingSection_Content)
    {
        WS(weakSelf);
        if (indexPath.row == 1)
        {
            [[HXSLocationManager manager]resetPosition:PositionSite completion:^{
                weakSelf.paramEntity.schoolIDStr = [[[HXSLocationManager manager] currentSite].site_id stringValue];
                weakSelf.paramEntity.schoolNameStr = [[HXSLocationManager manager] currentSite].name;
                [weakSelf.tableView reloadData];
            }];
        }
        
    }
}




#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *editedImage = nil;
        if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
            editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        } else {
            editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }

        [weakSelf uploadImageNetworkingWithImage:editedImage andWithDipatchGroup:self.dispatchGroup];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            [weakSelf.tableView reloadData];
        });
        
        dispatch_group_notify(self.dispatchGroup, dispatch_get_main_queue(), ^{
            
            if (self.paramEntity.contentStr&&
                self.paramEntity.topicIDStr&&
                self.paramEntity.schoolIDStr) {
                self.postBarButton.enabled = YES;
            }
        });
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
{
    if(!photos || [photos count] == 0)
    {
        return;
    }
    for (UIImage *editedImage in photos)
    {
        [self uploadImageNetworkingWithImage:editedImage andWithDipatchGroup:self.dispatchGroup];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        [weakSelf.tableView reloadData];
    });

    dispatch_group_notify(self.dispatchGroup, dispatch_get_main_queue(), ^{
        
        if (self.paramEntity.contentStr&&
            self.paramEntity.topicIDStr&&
            self.paramEntity.schoolIDStr) {
            self.postBarButton.enabled = YES;
        }
    });
}

#pragma mark HXSCommunityPostingPhotoCellDelegate

- (void)takePhotoFromCamera
{
    [self jumpToTakePhotoViewOrAlbumView:YES];
}

- (void)takePhotoFromAlbum
{
    [self jumpToTakePhotoViewOrAlbumView:NO];
}

- (void)jumpToPhotoDetailWithIndex:(NSInteger)index
{
    HXSCommunityPhotosBrowserViewController *photoBrowserVC = [HXSCommunityPhotosBrowserViewController controllerFromXibWithModuleName:@"PhotosBrowse"];
    [photoBrowserVC initCommunityPhotosBrowserWithImageParamArray:_photoTotalArray
                                                         andIndex:index
                                                          andType:kCommunitPhotoBrowserTypePostUploadImage];
    [self.navigationController pushViewController:photoBrowserVC animated:YES];
}

// 选择照片
- (void)chooisePhotoes:(UIImageView *)imageView
{
    NSInteger tag = imageView.tag;
    
    if (self.communityPostingPhotoCell.images.count < maxUploadPhotoNums)
    {
        if (tag == self.communityPostingPhotoCell.images.count - 1 ||
            self.communityPostingPhotoCell.images.count == 0 )
        {
            [self showActionSheet];
        }
        else
        {
            [self jumpToPhotoDetailWithIndex:tag];
        }
    }
    else
    {
        [self jumpToPhotoDetailWithIndex:tag];
    }

}

- (void)showActionSheet
{
    HXSActionSheetEntity *cameraEntity = [[HXSActionSheetEntity alloc] init];
    cameraEntity.nameStr = @"拍照";
    HXSActionSheetEntity *photoEntity = [[HXSActionSheetEntity alloc] init];
    photoEntity.nameStr = @"从手机相册选择";
    __weak typeof(self) weakSelf = self;
    HXSAction *cameraAction = [HXSAction actionWithMethods:cameraEntity
                                                   handler:^(HXSAction *action){
                                                       [weakSelf takePhotoFromCamera];
                                                       
                                                   }];
    HXSAction *photoAction = [HXSAction actionWithMethods:photoEntity
                                                  handler:^(HXSAction *action){
                                                      [weakSelf takePhotoFromAlbum];
                                                  }];
    
    HXSActionSheet *actionSheet = [HXSActionSheet actionSheetWithMessage:@""
                                                       cancelButtonTitle:@"取消"];
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    
    [actionSheet show];
    
}



/**
 *  跳转到相机或者相册界面
 *
 *  @param isCamera
 */
- (void)jumpToTakePhotoViewOrAlbumView:(BOOL)isCamera
{
    if(isCamera)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSInteger photoNums = 0;
        if(_photoTotalArray)
        {
            photoNums = [_photoTotalArray count];
        }
        _pickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:maxUploadPhotoNums - photoNums delegate:self];
        _pickerController.allowPickingVideo = NO;
        _pickerController.allowPickingOriginalPhoto = NO;
        
        [self presentViewController:_pickerController animated:YES completion:nil];
    }
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = textViewPlaceholdStr;
        textView.textColor = [UIColor lightGrayColor];
    }
    else
    {
        if([textView.text isEqualToString:textViewPlaceholdStr])
        {
            [textView setText:@""];
        }
        textView.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([text isEqualToString:@""])
    {
        textView.text = textViewPlaceholdStr;
        textView.textColor = [UIColor lightGrayColor];
    }
    else
    {
        self.paramEntity.contentStr = text;
    }
}


#pragma mark TextChangge Notify

- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    self.paramEntity.contentStr = textView.text;
    
    [self checkTheTextViewTextIsMoreThanMax];
}

#pragma mark BarButtonAction

/**
 *  提交帖子操作
 */
- (void)postBarButtonAction:(UIBarButtonItem *)postBarButton
{
    [self postTheThreadNetworking];
}

#pragma mark nerworking

/**
 *  提交帖子网络访问
 */
- (void)postTheThreadNetworking
{
    WS(weakSelf);
    
    [_postBarButton setEnabled:NO];
    self.paramEntity.contentStr = _inputTextView.text;
    
    [HXSLoadingView showLoadingInView:self.view.window];
    
    for (HXSCommunitUploadImageEntity *uploadImageEntity in _photoTotalArray)
    {
        [self.postModel appendURLToTheParamArrayWithURL:uploadImageEntity.urlStr andWithParaEntity:self.paramEntity];
    }
    
    [self.postModel postTheThread:self.paramEntity complete:^(HXSErrorCode code, NSString *message, NSString *postIdStr) {
        
        if(code == kHXSNoError && postIdStr)
        {
            NSString *succMessageStr = @"发帖成功!";
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:succMessageStr
                                           afterDelay:0.5
                                 andWithCompleteBlock:^
            {
                [weakSelf clearTheInputPost];
                [weakSelf.postBarButton setEnabled:YES];
                HXSCommunityDetailViewController *detailViewVC = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:postIdStr replyLoad:NO pop:^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }];
                
                [weakSelf.navigationController pushViewController:detailViewVC animated:YES];
                [HXSLoadingView closeInView:weakSelf.view.window];
            }];
        }
        else
        {
            [weakSelf.paramEntity.photoURLArray removeAllObjects];
            [weakSelf.postBarButton setEnabled:YES];
            [weakSelf checkTheInputStringAndShowAlertViewWithMessage:message
                                                        andErrorCode:code];
            [HXSLoadingView closeInView:weakSelf.view.window];
        }
    }];
}


/**
 *  上传图片网络接口
 *
 *  @param image
 */
- (void)uploadImageNetworkingWithImage:(UIImage *)image
                   andWithDipatchGroup:(dispatch_group_t)dispatchGroup
{
    WS(weakSelf);
    if(!image) return;
    if(dispatchGroup) dispatch_group_enter(dispatchGroup);
    self.postBarButton.enabled = NO;
    NSData *imageData = [self checkTheImage:image andScaleToTheSize:maxImageSizeM];
    HXSCommunitUploadImageEntity *uploadImageEntity = [[HXSCommunitUploadImageEntity alloc]init];
    uploadImageEntity.formData     = imageData;
    uploadImageEntity.nameStr      = @"file";
    uploadImageEntity.filenameStr  = @"file.jpg";
    uploadImageEntity.mimeTypeStr  = @"image/jpeg";
    uploadImageEntity.uploadType   = kHXSCommunityUploadPhotoTypeUploading;
    uploadImageEntity.defaultImage = image;
    [self.photoTotalArray addObject:uploadImageEntity];
    [self.postModel uploadThePhoto:uploadImageEntity
                          complete:^(HXSErrorCode code, NSString *message, NSString *urlStr) {
                              
                              if(code == kHXSNoError && urlStr)
                              {
                                  uploadImageEntity.uploadType = kHXSCommunityUploadPhotoTypeUploadSucc;
                                  uploadImageEntity.urlStr = urlStr;
                                  
                                  [weakSelf.paramEntity.photoURLArray addObject:urlStr];
                              }
                              else
                              {
                                  if (weakSelf.view)
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                  uploadImageEntity.uploadType = kHXSCommunityUploadPhotoTypeUploadFail;
                              }
                              if(dispatchGroup)
                                  dispatch_group_leave(dispatchGroup);
                          }];
}

/**
 *  网络获取话题列表
 */
- (void)fetchTheTopicsListNetworking
{
    WS(weakSelf);
    [MBProgressHUD showInView:self.view];
    [self.postModel fetchAllTopicsListComplete:^(HXSErrorCode code, NSString *message, NSMutableArray *topicsListArray)
    {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if(code == kHXSNoError
           && topicsListArray
           && [topicsListArray count] > 0)
        {
            weakSelf.topicsListArray = topicsListArray;
            NSMutableArray *strArray = [[NSMutableArray alloc]init];
            for (HXSCommunitTopicEntity *entity in topicsListArray) {
                [strArray addObject:entity.titleStr];
            }
            
            weakSelf.topicSelectView = [[HXSTopicSelectView alloc]
                                        initWithTags:topicsListArray
                                        key:@"titleStr"
                                        selectedString:weakSelf.paramEntity.topicTitileStr];
            
            [weakSelf.topicSelectView setSelectedTopicBlock:^(id obj) {
                weakSelf.paramEntity.topicIDStr = ((HXSCommunitTopicEntity *)obj).idStr;
                weakSelf.paramEntity.topicTitileStr = ((HXSCommunitTopicEntity *)obj).titleStr;
                
                if (weakSelf.paramEntity.contentStr&&weakSelf.paramEntity.schoolIDStr&&weakSelf.paramEntity.schoolNameStr) {
                    weakSelf.postBarButton.enabled = YES;
                }
            }];
            
            [weakSelf.tableView setTableFooterView:weakSelf.topicSelectView];
            
        } else {
            weakSelf.loadTopicItemFailedView = [[NSBundle mainBundle]
                                                loadNibNamed:NSStringFromClass([HXSLoadTopicItemFailedView class])
                                                owner:nil options:nil].firstObject;
            
            [weakSelf.loadTopicItemFailedView setReLoadTopicItemBlock:^{
                [weakSelf fetchTheTopicsListNetworking];
            }];
            [weakSelf.tableView setTableFooterView:weakSelf.loadTopicItemFailedView];
        
        }
    }];
}
/**
 *  检测右上角提交按钮是否可用
 */
- (void)checkThePostBarButtonIsEnable
{
    BOOL isEnable = NO;
    NSString *inputStr = [_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([inputStr isEqualToString:@""]
       || [inputStr isEqualToString:textViewPlaceholdStr]
       || !self.paramEntity.schoolIDStr
       || !self.paramEntity.topicIDStr)
    {
        self.paramEntity.contentStr = inputStr;
        isEnable = NO;
    }
    else
    {
        isEnable = YES;
    }
    [self.postBarButton setEnabled:isEnable];
}

- (void)checkTheTextViewTextIsMoreThanMax
{
    NSString *inputStr = [_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lang =  [_inputTextView.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_inputTextView markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [_inputTextView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (inputStr.length > MAX_INPUT_NUMS)
            {
                _inputTextView.text = [inputStr substringToIndex:MAX_INPUT_NUMS];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else
        {
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (inputStr.length > MAX_INPUT_NUMS)
        {
            _inputTextView.text = [inputStr substringToIndex:MAX_INPUT_NUMS];
        }
    }
}

/**
 *  根据图片压缩到指定大小
 *
 *  @param image
 *  @param sizeM 指定大小,目前默认为5.0M
 *
 *  @return
 */
- (NSData *)checkTheImage:(UIImage *)image andScaleToTheSize:(CGFloat)sizeM
{
    if(!image || sizeM == 0.0)
        return nil;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    CGFloat scale     = sizeM/(imageData.length/1024.0);
    NSData *newData   = UIImageJPEGRepresentation(image, scale);
    return newData;
}

/**
 *左上角回退按钮事件
 */
- (void)leftBackBarButtonAction:(UIBarButtonItem *)barButtonItem
{
    WS(weakSelf);
    BOOL isNeedToAlertview = NO;
    
    NSString *inputStr = [_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //在点击左上角回退按钮时,如果帖子尚无发布,提醒用户
    if((![inputStr isEqualToString:@""] && ![inputStr isEqualToString:textViewPlaceholdStr])
       || (_photoTotalArray && [_photoTotalArray count] > 0))
    {
        isNeedToAlertview = YES;
    }
    else
    {
        isNeedToAlertview = NO;
    }
    if(isNeedToAlertview)
    {
        HXSCustomAlertView *alerView = [[HXSCustomAlertView alloc]initWithTitle:@"提醒"
                                                                        message:@"您还有内容未提交，确认放弃编辑吗？"
                                                                leftButtonTitle:@"取消"
                                                              rightButtonTitles:@"确定"];
        alerView.rightBtnBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [alerView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  发帖成功后清空输入的东西
 */
- (void)clearTheInputPost
{
    [_inputTextView setText:nil];
    [_photoTotalArray removeAllObjects];
}

/**
 *  检查输入文字是否有敏感词
 */
- (void)checkTheInputStringAndShowAlertViewWithMessage:(NSString *)message
                                          andErrorCode:(HXSErrorCode)code
{
    if(code == kCommunityBanWordError)
    {
        HXSCustomAlertView *alerView = [[HXSCustomAlertView alloc]initWithTitle:@"提醒"
                                                                        message:message
                                                                leftButtonTitle:@"确定"
                                                              rightButtonTitles:nil];
        [alerView show];
    }
    else
    {
        if (self.view)
        {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5];
        }
    }

}

- (void)setPostSiteId:(NSString *)siteId siteName:(NSString *)siteName
{
    self.paramEntity.schoolIDStr = siteId;
    self.paramEntity.schoolNameStr = siteName;
}

- (void)setTopicId:(NSString *)topicId topicName:(NSString *)topicName
{
    self.paramEntity.topicIDStr = topicId;
    self.paramEntity.topicTitileStr = topicName;
}

#pragma mark getter setter


- (UITextView *)inputTextView
{
    if (!_inputTextView)
    {
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(marginWidth, 0, SCREEN_WIDTH - 2 * marginWidth, tableHeaderViewHeight)];
        _inputTextView.delegate = self;
        [_inputTextView setText:textViewPlaceholdStr];
        [_inputTextView setFont:[UIFont systemFontOfSize:14]];
        [_inputTextView setTextColor:[UIColor lightGrayColor]];
    }
    return _inputTextView;
}


- (UIBarButtonItem *)postBarButton
{
    if(!_postBarButton)
    {
        _postBarButton = [[UIBarButtonItem alloc]initWithTitle:@"提交"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(postBarButtonAction:)];
        [_postBarButton setEnabled:NO];
    }
    return _postBarButton;
}

- (UIBarButtonItem *)leftBackBarButton
{
    if(!_leftBackBarButton)
    {
        _leftBackBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_back_normal"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(leftBackBarButtonAction:)];
    }
    return _leftBackBarButton;
}

- (HXSCommunityPostingParamEntity *)paramEntity
{
    if(!_paramEntity)
    {
        _paramEntity = [[HXSCommunityPostingParamEntity alloc]init];
    }
    return _paramEntity;
}

- (HXSCommunityPostingModel *)postModel
{
    if(!_postModel)
    {
        _postModel = [[HXSCommunityPostingModel alloc]init];
    }
    return _postModel;
}

- (NSMutableArray<HXSCommunitUploadImageEntity *> *)photoTotalArray
{
    if(!_photoTotalArray)
    {
        _photoTotalArray = [[NSMutableArray alloc]init];
    }
    return _photoTotalArray;
}

- (HXSCustomPickerView *)pickerView
{
    if(!_pickerView)
    {
        _pickerView = [[HXSCustomPickerView alloc]init];
    }
    return _pickerView;
}

- (dispatch_group_t)dispatchGroup
{
    if(!_dispatchGroup)
    {
        _dispatchGroup = dispatch_group_create();
    }
    return _dispatchGroup;
}
@end
