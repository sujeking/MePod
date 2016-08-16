//
//  HXSDormCartManager.m
//  store
//
//  Created by chsasaw on 14/11/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSDormCartManager.h"
#import "HXSDormCartItem.h"
#import "HXSDormCart.h"
#import "HXSDormCartInfoRequest.h"
#import "HXSDormSession.h"
#import "HXSDormItem.h"
#import "HXSShopManager.h"

static HXSDormCartManager *cartManagerSharedInstance = nil;

@interface HXSDormCartManager()
{
    BOOL _isRefreshDataError, _needRefresh;
    NSString * _refreshDataError;
}

@property (nonatomic, strong) HXSDormSession *refreshingSession;

@property (nonatomic, strong) HXSDormCartInfoRequest * request;
@property (nonatomic, strong) NSMutableArray * currentRequests;

@property (nonatomic, strong) HXSDormCart * currentCart;

@end

@implementation HXSDormCartManager

+ (HXSDormCartManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cartManagerSharedInstance = [[self alloc]init];
    });
    return cartManagerSharedInstance;
}

- (id)init {
    if(self = [super init]) {
        self.currentRequests = [NSMutableArray array];
        _isRefreshDataError = NO;
        _needRefresh = NO;
        _refreshDataError = @"";
    }
    
    return self;
}

- (NSNumber *)currentUserId {
    if(_currentUserId) {
        return _currentUserId;
    }else {
        return [NSNumber numberWithInteger:-1];
    }
}

- (NSNumber *)shopId {
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    if(shopManager.currentEntry && shopManager.currentEntry.shopEntity.shopIDIntNum) {
        return shopManager.currentEntry.shopEntity.shopIDIntNum;
    }else {
        return [NSNumber numberWithInteger:0];
    }
}

- (void)loadLastInfo
{
    self.currentUserId = [HXSUserAccount currentAccount].userID;
    
    NSArray *sessions = [HXSDormSession MR_findAllSortedBy:@"sessionNumber" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"ownerUserId == %@ and dormentryId == %@", self.currentUserId, [self shopId]]];
    _currentSessionNum = [[sessions lastObject] sessionNumber].integerValue;
    _lastSessionNum = _currentSessionNum - 1;
    _refreshingSessionNum = _currentSessionNum;
}

- (void)setupCurrentUserId: (NSNumber *)userId
{
    if(_currentUserId == nil && userId != nil) {
        //用户登录后，删除游客的所有数据
        [HXSDormSession MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId == %@", self.currentUserId]];
        [HXSDormCart MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId == %@", self.currentUserId]];
        [HXSDormCartItem MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId == %@", self.currentUserId]];
    }
    
    self.currentUserId = userId;
    
    [HXSDormSession MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"completed == 0"]];
    
    NSArray *sessions = [HXSDormSession MR_findAllSortedBy:@"sessionNumber" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"ownerUserId == %@ and dormentryId == %@", self.currentUserId , [self shopId]]];
    
    if (sessions.count==0) {
        _currentSessionNum = 0;
        _refreshingSessionNum = 0;
        _lastSessionNum = 0;
    } else {
        _currentSessionNum = [[sessions lastObject] sessionNumber].integerValue;
        _refreshingSessionNum = _currentSessionNum;
        _lastSessionNum = _currentSessionNum - 1;
    }
    
    DLog(@"setupCurrentUserId %@, sessions count %d, lastSession %d, currentSession %d", userId, (int)sessions.count, (int)_lastSessionNum, (int)_currentSessionNum);
}

#pragma mark - cart info
- (void)checkNeedRefresh
{
    if(_needRefresh) {
        [self refreshCartInfo];
    }
}

- (void)refreshCartInfo
{
    [self setupCurrentUserId:[HXSUserAccount currentAccount].userID];

    [self _refreshCartInfo];
}

- (void) _refreshCartInfo
{
    @synchronized(self) {

        if (self.currentUserId == nil) {
            DLog(@"error: current user is nil");
            return;
        }
        
        _refreshingSessionNum  ++;
        
        [HXSDormCart MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
        [HXSDormCartItem MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
        
        self.refreshingSession = [HXSDormSession MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"sessionNumber == %@ and ownerUserId == %@ and dormentryId == %@", @(_refreshingSessionNum), self.currentUserId, [self shopId]]];
        if (self.refreshingSession == nil) {
            self.refreshingSession = [HXSDormSession MR_createEntity];
            self.refreshingSession.sessionNumber = @(_refreshingSessionNum);
            self.refreshingSession.completed = @0;
            self.refreshingSession.ownerUserId = @0;
            self.refreshingSession.dormentryId = [self shopId];
        }
        DLog(@"will load session number: %@", self.refreshingSession.sessionNumber);
        _isRefreshDataError = NO;
        _refreshDataError = @"";
        
        [self getServiceCartInfo];
    }
}

- (void)getServiceCartInfo
{
    self.request = [[HXSDormCartInfoRequest alloc] init];
    self.request.sessionId = @(_refreshingSessionNum);
    __weak typeof (self) weakSelf = self;
    [self.request getCartInfoWithToken:[HXSUserAccount currentAccount].strToken
                               shop_id:[HXSShopManager shareManager].currentEntry.shopEntity.shopIDIntNum
                              complete:^(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString *message, NSDictionary *cartInfo) {
        
        DLog(@"%@", cartInfo);
        
        if (code != kHXSNoError) {
            _isRefreshDataError = YES;
            _refreshDataError = message;
        }
        
        [weakSelf saveCartInfo:cartInfo session:req.sessionId];
    }];
}

- (HXSDormCart *)getCartOfCurrentSession
{
    if(self.currentCart && (self.currentCart.sessionNumber.integerValue == _currentSessionNum && self.currentCart.dormentryId.integerValue == [self shopId].integerValue)) {
        return self.currentCart;
    }else {
        self.currentCart = [HXSDormCart MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_currentSessionNum), [self shopId]]];
        return self.currentCart;
    }
}

