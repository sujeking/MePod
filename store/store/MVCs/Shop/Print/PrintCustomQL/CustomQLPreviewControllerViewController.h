//
//  CustomQLPreviewControllerViewController.h
//  DocInteraction
//
//  Created by J006 on 16/3/21.
//
//

#import <QuickLook/QuickLook.h>
#import "HXSPrintDownloadsObjectEntity.h"

@interface CustomQLPreviewControllerViewController : QLPreviewController

/**如果未读取到文件则显示log图标*/
@property (nonatomic, strong) UIImageView *fileIconImageView;
/**当前entity*/
@property (nonatomic, strong) HXSPrintDownloadsObjectEntity *currentEntity;

- (void)initCustomQLPreviewWithEntity:(HXSPrintDownloadsObjectEntity *)entity;

@end
