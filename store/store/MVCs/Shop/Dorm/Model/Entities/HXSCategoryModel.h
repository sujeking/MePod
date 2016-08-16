//
//  HXSCategoryModel.h
//  store
//
//  Created by  黎明 on 16/3/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCategoryModel : NSObject

@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSNumber *categoryType;

+ (id)initWithDict:(NSDictionary *)dict;
@end
