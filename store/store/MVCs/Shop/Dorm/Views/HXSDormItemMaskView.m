//
//  HXSDormItemMaskView.m
//  store
//
//  Created by ranliang on 15/4/30.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormItemMaskView.h"
#import "HXSDormItemView.h"
#import "HXSDormItem.h"


#pragma mark - HXSDormItemMaskDatasource

@implementation HXSDormItemMaskDatasource

+ (HXSDormItemMaskDatasource *)initMaskDataSourceWithCurrentImageView:(UIImageView *)imageView
                                                            shopModel:(id)shopModel
                                                            itemModel:(id)itemModel
{
    return [[HXSDormItemMaskDatasource alloc] initMaskDataSourceWithCurrentImageView:imageView
                                                                           shopModel:shopModel
                                                                           itemModel:itemModel];
}

- (instancetype)initMaskDataSourceWithCurrentImageView:(UIImageView *)imageView
                                             shopModel:(id)shopModel
                                             itemModel:(id)itemModel
{
    if (self = [super init])
    {
        CGRect frame = imageView.frame;
        _image = imageView.image;
        _initialImageFrame = [imageView convertRect:frame toView:[AppDelegate sharedDelegate].window];
        //检测是否需要店铺信息
        if (shopModel) {
            if ([shopModel isKindOfClass:[HXSShopEntity class]]) {
                _shopEntity = shopModel;
            }
        }
        //夜猫店
        if ([itemModel isKindOfClass:[HXSDormItem class]]) {
            _item = itemModel;
        } else { // 零食盒
            _boxItemModel = itemModel;
        }
    }
    return self;
}

@end


#pragma mark HXSDormItemMaskView

@implementation HXSDormItemMaskView
{
    HXSDormItemMaskDatasource *_dataSource;

    HXSDormItemView *_itemView;
    UIImageView *_imageView;
    UIView *_maskView;
    UIButton *_closeButton;
    UIView *_imageBGView;
    CGFloat _itemViewWidth;
    CGFloat _itemViewHeight;
    UILabel *_rightCornerLabel;
    
    id<HXSFoodieItemPopViewDelegate> _drinkDelegate;
}

- (id)initWithDataSource:(HXSDormItemMaskDatasource *)dataSource
           delegate:(id<HXSFoodieItemPopViewDelegate>)delegate
{
    if (self = [super init]) {
        _dataSource = dataSource;
        _drinkDelegate = delegate;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        //设置itemView的宽和高作为后续布局的依据，决定了itemView放大后的显示位置和closeButton的位置
        _itemViewWidth = IPAD ? SCREEN_WIDTH * 0.7 : SCREEN_WIDTH * 0.85;
        _itemViewHeight = _itemViewWidth * 8 / 5;
        
        self.backgroundColor = [UIColor clearColor];
        
        //监听屏幕旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        //加载子控件，但是不显示
        [self loadSubView];
        
    }
    return self;
}

// 处理本View显示过程中发生的iPad屏幕旋转事件
- (void)orientationChanged:(NSNotification *)notif
{
    
// 因为不再需要支持iPad横屏，所以注掉整个方法
    
//    if (IPAD) {
//        _maskView.alpha = 0;
//        if (SCREEN_HEIGHT > SCREEN_WIDTH) { // iPad变成了竖屏
//            [UIView animateWithDuration:0.3 animations:^{
//                self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                _maskView.frame = self.frame;
//                _imageView.frame = CGRectMake(SCREEN_WIDTH * 0.1, SCREEN_HEIGHT * 0.15, SCREEN_WIDTH * 0.8, SCREEN_WIDTH * 0.8);
//                _itemView.frame = CGRectMake(SCREEN_WIDTH * 0.1, SCREEN_HEIGHT * 0.15, SCREEN_WIDTH * 0.8, SCREEN_HEIGHT * 0.7);
//                _closeButton.frame = CGRectMake((IPAD && (SCREEN_WIDTH > SCREEN_HEIGHT)) ?  (SCREEN_HEIGHT * 0.8 * 0.6 - 45 ) : (SCREEN_WIDTH * 0.8 - 45), 0, 45, 45);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    _maskView.alpha = 0.3;
//                }];
//            }];
//        } else { // iPad变成了横屏
//            [UIView animateWithDuration:0.3 animations:^{
//                self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                _maskView.frame = self.frame;
//                _itemView.frame = CGRectMake(0, 0, SCREEN_HEIGHT * 0.8 * 0.6, SCREEN_HEIGHT * 0.8);
//                _itemView.center = self.center;
//                _imageView.frame = _itemView.frame;
//                CGRect frame = _imageView.frame;
//                frame.size.height = frame.size.width;
//                _imageView.frame = frame;
//                _closeButton.frame = CGRectMake((IPAD && (SCREEN_WIDTH > SCREEN_HEIGHT)) ?  (SCREEN_HEIGHT * 0.8 * 0.6 - 45 ) : (SCREEN_WIDTH * 0.8 - 45), 0, 45, 45);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    _maskView.alpha = 0.3;
//                }];
//            }];
//        }
//    }
}