- (NSArray *)getCartItemsOfCurrentSession
{
    return [HXSDormCartItem MR_findAllSortedBy:@"order" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_currentSessionNum), [self shopId]]];
}

- (HXSDormCartItem *)getCartItemOfDormItem:(HXSDormItem *)dormItem
{
    return [HXSDormCartItem MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@ and rid == %@", self.currentUserId, @(_currentSessionNum), [self shopId], dormItem.rid]];
}


#pragma mark - Check Coupon Available

- (void)checkCouponAvailable:(NSString *)couponCodeStr complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block
{
    [self setupCurrentUserId:[HXSUserAccount currentAccount].userID];
    
    [self deleteCartBeforCheckingCoupon:couponCodeStr complete:block];
}

- (void)deleteCartBeforCheckingCoupon:(NSString *)couponCodeStr complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block
{
    @synchronized(self) {
        if (self.currentUserId == nil) {
            DLog(@"error: current user is nil");
            return;
        }
        
        _refreshingSessionNum  ++;
        
        [HXSDormCart MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
        [HXSDormCartItem MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
        
        self.refreshingSession = [HXSDormSession MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"sessionNumber == %@ and ownerUserId == %@ and dormentryId == %@", @(_refreshingSessionNum), self.currentUserId, [self shopId]]];
        if (self.refreshingSession == nil) {
            self.refreshingSession = [HXSDormSession MR_createEntity];
            self.refreshingSession.sessionNumber = @(_refreshingSessionNum);
            self.refreshingSession.completed = @0;
            self.refreshingSession.ownerUserId = @0;
            self.refreshingSession.dormentryId = [self shopId];
        }
        DLog(@"will load session number: %@", self.refreshingSession.sessionNumber);
        _isRefreshDataError = NO;
        _refreshDataError = @"";
        
        [self fetchCouponAvailableResult:couponCodeStr complete:block];
    }
}

- (void)fetchCouponAvailableResult:(NSString *)couponCodeStr complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block
{
    self.request = [[HXSDormCartInfoRequest alloc] init];
    self.request.sessionId = @(_refreshingSessionNum);
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [self shopId], @"shop_id",
                              couponCodeStr, @"code", nil];
    
    [HXStoreWebService postRequest:HXS_NIGHT_CAT_CART_USE_COUPON
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        DLog(@"%@", data);
                        
                        if (status != kHXSNoError) {
                            _isRefreshDataError = YES;
                            _refreshDataError = msg;
                        }
                        
                        [self saveCartInfo:data session:self.request.sessionId];
                        
                        block(status, msg, data);
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}


#pragma mark - add item
- (void)addItem:(NSNumber *)rId quantity:(int)quantity
{
    HXSDormCartInfoRequest * request = [[HXSDormCartInfoRequest alloc] init];
    [self.currentRequests addObject:request];
    
    __weak typeof (self) weakSelf = self;
    [request addItemWithToken:[HXSUserAccount currentAccount].strToken
                      shop_id:[self shopId]
                          rid:rId
                     quantity:quantity
                     complete:^(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString *message, NSDictionary *cartInfo) {
        
        [weakSelf.currentRequests removeObject:req];
        
        if(code == kHXSNoError) {
            [weakSelf refreshCartInfo];
            
            if(cartInfo) {
                NSString * tips = [cartInfo objectForKeyedSubscript:@"tips"];
                if(tips && tips.length > 0) {
                    UIWindow * window = [UIApplication sharedApplication].windows[0];
                    [MBProgressHUD showInViewWithoutIndicator:window status:tips afterDelay:2.0f];
                }
            }
        }else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:nil
                                                                              message:message
                                                                      leftButtonTitle:nil
                                                                    rightButtonTitles:@"确定"];
            [alertView show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDormCartComplete object:@YES];
        }
    }];
}

