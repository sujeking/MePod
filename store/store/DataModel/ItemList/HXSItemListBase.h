//
//  HXSItemListBase.h
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSItemBase.h"

typedef enum{
    HXSItemListTypem,
    HXSItemListTypeStoreMain,
    HXSItemListTypeDormMain,
    HXSItemListTypeUnknow,
}HXSItemListType;

@protocol HXSItemListDelegate <NSObject>

- (void)itemListUpdate:(BOOL)success error:(NSString *)error;

@end

@interface HXSItemListBase : NSObject

@property (nonatomic, strong) NSMutableArray * allItems;
@property (nonatomic, assign) BOOL isUpdating;
@property (nonatomic, assign) BOOL hasMoreItem;
@property (nonatomic, assign) int itemsPerpage;
@property (nonatomic, assign) HXSItemListType listType;

@property (nonatomic, weak) id<HXSItemListDelegate> delegate;

- (void)loadItems;
- (void)updateItemsFrom:(HXSItemBase *)item;
- (void)updateItemsFromBottom;

- (void)saveItems;

- (HXSItemBase *) getItemByTitle:(NSString *)itemTitle;

@end