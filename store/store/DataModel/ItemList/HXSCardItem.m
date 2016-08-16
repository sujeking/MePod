//
//  HXSCardItem.m
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSCardItem.h"

#define HXS_CARD_LAYOUT_STYLE_TYPE           @"layout"
#define HXS_CARD_LAYOUT_STYLE_SHOWTITLE      @"show_title"
#define HXS_CARD_LAYOUT_STYLE_SHOWACCESSORY  @"show_accessory"
#define HXS_CARD_LAYOUT_STYLE_BOTTOM_MARGIN  @"bottom_margin"

@implementation HXSCardItemLayoutStyle

- (id)initWithServerDic:(NSDictionary *)dic {
    if(self = [super init]) {
        if(DIC_HAS_NUMBER(dic, HXS_CARD_LAYOUT_STYLE_TYPE) || DIC_HAS_STRING(dic, HXS_CARD_LAYOUT_STYLE_TYPE)) {
            int type = [[dic objectForKey:HXS_CARD_LAYOUT_STYLE_TYPE] intValue];
            if(type >= HXSCardLayoutTypeFull && type <= HXSCardLayoutTypeThreeRight) {
                self.type = type;
            }else {
                self.type = HXSCardLayoutTypeFull;
            }
        }else {
            self.type = HXSCardLayoutTypeFull;
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_LAYOUT_STYLE_SHOWTITLE) || DIC_HAS_STRING(dic, HXS_CARD_LAYOUT_STYLE_SHOWTITLE)) {
            self.showTitle = [[dic objectForKey:HXS_CARD_LAYOUT_STYLE_SHOWTITLE] boolValue];
        }else {
            self.showTitle = NO;
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_LAYOUT_STYLE_SHOWACCESSORY) || DIC_HAS_STRING(dic, HXS_CARD_LAYOUT_STYLE_SHOWACCESSORY)) {
            self.show_accessory = [[dic objectForKey:HXS_CARD_LAYOUT_STYLE_SHOWACCESSORY] boolValue];
        }else {
            self.show_accessory = NO;
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_LAYOUT_STYLE_BOTTOM_MARGIN) || DIC_HAS_STRING(dic, HXS_CARD_LAYOUT_STYLE_BOTTOM_MARGIN)) {
            self.bottomMargin = [[dic objectForKey:HXS_CARD_LAYOUT_STYLE_BOTTOM_MARGIN] intValue];
        }else {
            self.bottomMargin = 5;
        }
    }
    
    return self;
}

- (id)initWithLocalDic:(NSDictionary *)dic {
    if(self = [super init]) {
        if(DIC_HAS_NUMBER(dic, HXS_CARD_LAYOUT_STYLE_TYPE) || DIC_HAS_STRING(dic, HXS_CARD_LAYOUT_STYLE_TYPE)) {
            int type = [[dic objectForKey:HXS_CARD_LAYOUT_STYLE_TYPE] intValue];
            if(type >= HXSCardLayoutTypeFull && type <= HXSCardLayoutTypeThreeRight) {
                self.type = type;
            }else {
                self.type = HXSCardLayoutTypeFull;
            }
        }else {
            self.type = HXSCardLayoutTypeFull;
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_LAYOUT_STYLE_SHOWTITLE) || DIC_HAS_STRING(dic, HXS_CARD_LAYOUT_STYLE_SHOWTITLE)) {
            self.showTitle = [[dic objectForKey:HXS_CARD_LAYOUT_STYLE_SHOWTITLE] boolValue];
        }else {
            self.showTitle = NO;
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_LAYOUT_STYLE_SHOWACCESSORY) || DIC_HAS_STRING(dic, HXS_CARD_LAYOUT_STYLE_SHOWACCESSORY)) {
            self.show_accessory = [[dic objectForKey:HXS_CARD_LAYOUT_STYLE_SHOWACCESSORY] boolValue];
        }else {
            self.show_accessory = NO;
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_LAYOUT_STYLE_BOTTOM_MARGIN) || DIC_HAS_STRING(dic, HXS_CARD_LAYOUT_STYLE_BOTTOM_MARGIN)) {
            self.bottomMargin = [[dic objectForKey:HXS_CARD_LAYOUT_STYLE_BOTTOM_MARGIN] intValue];
        }else {
            self.bottomMargin = 5;
        }
    }
    
    return self;
}

