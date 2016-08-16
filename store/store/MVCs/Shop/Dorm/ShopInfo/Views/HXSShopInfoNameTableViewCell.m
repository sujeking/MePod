//
//  HXSShopInfoNameTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/1/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopInfoNameTableViewCell.h"
#import "HXSAvatarBrowser.h"
#import "HXSShopEntity.h"

static NSInteger const kHeightShopNameCell = 90;
static NSInteger const kHeightAddressLabel = 16;

@interface HXSShopInfoNameTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel     *shopSignatureLabel;
@property (weak, nonatomic) IBOutlet UILabel     *shopStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel     *shopDeliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel     *shopAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel     *shopDeliveryTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel     *restingLabel;
@property (weak, nonatomic) IBOutlet UILabel     *canBookLabel;

@end

@implementation HXSShopInfoNameTableViewCell

- (void)awakeFromNib
{
    
    self.shopImageView.layer.cornerRadius = 4;
    self.shopImageView.layer.borderColor = [UIColor colorWithRGBHex:0xe1e2e1].CGColor;
    self.shopImageView.layer.borderWidth = 1;
    self.shopImageView.layer.masksToBounds = YES;
    
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - Public Methods

- (void)setupCellWithEntity:(HXSShopEntity *)entity
{
    // shop image
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:entity.shopLogoURLStr]
                          placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    
    self.shopImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShopImageView)];
    [self.shopImageView addGestureRecognizer:tapGestureRecognizer];
    
    // 个性签名
    self.shopSignatureLabel.text = entity.signaturesStr;
    
    // status label
    self.shopStatusLabel.layer.masksToBounds = YES;
    switch ([entity.statusIntNum integerValue]) {
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
    
    // delivery
    switch ([entity.deliveryStatusIntNum integerValue]) {
        case 0:
        {
            self.shopDeliveryLabel.text = @"送到寝室";
        }
            break;
            
        case 1:
        {
            self.shopDeliveryLabel.text = @"送到楼下";
        }
            break;
            
        case 2:
        {
            self.shopDeliveryLabel.text = @"只限自取";
        }
            
        default:
            break;
    }
    
    // address
    
    self.shopAddressLabel.text = entity.shopAddressStr;
    
    // delivery time
    if( 2 == entity.statusIntNum.intValue){
        self.shopDeliveryTimeLabel.text = entity.deliveryTimeStr;
        self.shopDeliveryTimeLabel.hidden = NO;
    }else{
        self.shopDeliveryTimeLabel.hidden = YES;
    }
}

- (void)showShopImageView
{
    [HXSAvatarBrowser showImage:self.shopImageView];
}

+ (CGFloat)rowHeight:(HXSShopEntity *)entity {

    NSString *addressString  = entity.shopAddressStr;
    CGFloat addressLabelHeight = [addressString boundingRectWithSize:CGSizeMake(115, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}
                                                        context:nil].size.height;
    
    addressLabelHeight = ceilf(addressLabelHeight);
    
    addressLabelHeight = (addressLabelHeight > kHeightAddressLabel) ? addressLabelHeight : kHeightAddressLabel;
    
    return MAX(addressLabelHeight + kHeightShopNameCell - kHeightAddressLabel, kHeightShopNameCell);

}

@end