#pragma mark - update quantity
- (void)updateItem:(NSNumber *)itemId quantity:(int)quantity {
    @synchronized(self) {
        if (self.currentUserId == nil) {
            DLog(@"error: current user is nil");
            return;
        }
        
        _refreshingSessionNum ++;
        
        [HXSDormCart MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
        [HXSDormCartItem MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
        
        self.refreshingSession = [HXSDormSession MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"sessionNumber == %@ and ownerUserId == %@ and dormentryId == %@", @(_refreshingSessionNum), self.currentUserId, [self shopId]]];
        if (self.refreshingSession == nil) {
            self.refreshingSession = [HXSDormSession MR_createEntity];
            self.refreshingSession.sessionNumber = @(_refreshingSessionNum);
            self.refreshingSession.completed = @0;
            self.refreshingSession.ownerUserId = @0;
            self.refreshingSession.dormentryId = [self shopId];
        }
        DLog(@"will load session number: %@", self.refreshingSession.sessionNumber);
        _isRefreshDataError = NO;
        
        [self _updateItem:itemId quantity:quantity];
    }
}

- (void)_updateItem:(NSNumber *)itemId quantity:(int)quantity
{
    __weak typeof (self) weakSelf = self;
    self.request = [[HXSDormCartInfoRequest alloc] init];
    self.request.sessionId = @(_refreshingSessionNum);
    [self.request updateInfoWithToken:[HXSUserAccount currentAccount].strToken
                              shop_id:[self shopId]
                               itemId:itemId
                             quantity:quantity
                             complete:^(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString *message, NSDictionary *cartInfo) {
        
        DLog(@"%@", cartInfo);
        
        if (code != kHXSNoError) {
            _isRefreshDataError = YES;
            _refreshDataError = message;
        }
        
        [weakSelf saveCartInfo:cartInfo session:req.sessionId];
    }];
}

#pragma mark - clear cart
- (void)clearCart {
    @synchronized(self) {
        if (self.currentUserId == nil) {
            DLog(@"error: current user is nil");
            return;
        }
        
        _refreshingSessionNum ++;
        
        [HXSDormCart MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
        [HXSDormCartItem MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
        
        self.refreshingSession = [HXSDormSession MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"sessionNumber == %@ and ownerUserId == %@ and dormentryId == %@", @(_refreshingSessionNum), self.currentUserId, [self shopId]]];
        if (self.refreshingSession == nil) {
            self.refreshingSession = [HXSDormSession MR_createEntity];
            self.refreshingSession.sessionNumber = @(_refreshingSessionNum);
            self.refreshingSession.completed = @0;
            self.refreshingSession.ownerUserId = @0;
            self.refreshingSession.dormentryId = [self shopId];
        }
        DLog(@"will load session number: %@", self.refreshingSession.sessionNumber);
        _isRefreshDataError = NO;
        
        [self _clearCart];
    }
}

- (void)_clearCart
{
    self.request = [[HXSDormCartInfoRequest alloc] init];
    self.request.sessionId = @(_refreshingSessionNum);
    [self.request clearCartWithToken:[HXSUserAccount currentAccount].strToken
                             shop_id:[self shopId]
                            complete:^(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString *message, NSDictionary *cartInfo) {
        
        DLog(@"%@", cartInfo);
        
        if (code != kHXSNoError) {
            _isRefreshDataError = YES;
            _refreshDataError = message;
            
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:nil
                                                                              message:message
                                                                      leftButtonTitle:nil
                                                                    rightButtonTitles:@"确定"];
            [alertView show];
        }
        
        [self saveCartInfo:cartInfo session:req.sessionId];
    }];
}

#pragma mark - call back
- (void)checkRefreshFinished {
    @synchronized(self) {
        if (self.refreshingSession.completed.integerValue == 1) {
            if (_isRefreshDataError) {
                [self.refreshingSession MR_deleteEntity];
                [HXSDormCartItem MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
                [HXSDormCart MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"ownerUserId==%@ and sessionNumber==%@ and dormentryId == %@", self.currentUserId, @(_refreshingSessionNum), [self shopId]]];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDormCartComplete object:@NO userInfo:@{@"msg":_refreshDataError}];
                DLog(@"checkRefreshFailedFinished %@, lastSession %d, currentSession %d", self.currentUserId,  (int)_lastSessionNum, (int)_currentSessionNum);
            } else {
                _lastSessionNum = _currentSessionNum;
                _currentSessionNum = _refreshingSessionNum;
                self.refreshingSession.completed = @1;
                
                self.refreshingSession.ownerUserId = self.currentUserId;
                self.refreshingSession.dormentryId = [self shopId];
                [self.refreshingSession.managedObjectContext MR_saveToPersistentStoreAndWait];
                self.refreshingSession = nil;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDormCartComplete object:@YES];
                DLog(@"checkRefreshFinished %@, lastSession %d, currentSession %d", self.currentUserId,  (int)_lastSessionNum, (int)_currentSessionNum);
            }
            
            // notification view refresh
        } else {
            DLog(@"checkRefreshFinished: not finished");
        }
    }
}

