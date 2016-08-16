//
//  HXSCommunityPostingParamEntity.h
//  store
//
//  Created by J006 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCommunityPostingParamEntity : NSObject

/** 内容 */
@property (nonatomic, strong) NSString *contentStr;
/**图片URL拼接字符串 */
@property (nonatomic, strong) NSString *photoURLStr;
/** 话题ID */
@property (nonatomic, strong) NSString *topicIDStr;
/** 话题名称 */
@property (nonatomic, strong) NSString *topicTitileStr;
/** 学校id */
@property (nonatomic, strong) NSString *schoolIDStr;
/** 学校名称 */
@property (nonatomic, strong) NSString *schoolNameStr;
/**图片URL集合 */
@property (nonatomic, strong) NSMutableArray *photoURLArray;

@end
