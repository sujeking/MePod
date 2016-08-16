//
//  HXSItemBase.m
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSItemBase.h"
#import "HXSEntryItem.h"
#import "HXSSlideItem.h"
#import "HXSCardItem.h"

#define HXS_DIC_ITEM_TITLE  @"title"
#define HXS_DIC_ITEM_IMAGE  @"image"
#define HXS_DIC_ITEM_EVENT  @"action"
#define HXS_DIC_ITEM_TYPE   @"type"
#define SLIDE_ITEM_ORDER    @"order"
#define HXS_DIC_ITEM_IMAGE_WIDTH    @"image_width"
#define HXS_DIC_ITEM_IMAGE_HEIGHT   @"image_height"

@implementation HXSItemBase

#pragma mark - decode & encode

- (id) initWithLocalDic:(NSDictionary *)dic
{
    self = [self init];
    if (self != nil)
    {
        if (DIC_HAS_STRING(dic, HXS_DIC_ITEM_TITLE))
        {
            self.title = [dic objectForKey:HXS_DIC_ITEM_TITLE];
        }
        
        if (DIC_HAS_STRING(dic, HXS_DIC_ITEM_IMAGE))
        {
            self.image = [dic objectForKey:HXS_DIC_ITEM_IMAGE];
        }
        
        if (DIC_HAS_NUMBER(dic, HXS_DIC_ITEM_IMAGE_WIDTH))
        {
            self.imageWidth = [dic objectForKey:HXS_DIC_ITEM_IMAGE_WIDTH];
        }
        
        if (DIC_HAS_NUMBER(dic, HXS_DIC_ITEM_IMAGE_HEIGHT))
        {
            self.imageHeight = [dic objectForKey:HXS_DIC_ITEM_IMAGE_HEIGHT];
        }
        
        if (DIC_HAS_DIC(dic, HXS_DIC_ITEM_EVENT))
        {
            self.clickEvent = [HXSClickEvent eventWithLocalDic:[dic objectForKey:HXS_DIC_ITEM_EVENT]];
        }
        
        if (DIC_HAS_STRING(dic, HXS_DIC_ITEM_TYPE))
        {
            self.itemType = [dic objectForKey:HXS_DIC_ITEM_TYPE];
        }else {
            self.itemType = ITEM_TYPE_BASE;
        }
        
        if(DIC_HAS_NUMBER(dic, SLIDE_ITEM_ORDER)) {
            self.order = [[dic objectForKey:SLIDE_ITEM_ORDER] intValue];
        }
    }
    
    return self;
}

- (id) initWithServerDic:(NSDictionary *)dic
{
    self = [self init];
    if (self != nil)
    {
        if (DIC_HAS_STRING(dic, HXS_DIC_ITEM_TITLE))
        {
            self.title = [dic objectForKey:HXS_DIC_ITEM_TITLE];
        }
        
        if (DIC_HAS_STRING(dic, HXS_DIC_ITEM_IMAGE))
        {
            self.image = [dic objectForKey:HXS_DIC_ITEM_IMAGE];
        }
        
        if (DIC_HAS_NUMBER(dic, HXS_DIC_ITEM_IMAGE_WIDTH))
        {
            self.imageWidth = [dic objectForKey:HXS_DIC_ITEM_IMAGE_WIDTH];
        }
        
        if (DIC_HAS_NUMBER(dic, HXS_DIC_ITEM_IMAGE_HEIGHT))
        {
            self.imageHeight = [dic objectForKey:HXS_DIC_ITEM_IMAGE_HEIGHT];
        }
        
        if (DIC_HAS_DIC(dic, HXS_DIC_ITEM_EVENT))
        {
            self.clickEvent = [HXSClickEvent eventWithServerDic:[dic objectForKey:HXS_DIC_ITEM_EVENT]];
        }
        
        if (DIC_HAS_STRING(dic, HXS_DIC_ITEM_TYPE))
        {
            self.itemType = [dic objectForKey:HXS_DIC_ITEM_TYPE];
        }else {
            self.itemType = ITEM_TYPE_BASE;
        }
        
        if(DIC_HAS_NUMBER(dic, SLIDE_ITEM_ORDER)) {
            self.order = [[dic objectForKey:SLIDE_ITEM_ORDER] intValue];
        }
    }
    return self;
}

