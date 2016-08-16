//
//  HXSDormCategory.m
//  store
//
//  Created by chsasaw on 15/2/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormCategory.h"
#import "HXSDormItem.h"

@implementation HXSDormCategory

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if(self = [super init]) {
        if(DIC_HAS_NUMBER(dictionary, @"cate_id") && DIC_HAS_STRING(dictionary, @"cate_name") && DIC_HAS_ARRAY(dictionary, @"items")) {
            self.cate_id = [dictionary objectForKey:@"cate_id"];
            self.cate_name = [dictionary objectForKey:@"cate_name"];
            self.items = [NSMutableArray array];
            self.sortedItems = [NSArray array];
            
            NSArray * itemsDic = [dictionary objectForKey:@"items"];
            for(NSDictionary * dic in itemsDic) {
                HXSDormItem * item = [[HXSDormItem alloc] initWithDictionary:dic];
                if(item) {
                    [self.items addObject:item];
                }
            }
            if([dictionary objectForKey:@"is_hidden"]) {
                self.is_hidden = [[dictionary objectForKey:@"is_hidden"] boolValue];
            }else {
                self.is_hidden = NO;
            }
            
            self.sortType = DormCategotySortTypeNormal;
        }else {
            return nil;
        }
        
        if(DIC_HAS_STRING(dictionary, @"cate_image")) {
            self.cateImage = [dictionary objectForKey:@"cate_image"];
        }else {
            self.cateImage = @"";
        }
        
        if (DIC_HAS_STRING(dictionary, @"cate_normal_image")) {
            self.cateNormalImageURLStr = [dictionary objectForKey:@"cate_normal_image"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"cate_disable_image")) {
            self.cateDisableImageURLStr = [dictionary objectForKey:@"cate_disable_image"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"cate_selected_image")) {
            self.cateSelectedImageURLStr = [dictionary objectForKey:@"cate_selected_image"];
        }
    }
    
    return self;
}

- (void)setSortType:(DormCategotySortType)sortType {
    _sortType = sortType;
    
    switch (sortType) {
        case DormCategotySortTypePriceAscending:
            self.sortedItems = [self.items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                HXSDormItem * item1 = (HXSDormItem *)obj1;
                HXSDormItem * item2 = (HXSDormItem *)obj2;
                return item1.price.floatValue <= item2.price.floatValue;
            }];
            
            break;
            
        case DormCategotySortTypePriceDescending:
            self.sortedItems = [self.items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                HXSDormItem * item1 = (HXSDormItem *)obj1;
                HXSDormItem * item2 = (HXSDormItem *)obj2;
                return item1.price.floatValue > item2.price.floatValue;
            }];
            
            break;
            
        case DormategotySortTypeSalesHotLevelDescending:
            self.sortedItems = [self.items sortedArrayUsingComparator:^NSComparisonResult(HXSDormItem *item1, HXSDormItem * item2) {
                NSInteger hotLevel1 = item1.salesHotLevel.integerValue;
                NSInteger hotLevel2 = item2.salesHotLevel.integerValue;
                
                if (hotLevel1 > hotLevel2) {
                    return NSOrderedAscending;
                }
                else if (hotLevel1 == hotLevel2) {
                    return NSOrderedSame;
                }
                else {
                    return NSOrderedDescending;
                }
            }];
            
            break;
        default:
            self.sortedItems = [NSMutableArray arrayWithArray:self.items];
            break;
    }
}

@end