- (void)showAnimated:(BOOL)animated
{
    [UIView animateWithDuration:( animated ? 0.25 : 0 ) animations:^{
        _maskView.alpha = 0.3;
        _itemView.alpha = 1.0;
        _maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

        _imageView.frame = CGRectMake(0, 0, _itemViewWidth, _itemViewWidth);
        _itemView.frame = CGRectMake((SCREEN_WIDTH - _itemViewWidth) / 2.0, (SCREEN_HEIGHT - _itemViewHeight) / 2.0, _itemViewWidth, _itemViewHeight);
        _imageBGView.frame = _itemView.frame;
        
    } completion:^(BOOL finished) {
        if(_dataSource.boxItemModel) {
            [_itemView setBoxOrderItem:_dataSource.boxItemModel];
            _itemView.delegate = _drinkDelegate;
        } else {
            [_itemView setItem:_dataSource.item shop:_dataSource.shopEntity];
        }
        
        _imageBGView.alpha = 0.0;
        
        [UIView animateWithDuration:0.25 animations:^{
            _itemView.titleLabel.alpha = 1.0;
            _itemView.priceLabel.alpha = 1.0;
            _itemView.descLabel.alpha = 1.0;
            _itemView.countView.alpha = 1.0;
            _itemView.pageControl.alpha = 1.0;
        }];
    }];
    
}

- (void)show
{
    [self showAnimated:YES];
}

- (void)loadSubView
{
    _maskView = [[UIView alloc] initWithFrame:self.frame];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf:)];
    [_maskView addGestureRecognizer:tap];
    [self addSubview:_maskView];
    
    _itemView = [[[UINib nibWithNibName:@"HXSDormItemView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] objectAtIndex:0];
    _itemView.scrollViewPlaceHolderImage = _dataSource.image;

    CGRect _itemViewAnimationFromFrame = _dataSource.initialImageFrame;
    _itemView.frame = _itemViewAnimationFromFrame;

    _itemView.alpha = 1.0;
    _itemView.layer.cornerRadius = 5.0f;
    _itemView.clipsToBounds = YES;
    [self addSubview:_itemView];

    _itemView.titleLabel.alpha = 0;
    _itemView.priceLabel.alpha = 0;
    _itemView.descLabel.alpha = 0;
    _itemView.countView.alpha = 0;
    _itemView.pageControl.alpha = 0;
    
    _imageBGView = [[UIView alloc] initWithFrame:_itemView.frame];
    _imageBGView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageBGView];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"ic_close_commoditylsyer_normal"] forState:UIControlStateNormal];
    _closeButton.contentMode = UIViewContentModeScaleAspectFit;
    _closeButton.frame = CGRectMake(_itemViewWidth - 45, 0, 45, 45);
    [_closeButton addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
    [_itemView addSubview:_closeButton];
    
    _imageView = [[UIImageView alloc] initWithImage:_dataSource.image];
    _imageView.frame = CGRectMake(0, 0, _dataSource.initialImageFrame.size.width, _dataSource.initialImageFrame.size.height);
    _imageView.layer.cornerRadius = 5.0f;
    _imageView.clipsToBounds = YES;
    [_imageBGView addSubview:_imageView];
    
    _rightCornerLabel = [[UILabel alloc] initWithFrame:CGRectMake(-21, 10, 80, 18)];
    [_rightCornerLabel setFont:[UIFont systemFontOfSize:10]];
    [_rightCornerLabel setTextColor:[UIColor whiteColor]];
    [_rightCornerLabel setBackgroundColor:UIColorFromRGB(0xF54642)];
    [_rightCornerLabel setTextAlignment:NSTextAlignmentCenter];
    _rightCornerLabel.transform = CGAffineTransformMakeRotation(- M_PI/4);
    
    [_itemView addSubview:_rightCornerLabel];
    
    // right corner label
    [_rightCornerLabel setHidden:_dataSource.item.promotionLabel.length == 0];
    if(!_rightCornerLabel.hidden) {
        [_rightCornerLabel setText:[_dataSource.item.promotionLabel substringToIndex:MIN(_dataSource.item.promotionLabel.length, 3)]];
    }
}

- (void)dismissSelf:(UITapGestureRecognizer *)ges
{
    _imageBGView.alpha = 1.0;
    
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.0;
        _imageBGView.frame = _dataSource.initialImageFrame;
        _imageView.frame = CGRectMake(0, 0, _dataSource.initialImageFrame.size.width, _dataSource.initialImageFrame.size.height);
        _itemView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
