//
//  HXSCreditEntity.h
//  store
//
//  Created by ArthurWang on 16/2/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXSCreditEntity : NSObject

@property (nonatomic, strong) NSArray *slidesArr;
@property (nonatomic, strong) NSArray *entriesArr;

+ (instancetype)initWithDictionary:(NSDictionary *)creditLayoutDic;

@end
