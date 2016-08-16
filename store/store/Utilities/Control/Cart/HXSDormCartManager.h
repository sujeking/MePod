//
//  HXSDormCartManager.h
//  store
//
//  Created by chsasaw on 14/11/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSDormCart;
@class HXSDormCartItem;
@class HXSDormItem;

@interface HXSDormCartManager : NSObject

@property (nonatomic, strong) NSNumber *currentUserId;

@property (nonatomic, readonly) NSUInteger refreshingSessionNum, currentSessionNum, lastSessionNum;

+ (HXSDormCartManager *) sharedManager;

- (void)loadLastInfo;

- (void)refreshCartInfo;

- (void)checkNeedRefresh;

- (NSArray *)getCartItemsOfCurrentSession;
- (HXSDormCart *)getCartOfCurrentSession;
- (HXSDormCartItem *)getCartItemOfDormItem:(HXSDormItem *)dormItem;

- (void)addItem:(NSNumber *)rId quantity:(int)quantity;

- (void)updateItem:(NSNumber *)itemId quantity:(int)quantity;

- (void)clearCart;

- (void)checkCouponAvailable:(NSString *)couponCodeStr complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *cartInfo))block;

@end