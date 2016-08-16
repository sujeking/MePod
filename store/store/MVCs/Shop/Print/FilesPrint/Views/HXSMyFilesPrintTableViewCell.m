//
//  HXSMyFilesPrintTableViewCell.m
//  store
//
//  Created by J006 on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyFilesPrintTableViewCell.h"

// Views
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "UIRenderingButton.h"
// Others
#import "UIButton+HXSUIButoonHitExtensions.h"

@interface HXSMyFilesPrintTableViewCell()

@property (nonatomic ,strong) HXSPrintDownloadsObjectEntity *entity;
@property (weak ,nonatomic) IBOutlet FLAnimatedImageView    *documentLogoImageView;
@property (weak ,nonatomic) IBOutlet UILabel                *contentLabel;
@property (weak ,nonatomic) IBOutlet UILabel                *timeLabel;
/**加入购物车*/
@property (weak ,nonatomic) IBOutlet UIButton               *addToCartButton;
/**重新上传*/
@property (weak ,nonatomic) IBOutlet UIRenderingButton      *needToReUploadButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *contentLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *addToCartWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *addToCartHeightConstraint;

@end

@implementation HXSMyFilesPrintTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - init

- (void)initMyFilesPrintTableViewCellWithEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    _entity = entity;
    
    [self refreshTheCell];

    [self initTheContentLabel];
    
    [self initTheTimeLabelAndNeedReloadUploadButton];
}

/**
 *  初始化重置相关控件
 */
- (void)refreshTheCell
{
    _documentLogoImageView.animationImages = nil;
    [_documentLogoImageView stopAnimating];
    [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_newadd"]];
    
    [_contentLabel setText:@""];
    [_timeLabel setText:@""];
    
    [_addToCartButton setHidden:NO];
    [_addToCartButton setImage:[UIImage imageNamed:@"ic_yunyin_choose_normal"] forState:UIControlStateNormal];
    
    [_needToReUploadButton setHidden:YES];
    
}

/**
 *  设置文件名称
 */
- (void)initTheContentLabel
{
    [_contentLabel setText:_entity.archiveDocNameStr];
    
    switch (_entity.uploadType) {
        case kHXSDocumentDownloadTypeUploading:
        case kHXSDocumentDownloadTypeUploadFail:
        {
            [_contentLabel setTextColor:[UIColor colorWithRGBHex:0x95A0B0]];
            break;
        }
        case kHXSDocumentDownloadTypeUploadSucc:
        {
            [_contentLabel setTextColor:[UIColor colorWithRGBHex:0x666666]];
            break;
        }
    }
}

/**
 *  初始化上传时间和重新上传文件以及加入购物车按钮
 */
- (void)initTheTimeLabelAndNeedReloadUploadButton
{
    if(_entity.upLoadDate) {
        NSString *dateStr = [_entity.upLoadDate YMDPointString];
        [_timeLabel setText:[NSString stringWithFormat:@"上传时间 %@",dateStr]];
    } else {
        [_timeLabel setText:@""];
    }
    
    switch (_entity.uploadType) {
        case kHXSDocumentDownloadTypeUploading:
        {
            [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_add"]];
            [_timeLabel             setHidden:YES];
            [_needToReUploadButton  setHidden:YES];
            [_addToCartButton       setHidden:YES];
            
            _contentLabelTopConstraint.constant = 38;
            
            NSString* gifPath = [[NSBundle mainBundle] pathForResource:@"waveupload"
                                                                ofType:@"gif"];
            NSData *data = [NSData dataWithContentsOfFile:gifPath];
            FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
            _documentLogoImageView.animatedImage = image;
            
            break;
        }
        case kHXSDocumentDownloadTypeUploadSucc:
        {
            switch (_entity.archiveDocTypeNum) {
                case HXSDocumentTypePdf:
                {
                    [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_pdf"]];
                    break;
                }
                case HXSDocumentTypeDoc:
                {
                    [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_word"]];
                    break;
                }
                case HXSDocumentTypeTxt:
                {
                    [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_word"]];
                    break;
                }
                case HXSDocumentTypeImageJPEG:
                case HXSDocumentTypeImagePNG:
                case HXSDocumentTypeImageGIF:
                case HXSDocumentTypeImageTIFF:
                case HXSDocumentTypeImageWEBP:
                {
                    NSURL *url = [[NSURL alloc]initWithString:[_entity.uploadAndCartDocEntity originPathStr]];
                    [_documentLogoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_print_picture"]];
                    
                    break;
                }
                case HXSDocumentTypePPT:
                {
                    [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_ppt"]];
                    break;
                }
            }
            
            [_timeLabel             setHidden:NO];
            [_needToReUploadButton  setHidden:YES];
            [_addToCartButton       setHidden:NO];
            
            _contentLabelTopConstraint.constant = 27;
            
            if([_entity.uploadAndCartDocEntity isAddToCart])
            {
                [_addToCartButton setImage:[UIImage imageNamed:@"ic_yunyin_choose_selected"] forState:UIControlStateNormal];
            }
            else
            {
                [_addToCartButton setImage:[UIImage imageNamed:@"ic_yunyin_choose_normal"] forState:UIControlStateNormal];
            }
            
            [self addToCartButtonAnimation];
            
            [_addToCartButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];//增加触摸热点范围
            
            break;
        }
        case kHXSDocumentDownloadTypeUploadFail:
        {
            [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_jiazaishibai"]];
            [_needToReUploadButton  setHidden:NO];
            [_addToCartButton       setHidden:YES];
            [_timeLabel             setHidden:YES];
            
            _contentLabelTopConstraint.constant = 38;
            
            break;
        }
    }
}


#pragma mark Button Action

/**
 *  加入购物车或者从购物车删除
 *
 *  @param sender
 */
- (IBAction)addToCartOrRemove:(id)sender
{
    [_entity.uploadAndCartDocEntity setIsAddToCart:!_entity.uploadAndCartDocEntity.isAddToCart];
    if (self.delegate && [self.delegate respondsToSelector:@selector(addToCartOrRemovedWithEntity:andWithContentView:)]) {
        [self.delegate addToCartOrRemovedWithEntity:_entity
                                 andWithContentView:self.contentView];
    }
}

/**
 *  重新上传
 *
 *  @param sender 
 */
- (IBAction)reUploadTheDocument:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reUploadTheDocumentWithEntity:)]) {
        [self.delegate reUploadTheDocumentWithEntity:_entity];
    }
}

#pragma mark AddToCart Button Animation

- (void)addToCartButtonAnimation
{
    if(!_entity.isFirstFinishedUpload) {
        _addToCartWidthConstraint.constant = 0;
        _addToCartHeightConstraint.constant = 0;
        [self layoutIfNeeded];
        
        _addToCartWidthConstraint.constant = 21;
        _addToCartHeightConstraint.constant = 21;
        
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveLinear animations:^
        {
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
        _entity.isFirstFinishedUpload = YES;
    }
}

@end