+ (HXSItemBase *) itemWithLocalDic:(NSDictionary *)dic
{
    HXSItemBase * item = nil;
    
    if (DIC_HAS_STRING(dic, HXS_DIC_ITEM_TYPE))
    {
        NSString * type = [dic objectForKey:HXS_DIC_ITEM_TYPE];
        if ([type isEqualToString:ITEM_TYPE_BASE])
        {
            item = [[HXSItemBase alloc] initWithLocalDic:dic];
        }
        else if ([type isEqualToString:ITEM_TYPE_ENTRY])
        {
            item = [[HXSEntryItem alloc] initWithLocalDic:dic];
        }
        else if ([type isEqualToString:ITEM_TYPE_SLIDE])
        {
            item = [[HXSSlideItem alloc] initWithLocalDic:dic];
        }
        else if ([type isEqualToString:ITEM_TYPE_CARD])
        {
            item = [[HXSCardItem alloc] initWithLocalDic:dic];
        }
    }
    
    if (item == nil)
    {
        DLog(@"Error!!! itemWithLocalDic wrong");
    }
    
    return item;
}

+ (HXSItemBase *) itemWithServerDic:(NSDictionary *)dic itemType:(NSString *)itemType
{
    HXSItemBase * item = nil;
    
    if (itemType)
    {
        if ([itemType isEqualToString:ITEM_TYPE_BASE])
        {
            item = [[HXSItemBase alloc] initWithServerDic:dic];
            item.itemType = ITEM_TYPE_BASE;
        }
        else if ([itemType isEqualToString:ITEM_TYPE_ENTRY])
        {
            item = [[HXSEntryItem alloc] initWithServerDic:dic];
            item.itemType = ITEM_TYPE_ENTRY;
        }
        else if ([itemType isEqualToString:ITEM_TYPE_SLIDE])
        {
            item = [[HXSSlideItem alloc] initWithServerDic:dic];
            item.itemType = ITEM_TYPE_SLIDE;
        }
        else if ([itemType isEqualToString:ITEM_TYPE_CARD])
        {
            item = [[HXSCardItem alloc] initWithServerDic:dic];
            item.itemType = ITEM_TYPE_CARD;
        }
    }
    
    if (item == nil)
    {
        NSAssert(item != nil, @"Error!!! itemWithServerDic wrong. %@", [dic description]);
    }
    
    return item;
}

- (NSMutableDictionary *) encodeAsLocalDic
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if (self.title != nil)
    {
        [dic setObject:self.title forKey:HXS_DIC_ITEM_TITLE];
    }
    
    if (self.itemType != nil)
    {
        [dic setObject:self.itemType forKey:HXS_DIC_ITEM_TYPE];
    }
    
    if (self.image != nil)
    {
        [dic setObject:self.image forKey:HXS_DIC_ITEM_IMAGE];
    }
    
    if (self.imageWidth)
    {
        [dic setObject:self.imageWidth forKey:HXS_DIC_ITEM_IMAGE_WIDTH];
    }
    
    if (self.imageHeight)
    {
        [dic setObject:self.imageHeight forKey:HXS_DIC_ITEM_IMAGE_HEIGHT];
    }
    
    if (self.clickEvent != nil)
    {
        [dic setObject:[self.clickEvent encodeAsLocalDic] forKey:HXS_DIC_ITEM_EVENT];
    }
    
    [dic setObject:[NSNumber numberWithInt:self.order] forKey:SLIDE_ITEM_ORDER];
    
    return dic;
}

- (CGSize)getImageSize {
    return CGSizeMake(self.imageWidth.floatValue, self.imageHeight.floatValue);
}

@end