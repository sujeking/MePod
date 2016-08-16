//
//  HXSCommunityPostingModel.h
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCommunityPostingParamEntity.h"
#import "HXSCommunitUploadImageEntity.h"

@interface HXSCommunityPostingModel : NSObject

/**
 *  发布帖子
 *
 *  @param entity
 *  @param block
 */
- (void)postTheThread:(HXSCommunityPostingParamEntity *)entity
             complete:(void (^)(HXSErrorCode code, NSString *message, NSString *postIdStr))block;

/**
 *  上传图片
 *
 *  @param imageArray
 *  @param block
 */
- (void)uploadThePhoto:(HXSCommunitUploadImageEntity *)uploadImageEntity
              complete:(void (^)(HXSErrorCode code, NSString *message, NSString *urlStr))block;

/**
 *  获取所有话题列表
 *
 *  @param block
 */
- (void)fetchAllTopicsListComplete:(void (^)(HXSErrorCode code, NSString *message, NSMutableArray *topicsListArray))block;

/**
 *  将获取的图片url增加到ParamEntity
 *
 *  @param urlStr
 *  @param entity
 */
- (void)appendURLToTheParamArrayWithURL:(NSString *)urlStr
                      andWithParaEntity:(HXSCommunityPostingParamEntity *)entity;
@end
