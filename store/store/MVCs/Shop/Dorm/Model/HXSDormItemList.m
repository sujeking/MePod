//
//  HXSDormItemList.m
//  store
//
//  Created by chsasaw on 15/2/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormItemList.h"
#import "HXSDormItemsRequest.h"
#import "HXSSlideItem.h"
#import "HXSDormCategory.h"
#import "HXSDormItem.h"

@interface HXSDormItemList()

@property (nonatomic, strong) HXSDormItemsRequest * itemsRequest;

@property (nonatomic, assign) BOOL itemsUpdating;

@property (nonatomic, copy) NSString * error;

@end

@implementation HXSDormItemList

- (id)init {
    if(self = [super init]) {
        self.isUpdating = NO;
        self.itemCategoryList = [NSMutableArray array];
        
        self.itemList = [NSMutableArray array];
        self.listType = HXSItemListTypeDormMain;
        
        self.error = @"";
    }
    
    return self;
}

- (void)updateAllEntryInfo:(NSNumber *)shopIDNum
{
    if(self.isUpdating) {
        return;
    }
    
    self.error = @"";
    
    self.isUpdating = YES;
    self.itemsUpdating = YES;
    
    if(self.itemsRequest) {
        [self.itemsRequest cancel];
    }
    
    [self.itemCategoryList removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    
    self.itemsRequest = [[HXSDormItemsRequest alloc] init];
    [self.itemsRequest getDormItemListWithToken:[HXSUserAccount currentAccount].strToken
                                         shopId:shopIDNum
                                       complete:^(HXSErrorCode code, NSString *message, NSArray *items) {
        BEGIN_MAIN_THREAD
        if(code == kHXSNoError && items != nil && [items isKindOfClass:[NSArray class]]) {
            
            [self.itemList removeAllObjects];
            [self.itemList addObjectsFromArray:items];
            
        } else {
            weakSelf.error = message;
        }
        
        self.itemsUpdating = NO;
        [self checkLoadingFinished];
        END_MAIN_THREAD
    }];
}

- (void)checkLoadingFinished {
    @synchronized(self) {
        if(!self.itemsUpdating) {
            self.isUpdating = NO;
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(itemListUpdate:error:)]) {
                [self.delegate itemListUpdate:self.error.length == 0 error:self.error];
            }
        }
    }
}

/*
 *第actIndex个显示标题的分类在所有分类中的位置
 */
- (int)actToVisible:(int)actIndex {
    int visibleIndex = -1;
    int i = actIndex;
    for(HXSDormCategory * category in self.itemCategoryList) {
        if(!category.is_hidden) {
            visibleIndex ++;
        }
        i--;
        
        if(i<0) {
            return visibleIndex;
        }
    }
    
    return -1;
}

/*
 *第visibleIndex个分类在现实标题的分类中的位置
 */
- (int)visibleToAct:(int)visibleIndex {
    int actIndex = -1;
    int i = visibleIndex;
    for(HXSDormCategory * category in self.itemCategoryList) {
        actIndex ++;
        
        if(!category.is_hidden) {
            i --;
        }
        if(i<0) {
            return actIndex;
        }
    }
    
    return -1;
}


#pragma mark - 分页查询分类
/**
 *  查询分类列表【分页】
 *
 *  @param categoryId   分类id
 *  @param shopId       店铺id
 *  @param page         起始页 从1开始
 *  @param loadMore     是否为加载更多  YES表示加载更多  NO为从头开始
 *  @param num_per_page 每页请求的数量
 */
- (void)fetchCategoryitemsWith:(NSNumber *)categoryId
                        shopId:(NSNumber *)shopId
                  categoryType:(NSNumber *)type
                      starPage:(NSNumber *)page
                    isLoadMore:(BOOL)loadMore
                    numPerPage:(NSNumber *)num_per_page
{
    if(self.isUpdating) {
        return;
    }
    
    self.error = @"";
    
    self.isUpdating = YES;
    self.itemsUpdating = YES;
    
    if(self.itemsRequest) {
        [self.itemsRequest cancel];
    }
    [self.itemCategoryList removeAllObjects];
    __weak typeof(self) weakSelf = self;
    
    self.itemsRequest = [[HXSDormItemsRequest alloc] init];
    [self.itemsRequest fetchGoodsCategoryListWith:categoryId
                                           shopId:shopId
                                     categoryType:type
                                         starPage:page
                                       numPerPage:num_per_page
                                         complete:^(HXSErrorCode status, NSString *message, NSArray *items) {
                                             BEGIN_MAIN_THREAD
                                             if(status == kHXSNoError && items != nil && [items isKindOfClass:[NSArray class]]) {
                                                 if (!loadMore) {
                                                     [weakSelf.itemList removeAllObjects];
                                                 }
                                                 [weakSelf.itemList addObjectsFromArray:items];
                                                 weakSelf.hasMoreItem = items.count > 0;
                                                     
                                             } else if(status == kHXSItemIsEmpty){
                                                 
                                                 [weakSelf.itemList removeAllObjects];

                                                 weakSelf.error = message;
                                             }
                                             self.itemsUpdating = NO;
                                             [self checkLoadingFinished];
                                             END_MAIN_THREAD
                                         }];
}


@end