- (void)saveCartInfo:(NSDictionary *)cartInfo session:(NSNumber *)sessionId {
    if(DIC_HAS_NUMBER(cartInfo, @"item_num") && sessionId.integerValue == _refreshingSessionNum) {
        _needRefresh = NO;
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            HXSDormCart * cart = [HXSDormCart MR_createEntityInContext:localContext];
            SET_NULLTONIL(cart.itemNum, cartInfo[@"item_num"]);
            SET_NULLTONIL(cart.itemAmount, cartInfo[@"item_amount"]);
            SET_NULLTONIL(cart.errorInfo, cartInfo[@"error_info"]);
            SET_NULLTONIL(cart.deliveryFee, cartInfo[@"delivery_fee"]);
            SET_NULLTONIL(cart.promotion_tip, cartInfo[@"promotion_tip"]);
            SET_NULLTONIL(cart.couponCode, cartInfo[@"coupon_code"]);
            SET_NULLTONIL(cart.couponDiscount, cartInfo[@"coupon_discount"]);
            SET_NULLTONIL(cart.originAmountDoubleNum, cartInfo[@"origin_amount"]);
            
            cart.ownerUserId = self.currentUserId;
            cart.sessionNumber = @(_refreshingSessionNum);
            cart.dormentryId = [self shopId];
            
            NSArray * items;
            SET_NULLTONIL(items, cartInfo[@"items"]);
            int order = 0;
            for (NSDictionary *itemDic in items) {
                if(![itemDic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                HXSDormCartItem *cartItem = [HXSDormCartItem MR_createEntityInContext:localContext];
                
                SET_NULLTONIL(cartItem.itemId, itemDic[@"item_id"]);
                SET_NULLTONIL(cartItem.rid, itemDic[@"rid"]);
                SET_NULLTONIL(cartItem.price, itemDic[@"price"]);
                SET_NULLTONIL(cartItem.quantity, itemDic[@"quantity"]);
                SET_NULLTONIL(cartItem.amount, itemDic[@"amount"]);
                SET_NULLTONIL(cartItem.dormentryId, itemDic[@"dormentry_id"]);
                SET_NULLTONIL(cartItem.name, itemDic[@"name"]);
                SET_NULLTONIL(cartItem.imageSmall, itemDic[@"image_small"]);
                SET_NULLTONIL(cartItem.imageMedium, itemDic[@"image_medium"]);
                SET_NULLTONIL(cartItem.imageBig, itemDic[@"image_big"]);
                SET_NULLTONIL(cartItem.error_info, itemDic[@"error_info"]);
                
                cartItem.ownerUserId = self.currentUserId;
                cartItem.sessionNumber = @(_refreshingSessionNum);
                cartItem.dormentryId = [self shopId];
                cartItem.order = [NSNumber numberWithInt:order];
                order ++;
            }
        }];
    }
    if(sessionId.integerValue == _refreshingSessionNum) {
        // all cart completed!
        self.refreshingSession.completed = @1;
        [self checkRefreshFinished];
    }
}

@end