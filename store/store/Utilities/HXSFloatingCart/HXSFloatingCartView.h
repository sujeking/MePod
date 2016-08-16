//
//  HXSFloatingCartView.h
//  store
//
//  Created by chsasaw on 14/11/20.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HXSFloatingCartViewDelegate <NSObject>

@required

- (void)updateItem:(NSNumber *)itemIDNum
          quantity:(NSNumber *)quantityNum;
/**
 *  零食盒子
 *
 *  @param productIDStr
 *  @param quantityNum
 */
- (void)updateProduct:(NSString *)productIDStr
             quantity:(NSNumber *)quantityNum;

- (void)clearCart;

@end


@interface HXSFloatingCartView : UIView

@property (nonatomic, assign) BOOL           isAnimating;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, assign) id<HXSFloatingCartViewDelegate> cartViewDelegate;

+ (id)viewWithFrame:(CGRect)frame;


- (void)show;
- (void)hide:(BOOL)animation;

@end