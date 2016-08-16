//
//  HXSSubscribeProgressSingleModel.h
//  59dorm
//
//  Created by J006 on 16/7/11.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HXSSubscribeProgressSingleModelCurrentType){
    HXSSubscribeProgressSingleModelCurrentTypeNot             = 0,//未到该环节
    HXSSubscribeProgressSingleModelCurrentTypeCurrent         = 1,//正好到此环节
    HXSSubscribeProgressSingleModelCurrentTypePass            = 2//已过此环节
};

@interface HXSSubscribeProgressSingleModel : NSObject

@property (nonatomic, strong) NSString  *contentStr;
/**有颜色大图标 */
@property (nonatomic, strong) NSString  *bigImageNameStr;
/**有颜色小图标 */
@property (nonatomic, strong) NSString  *smallImageNameStr;
/**灰色小图标 */
@property (nonatomic, strong) NSString  *notPassSmallImageNameStr;

@end
