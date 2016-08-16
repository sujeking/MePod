//
//  HXSDormNegoziante.h
//  Pods
//
//  Created by 格格 on 16/6/27.
//
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

@interface HXSDormNegoziante : HXBaseJSONModel

/** 用户图像 */
@property (nonatomic, strong) NSString *portraitStr;
/** 楼层 */
@property (nonatomic, strong) NSNumber *floorNum;
/** 店长ID */
@property (nonatomic, strong) NSNumber *dormIdNum;
/** 店长名称 */
@property (nonatomic, strong) NSString *dormNameStr;
/** 商品数量 */
@property (nonatomic, strong) NSNumber *itemNum;
/** 楼栋ID */
@property (nonatomic, strong) NSNumber *dormentryIdNum;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
