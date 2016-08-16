//
//  HXSPrintCartTableViewCell.m
//  store
//
//  Created by J006 on 16/3/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintCartTableViewCell.h"
#import "UIButton+HXSUIButoonHitExtensions.h"

@interface HXSPrintCartTableViewCell()

@property (weak, nonatomic) IBOutlet UIView                 *greyContainerView; // 灰色底部界面
@property (weak, nonatomic) IBOutlet UILabel                *documentNameLabel; // 文档名称
@property (weak, nonatomic) IBOutlet UILabel                *printSetLabel;     // 打印设置:黑白双面
@property (weak, nonatomic) IBOutlet UILabel                *reduceSetLabel;    // 缩印设置:不缩印
@property (weak, nonatomic) IBOutlet UILabel                *printPagesLabel;   // 打印页数
@property (weak, nonatomic) IBOutlet UILabel                *priceLabel;        // 价格
@property (weak, nonatomic) IBOutlet UIImageView            *documentLogoImageView;

@property (nonatomic, strong) HXSMyPrintOrderItem           *entity;
@property (nonatomic, assign) HXSPrintCartCellSettingType   type;

@end

@implementation HXSPrintCartTableViewCell


#pragma mark - init

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initPrintCartTableViewCellWithEntity:(HXSMyPrintOrderItem *)entity
                                     andType:(HXSPrintCartCellSettingType)type;
{
    _entity = entity;
    _type   = type;
    
    [self initTheLogoImageViewWithEntity:entity];
    [self initTheLabelTextWithEntity:entity];
}

- (void)initTheLogoImageViewWithEntity:(HXSMyPrintOrderItem *)entity
{
    switch (_type)
    {
        case kHXSPrintCartCellSettingTypePic:
        {
            [_documentLogoImageView setImage:entity.picImage];
        }
            
            break;
            
        default:
        {
            switch (entity.archiveDocTypeNum)
            {
                case HXSDocumentTypePdf:
                {
                    [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_pdf"]];
                    break;
                }
                case HXSDocumentTypeDoc:
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
                    NSURL *url = [[NSURL alloc]initWithString:[_entity originPathStr]];
                    [_documentLogoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_print_picture"]];
                    break;
                }
                case HXSDocumentTypePPT:
                {
                    [_documentLogoImageView setImage:[UIImage imageNamed:@"img_print_ppt"]];
                    break;
                }
            }
        }
            break;
    }
}

- (void)initTheLabelTextWithEntity:(HXSMyPrintOrderItem *)entity
{
    
    [_printSetLabel     setText:entity.currentSelectSetPrintEntity.printNameStr];
    [_reduceSetLabel    setText:entity.currentSelectSetReduceEntity.reduceedNameStr];
    
    switch (_type)
    {
        case kHXSPrintCartCellSettingTypePic:
        {
            [_documentNameLabel setText:entity.fileNameStr];
            [_printPagesLabel   setText:[NSString stringWithFormat:@"%@张",[entity.quantityIntNum stringValue]]];
            [_priceLabel        setText:[NSString stringWithFormat:@"¥%.2f",[entity.priceDoubleNum doubleValue]]];
        }
            
            break;
            
        default:
        {
            [_documentNameLabel setText:entity.fileNameStr];
            [_printPagesLabel   setText:[NSString stringWithFormat:@"%@页X%@份",[entity.pageReduceIntNum stringValue],[entity.quantityIntNum stringValue]]];
            [_priceLabel        setText:[NSString stringWithFormat:@"¥%.2f",[entity.amountDoubleNum doubleValue]]];
        }
            break;
    }
}

@end