- (NSMutableDictionary *)encodeAsDic {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithInt:self.type] forKey:HXS_CARD_LAYOUT_STYLE_TYPE];
    [dic setObject:[NSNumber numberWithBool:self.show_accessory] forKey:HXS_CARD_LAYOUT_STYLE_SHOWACCESSORY];
    [dic setObject:[NSNumber numberWithBool:self.showTitle] forKey:HXS_CARD_LAYOUT_STYLE_SHOWTITLE];
    [dic setObject:[NSNumber numberWithInt:self.bottomMargin] forKey:HXS_CARD_LAYOUT_STYLE_BOTTOM_MARGIN];
    
    return dic;
}

@end

#define HXS_CARD_ITEM_ACCESSORY      @"accessory"
#define HXS_CARD_ITEM_ITEMLIST       @"items"
#define HXS_CARD_ITEM_LAYOUT_STYLE   @"style"
#define HXS_CARD_ITEM_STARTDATE      @"start_time"
#define HXS_CARD_ITEM_ENDDATE        @"end_time"

@implementation HXSCardItem

- (id)initWithServerDic:(NSDictionary *)dic {
    if(self = [super initWithServerDic:dic]) {
        if(DIC_HAS_STRING(dic, HXS_CARD_ITEM_ACCESSORY)) {
            self.accessoryText = [dic objectForKey:HXS_CARD_ITEM_ACCESSORY];
        }
        
        self.itemList = [NSMutableArray array];
        if(DIC_HAS_ARRAY(dic, HXS_CARD_ITEM_ITEMLIST)) {
            for(NSDictionary * itemDic in [dic objectForKey:HXS_CARD_ITEM_ITEMLIST]) {
                HXSItemBase * base = [HXSItemBase itemWithServerDic:itemDic itemType:ITEM_TYPE_BASE];
                [self.itemList addObject:base];
            }
            
            [self.itemList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                HXSItemBase * item1 = (HXSItemBase *)obj1;
                HXSItemBase * item2 = (HXSItemBase *)obj2;
                if( item1.order < item2.order) {
                    return NSOrderedAscending;
                }else if(item1.order == item2.order){
                    return NSOrderedSame;
                }else {
                    return NSOrderedDescending;
                }
            }];
        }
        
        if(DIC_HAS_DIC(dic, HXS_CARD_ITEM_LAYOUT_STYLE)) {
            self.layoutStyle = [[HXSCardItemLayoutStyle alloc] initWithServerDic:[dic objectForKey:HXS_CARD_ITEM_LAYOUT_STYLE]];
        }else {
            self.layoutStyle = [[HXSCardItemLayoutStyle alloc] initWithServerDic:nil];
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_ITEM_STARTDATE) || DIC_HAS_STRING(dic, HXS_CARD_ITEM_STARTDATE)) {
            self.startDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:HXS_CARD_ITEM_STARTDATE] integerValue]];
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_ITEM_ENDDATE) || DIC_HAS_STRING(dic, HXS_CARD_ITEM_ENDDATE)) {
            self.endDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:HXS_CARD_ITEM_ENDDATE] integerValue]];
        }
    }
    
    return self;
}

- (id)initWithLocalDic:(NSDictionary *)dic {
    if(self = [super initWithLocalDic:dic]) {
        if(DIC_HAS_STRING(dic, HXS_CARD_ITEM_ACCESSORY)) {
            self.accessoryText = [dic objectForKey:HXS_CARD_ITEM_ACCESSORY];
        }
        
        self.itemList = [NSMutableArray array];
        if(DIC_HAS_ARRAY(dic, HXS_CARD_ITEM_ITEMLIST)) {
            for(NSDictionary * itemDic in [dic objectForKey:HXS_CARD_ITEM_ITEMLIST]) {
                HXSItemBase * base = [HXSItemBase itemWithLocalDic:itemDic];
                [self.itemList addObject:base];
            }
            [self.itemList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                HXSItemBase * item1 = (HXSItemBase *)obj1;
                HXSItemBase * item2 = (HXSItemBase *)obj2;
                if( item1.order < item2.order) {
                    return NSOrderedAscending;
                }else if(item1.order == item2.order){
                    return NSOrderedSame;
                }else {
                    return NSOrderedDescending;
                }
            }];
        }
        
        if(DIC_HAS_DIC(dic, HXS_CARD_ITEM_LAYOUT_STYLE)) {
            self.layoutStyle = [[HXSCardItemLayoutStyle alloc] initWithLocalDic:[dic objectForKey:HXS_CARD_ITEM_LAYOUT_STYLE]];
        }else {
            self.layoutStyle = [[HXSCardItemLayoutStyle alloc] initWithLocalDic:nil];
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_ITEM_STARTDATE) || DIC_HAS_STRING(dic, HXS_CARD_ITEM_STARTDATE)) {
            self.startDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:HXS_CARD_ITEM_STARTDATE] integerValue]];
        }
        
        if(DIC_HAS_NUMBER(dic, HXS_CARD_ITEM_ENDDATE) || DIC_HAS_STRING(dic, HXS_CARD_ITEM_ENDDATE)) {
            self.endDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:HXS_CARD_ITEM_ENDDATE] integerValue]];
        }
    }
    
    return self;
}

