//
//  HXSDormItem.m
//  store
//
//  Created by chsasaw on 15/2/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormItem.h"
#import "HXSClickEvent.h"
#import "HXSBoxOrderModel.h"

@implementation HXSDormItem

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if(self = [super init]) {
        if(DIC_HAS_NUMBER(dictionary, @"rid")) {
            self.rid = [dictionary objectForKey:@"rid"];
        } else {
            return nil;
        }
        
        if(DIC_HAS_STRING(dictionary, @"name")) {
            self.name = [dictionary objectForKey:@"name"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"has_stock")) {
            self.has_stock = [[dictionary objectForKey:@"has_stock"] boolValue];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"price")) {
            self.price = [dictionary objectForKey:@"price"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"origin_price")) {
            self.origin_price = [dictionary objectForKey:@"origin_price"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"description")) {
            self.descriptionStr = [dictionary objectForKey:@"description"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"sales")) {
            self.sales = [dictionary objectForKey:@"sales"];
        }
        
        if (DIC_HAS_NUMBER(dictionary, @"sales_range")) {
            self.salesHotLevel = [dictionary objectForKey:@"sales_range"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"tip")) {
            self.tip = [dictionary objectForKey:@"tip"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"image_big")) {
            
            self.image_big = [dictionary objectForKey:@"image_big"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"image_medium")) {
            
            self.image_medium = [dictionary objectForKey:@"image_medium"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"image_small")) {
            
            self.image_small = [dictionary objectForKey:@"image_small"];
        }
        
        if(DIC_HAS_ARRAY(dictionary, @"images")) {
            self.images = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"images"]];
        } else {
            self.images = [NSMutableArray array];
        }
        
        if(DIC_HAS_STRING(dictionary, @"promotion_label")) {
            self.promotionLabel = [dictionary objectForKey:@"promotion_label"];
        }
        
        // 4.2零食盒添加
        if(DIC_HAS_NUMBER(dictionary, @"quantity")) {
            self.quantity = [dictionary objectForKey:@"quantity"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"stock")) {
            self.stock = [dictionary objectForKey:@"stock"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"amount")) {
            self.amount = [dictionary objectForKey:@"amount"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"cate_id")) {
            self.cate_id = [dictionary objectForKey:@"cate_id"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"image_thumb")) {
            
            self.image_thumb = [dictionary objectForKey:@"image_thumb"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"description_title")) {
            
            self.description_title = [dictionary objectForKey:@"description_title"];
        }
        
        if(DIC_HAS_STRING(dictionary, @"description_content")) {
            
            self.description_content = [dictionary objectForKey:@"description_content"];
        }
        
        if(DIC_HAS_NUMBER(dictionary, @"promotion_id")) {
            self.promotion_id = [dictionary objectForKey:@"promotion_id"];
        }
        
        self.promotions = [NSMutableArray array];
        if(DIC_HAS_ARRAY(dictionary, @"promotions")) {
            NSArray * promotionArray = [dictionary objectForKey:@"promotions"];
            for(NSDictionary * eventDic in promotionArray) {
                HXSClickEvent * event = [HXSClickEvent eventWithServerDic:eventDic];
                if(event) {
                    [self.promotions addObject:event];
                }
            }
        }
    }
    return self;
}

- (id)initWithItem:(id)itemObject
{
    self = [super init];
    if([itemObject isKindOfClass:[HXSBoxOrderItemModel class]])
    {
        HXSBoxOrderItemModel *info = (HXSBoxOrderItemModel *)(itemObject);
        
        self.images                 = info.imagesArr;
        self.name                   = info.nameStr;
        self.price                  = info.priceDoubleNum;
        self.stock                  = info.stockNum;
        self.tip                    = info.tipStr;
        self.description_content    = info.descriptionContentStr;
        self.descriptionStr         = info.descriptionStr;
        self.quantity               = info.quantityNum;
        self.isBox                  = YES;
        self.productIDStr           = info.productIdStr;
    }
    
    return self;
}

- (NSString *)getPromotionsString {
    NSMutableString * mutableString = [[NSMutableString alloc] init];
    for(HXSClickEvent * event in self.promotions) {
        if([event isKindOfClass:[HXSClickEvent class]] && event.title) {
            [mutableString appendString:event.title];
            [mutableString appendString:@" "];
        }
    }
    
    return mutableString;
}

@end
