//
//  HXSDormViewModel.h
//  Pods
//
//  Created by 格格 on 16/6/27.
//
//

#import <Foundation/Foundation.h>
#import "HXStoreWebService.h"
#import "HXSDormNegoziante.h"

#define HXS_DORM_LIST     @"dorm/list"

@interface HXSDormViewModel : NSObject

/**
 *  根据楼栋id获取店长列表
 *
 *  @param dormentry_id 楼栋id
 *  @param block
 */
+ (void) fetchDormListWithDormentryId:(NSNumber *)dormentry_id
                                 role:(NSNumber *)role
                             complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *dormList))block;

@end
