//
//  HXSItemListBase.m
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSItemListBase.h"

@implementation HXSItemListBase

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        self.allItems = [NSMutableArray array];
        self.listType = HXSItemListTypeUnknow;
        
        self.isUpdating = NO;
        self.hasMoreItem = YES;
        self.itemsPerpage = 10;
    }
    return self;
}

- (void) loadItems
{
    [self.allItems removeAllObjects];
    
    NSString * strPath = @"";
    NSArray * dicArray = [NSArray arrayWithContentsOfFile:strPath];
    if (dicArray != nil)
    {
        for (int i = 0; i < [dicArray count]; i++)
        {
            id item = [dicArray objectAtIndex:i];
            if ([item isKindOfClass:[NSDictionary class]])
            {
                HXSItemBase * itemBase = [HXSItemBase itemWithLocalDic:item];
                if (itemBase != nil)
                {
                    [self.allItems addObject:itemBase];
                }
            }
        }
    }
}

- (void) updateItemsFromBottom
{
    HXSItemBase * item = [self.allItems lastObject];
    if (item != nil)
    {
        [self updateItemsFrom:item];
    }
}

- (void) updateItemsFrom:(HXSItemBase *)item
{
}

- (BOOL) hasMoreItem
{
    if (_isUpdating)
        return YES;
    
    return _hasMoreItem;
}

- (BOOL) isUpdating
{
    return _isUpdating;
}

- (void) saveItems
{
    NSString * strPath = nil;
    if (strPath != nil)
    {
        NSMutableArray * items = [NSMutableArray arrayWithArray:self.allItems];
        NSMutableArray * dicArray = [NSMutableArray array];
        NSInteger saveCount = items.count;
        saveCount = MIN(100, saveCount);
        for (int i = 0; i < saveCount; i++)
        {
            HXSItemBase * itemBase = [items objectAtIndex:i];
            NSMutableDictionary * dic = [itemBase encodeAsLocalDic];
            [dicArray addObject:dic];
        }
        [dicArray writeToFile:strPath atomically:YES];
    }
}

- (HXSItemBase *)getItemByTitle:(NSString *)itemTitle {
    for(HXSItemBase * item in self.allItems) {
        if([item.title isEqualToString:itemTitle]) {
            return item;
        }
    }
    
    return nil;
}

@end