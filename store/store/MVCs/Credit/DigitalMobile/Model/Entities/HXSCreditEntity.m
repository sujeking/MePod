//
//  HXSCreditEntity.m
//  store
//
//  Created by ArthurWang on 16/2/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditEntity.h"

#import "HXSSlideItem.h"

static NSString * const kCreditLayoutSlides = @"slides";
static NSString * const kCreditLayoutEntries = @"entries";

@implementation HXSCreditEntity


#pragma mark - Public Methods

+ (instancetype)initWithDictionary:(NSDictionary *)creditLayoutDic
{
    HXSCreditEntity *creditEntity = [[HXSCreditEntity alloc] init];
    
    if ([creditLayoutDic isKindOfClass:[NSDictionary class]]) {
        
        if (DIC_HAS_ARRAY(creditLayoutDic, kCreditLayoutSlides)) {
            NSMutableArray *slidesMArr = [[NSMutableArray alloc] initWithCapacity:5];
            NSArray *slidesArr = [creditLayoutDic objectForKey:kCreditLayoutSlides];
            for (NSDictionary *dic in slidesArr) {
                HXSSlideItem *item = (HXSSlideItem *)[HXSSlideItem itemWithServerDic:dic
                                                            itemType:ITEM_TYPE_SLIDE];
                [slidesMArr addObject:item];
            }
            
            creditEntity.slidesArr = slidesMArr;
        } else {
            creditEntity.slidesArr = nil;
        }
        
        if (DIC_HAS_ARRAY(creditLayoutDic, kCreditLayoutEntries)) {
            NSMutableArray *entriesMArr = [[NSMutableArray alloc] initWithCapacity:5];
            NSArray *entriesArr = [creditLayoutDic objectForKey:kCreditLayoutEntries];
            for (NSDictionary *dic in entriesArr) {
                HXSSlideItem *item = (HXSSlideItem *)[HXSSlideItem itemWithServerDic:dic
                                                                            itemType:ITEM_TYPE_ENTRY];
                [entriesMArr addObject:item];
            }
            
            creditEntity.entriesArr = entriesMArr;
        } else {
            creditEntity.entriesArr = nil;
        }
        
    }
    
    return creditEntity;
}

@end