- (NSMutableDictionary *)encodeAsLocalDic {
    NSMutableDictionary * dic = [super encodeAsLocalDic];
    
    if(self.accessoryText != nil) {
        [dic setObject:self.accessoryText forKey:HXS_CARD_ITEM_ACCESSORY];
    }
    
    if(self.itemList != nil) {
        NSMutableArray * itemListArray = [NSMutableArray array];
        for(HXSItemBase * itemBase in self.itemList) {
            [itemListArray addObject:[itemBase encodeAsLocalDic]];
        }
        [dic setObject:itemListArray forKey:HXS_CARD_ITEM_ITEMLIST];
    }
    
    if(self.layoutStyle != nil) {
        [dic setObject:[self.layoutStyle encodeAsDic] forKey:HXS_CARD_ITEM_LAYOUT_STYLE];
    }
    
    if(self.startDate) {
        [dic setObject:[NSNumber numberWithInteger:[self.startDate timeIntervalSince1970]] forKey:HXS_CARD_ITEM_STARTDATE];
    }
    
    if(self.endDate) {
        [dic setObject:[NSNumber numberWithInteger:[self.endDate timeIntervalSince1970]] forKey:HXS_CARD_ITEM_ENDDATE];
    }
    
    return dic;
}

- (CGSize)getImageSize {
    CGFloat height = 5, width = 5;
    switch (self.layoutStyle.type) {
        case HXSCardLayoutTypeFull:
        {
            if(self.itemList.count > 0) {
                HXSItemBase * item = [self.itemList firstObject];
                height = item.imageHeight.floatValue;
                width = item.imageWidth.floatValue;
            }
        }
            break;
            
        case HXSCardLayoutTypeTwoPart:
        {
            if(self.itemList.count > 1) {
                HXSItemBase * item1 = [self.itemList firstObject];
                HXSItemBase * item2 = [self.itemList objectAtIndex:1];
                width = item1.imageWidth.floatValue + item2.imageWidth.floatValue;
                height = MAX(item1.imageHeight.floatValue,item2.imageHeight.floatValue);
            }
        }
            break;
            
        case HXSCardLayoutTypeThreeLeft:
        {
            if(self.itemList.count > 2) {
                HXSItemBase * item1 = [self.itemList firstObject];
                HXSItemBase * item2 = [self.itemList objectAtIndex:1];
                HXSItemBase * item3 = [self.itemList objectAtIndex:2];
                width = item1.imageWidth.floatValue + MAX(item2.imageWidth.floatValue, item3.imageWidth.floatValue);
                height = MAX(item1.imageHeight.floatValue,item2.imageHeight.floatValue + item3.imageHeight.floatValue);
            }
        }
            break;
            
        case HXSCardLayoutTypeThreeRight:
        {
            if(self.itemList.count > 2) {
                HXSItemBase * item1 = [self.itemList firstObject];
                HXSItemBase * item2 = [self.itemList objectAtIndex:1];
                HXSItemBase * item3 = [self.itemList objectAtIndex:2];
                width = item3.imageWidth.floatValue + MAX(item2.imageWidth.floatValue, item1.imageWidth.floatValue);
                height = MAX(item3.imageHeight.floatValue,item2.imageHeight.floatValue + item1.imageHeight.floatValue);
            }
        }
            break;
            
        default:
            width = 100;
            height = 35;
            break;
    }
    
    return CGSizeMake(width, height);
}

@end