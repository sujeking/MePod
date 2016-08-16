//
//  HXSDormCategory.h
//  store
//
//  Created by chsasaw on 15/2/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DormCategotySortTypeNormal = 0,
    DormCategotySortTypePriceAscending = 1,
    DormCategotySortTypePriceDescending = 2,
    DormategotySortTypeSalesHotLevelDescending = 3,
} DormCategotySortType;

@interface HXSDormCategory : NSObject

@property (nonatomic, strong) NSNumber * cate_id;
@property (nonatomic, copy) NSString * cate_name;
@property (nonatomic, copy) NSString * cateImage;
// categorires images
@property (nonatomic, strong) NSString *cateNormalImageURLStr;
@property (nonatomic, strong) NSString *cateDisableImageURLStr;
@property (nonatomic, strong) NSString *cateSelectedImageURLStr;
@property (nonatomic, assign) BOOL is_hidden;

@property (nonatomic, strong) NSMutableArray * items;

// 排序
@property (nonatomic) DormCategotySortType sortType;
@property (nonatomic, strong) NSArray * sortedItems;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end