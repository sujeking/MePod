//
//  HXSCommunityPostingModel.m
//  store
//
//  Created by J.006 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityPostingModel.h"
#import "HXSCommunitTopicEntity.h"

@implementation HXSCommunityPostingModel

- (void)postTheThread:(HXSCommunityPostingParamEntity *)entity
             complete:(void (^)(HXSErrorCode code, NSString *message, NSString *postIdStr))block
{
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionary];
    [pramaDic setObject:entity.contentStr forKey:@"content"];
    [pramaDic setObject:entity.topicIDStr forKey:@"topic_id"];
    [pramaDic setObject:entity.topicTitileStr forKey:@"topic_title"];
    [pramaDic setObject:entity.schoolIDStr forKey:@"site_id"];
    [pramaDic setObject:entity.schoolNameStr forKey:@"site_name"];
    if(entity.photoURLArray && [entity.photoURLArray count] > 0)
    {
        NSMutableArray<NSString *> *newURLArray = [[NSMutableArray alloc]init];
        for (NSString *urlStr in entity.photoURLArray)
        {
            NSString *newURLStr = [[urlStr lastPathComponent]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [newURLArray addObject:newURLStr];
        }
        [pramaDic setObject:[self appendURLStringWithURLArray:newURLArray] forKey:@"pictures"];
    }

    [HXStoreWebService postRequest:HXS_COMMUNITY_ADDPOST
                parameters:pramaDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status)
                       {
                           block(status, msg, nil);
                           return ;
                       }
                       NSString *postIDStr = [data objectForKey:@"post_id"];
                       block(status,msg,postIDStr);
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
    
}

- (void)uploadThePhoto:(HXSCommunitUploadImageEntity *)uploadImageEntity
              complete:(void (^)(HXSErrorCode code, NSString *message, NSString *urlStr))block;
{
    NSMutableArray *formDataArray = [[NSMutableArray alloc]init];
    [formDataArray addObject:uploadImageEntity.formData];
    [formDataArray addObject:uploadImageEntity.nameStr];
    [formDataArray addObject:uploadImageEntity.filenameStr];
    [formDataArray addObject:uploadImageEntity.mimeTypeStr];
    [HXStoreWebService uploadRequest:HXS_COMMUNITY_UPLOADPHOTO
                   parameters:nil
                formDataArray:formDataArray
                      progress:nil
                      success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                          if (kHXSNoError != status) {
                              block(status, msg, nil);
                              return ;
                          }
                          block(status, msg, [data objectForKey:@"url"]);
                      } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                          block(status,msg,nil);
                      }];

}

- (void)fetchAllTopicsListComplete:(void (^)(HXSErrorCode code, NSString *message, NSMutableArray *topicsListArray))block
{
    [HXStoreWebService getRequest:HXS_COMMUNITY_FETCHALLTOPICS
                 parameters:nil
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError != status)
                        {
                            block(status, msg, nil);
                            return ;
                        }
                        NSMutableArray *array;
                        NSArray *dataArray = [data objectForKey:@"topics_list"];
                        for (NSDictionary *dic in dataArray)
                        {
                            if(!array)
                                array = [[NSMutableArray alloc]init];
                            HXSCommunitTopicEntity *entity = [self createCommunitTopicEntityEntityWithData:dic];
                            [array addObject:entity];
                        }
                        if(array)
                        {
                           block(status,msg,array);
                        }
                        else
                        {
                           block(status,msg,nil);
                        }
                        
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    }];
}

#pragma mark private methords

- (void)appendURLToTheParamArrayWithURL:(NSString *)urlStr
                      andWithParaEntity:(HXSCommunityPostingParamEntity *)entity
{
    if(!entity)
        return;
    if(!entity.photoURLArray)
        entity.photoURLArray = [[NSMutableArray alloc]init];
    [entity.photoURLArray addObject:urlStr];
}

/**
 *  根据URL数组拼接字符串
 *
 *  @param urlStrArray
 *
 *  @return
 */
- (NSString *)appendURLStringWithURLArray:(NSMutableArray *)urlStrArray
{
    NSMutableString *urlString = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i<[urlStrArray count]; i++)
    {
        NSString *urlStr = [urlStrArray objectAtIndex:i];
        [urlString appendString:urlStr];
        if(i != [urlStrArray count]-1)
        {
            [urlString appendString:@","];
        }
    }
    return urlString;
}

- (HXSCommunitTopicEntity *)createCommunitTopicEntityEntityWithData:(NSDictionary *)dic
{
    return [[HXSCommunitTopicEntity alloc] initWithDictionary:dic error:nil];
}

@end
