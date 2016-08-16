//
//  HXSSubscribeProgressViewModel.h
//  59dorm
//
//  Created by J006 on 16/7/11.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSSubscribeProgressSingleModel.h"

@interface HXSSubscribeProgressViewModel : NSObject

+ (instancetype)createSubscribeProgressViewModelWithCurrentIndex:(NSInteger)index;

- (NSArray<HXSSubscribeProgressSingleModel *> *)getModelArray;

@end
