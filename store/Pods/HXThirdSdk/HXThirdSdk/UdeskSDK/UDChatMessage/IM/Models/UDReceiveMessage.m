//
//  UDReceiveChatMsg.m
//  UdeskSDK
//
//  Created by xuchen on 15/11/26.
//  Copyright (c) 2015年 xuchen. All rights reserved.
//

#import "UDReceiveMessage.h"
#import "UDAgentModel.h"
#import "UDMessage.h"
#import "UDTools.h"
#import "UDManager.h"
#import "UDCache.h"
#import <AVFoundation/AVFoundation.h>
#import "UDHpple.h"

@implementation UDReceiveMessage

+ (void)ud_messageModelWithDictionary:(NSDictionary *)messageDictionary
                           completion:(void(^)(UDMessage *message))completion
                        redirectAgent:(UDAgentDataCallBack)redirectAgent {

    UDMessage *message = [[UDMessage alloc] init];
    NSString *content_id = [UDTools soleString];
    if ([UDTools isBlankString:message.contentId]) {
        message.contentId = content_id;
    }
    
    message.messageStatus = UDMessageSuccess;
    
    //消息类型
    NSString *type = [messageDictionary objectForKey:@"type"];
    //消息内容
    NSString *content = [[messageDictionary objectForKey:@"data"] objectForKey:@"content"];
    
    //消息时间
    NSString *created_at = [UDTools nowDate];
    NSString *subString = [created_at substringWithRange:NSMakeRange(0, 19)];
    
    NSDate *lastDate = [UDTools dateFromString:subString];
    
    message.timestamp = lastDate;
    message.messageFrom = UDMessageTypeReceiving;
    
    //这里文件类型是个地址 所以归类到message了
    if ([type isEqualToString:@"message"]||[type isEqualToString:@"file"]) {
        message.text = [UDTools receiveTextEmoji:content];
        message.messageType = UDMessageMediaTypeText;
        
        NSArray *textDBArray = @[content,subString,content_id,[NSString stringWithFormat:@"%ld",(long)UDMessageSuccess],[NSString stringWithFormat:@"%ld",(long)UDMessageTypeReceiving],[NSString stringWithFormat:@"%ld",(long)UDMessageMediaTypeText]];
        [UDManager insertTableWithSqlString:InsertTextMsg params:textDBArray];
        
        if (completion) {
            completion(message);
        }
    }
    else if ([type isEqualToString:@"image"]) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *newURL = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newURL]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                message.photo  = image;
                //缓存图片
                [[UDCache sharedUDCache] storeImage:image forKey:message.contentId];
                
                message.messageType = UDMessageMediaTypePhoto;
                message.photoUrl = content;
                
                CGSize imageSize = [UDTools setImageSize:image];
                NSString *newWidth = [NSString stringWithFormat:@"%f",imageSize.width];
                NSString *newHeight = [NSString stringWithFormat:@"%f",imageSize.height];
                message.width = newWidth;
                message.height = newHeight;
                //存db
                NSArray *photoDBArray = @[content,subString,content_id,[NSString stringWithFormat:@"%ld",(long)UDMessageSuccess],[NSString stringWithFormat:@"%ld",(long)UDMessageTypeReceiving],[NSString stringWithFormat:@"%ld",(long)UDMessageMediaTypePhoto],newWidth,newHeight];
                [UDManager insertTableWithSqlString:InsertPhotoMsg params:photoDBArray];
                
                if (completion) {
                    completion(message);
                }
                
            });
        });
        
    }
    else if ([type isEqualToString:@"audio"]) {
        
        NSString *newURL = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc]initWithString:newURL];
        NSData *audioData = [NSData dataWithContentsOfURL:url];
        
        AVAudioPlayer *pl = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
        
        message.voiceDuration = [NSString stringWithFormat:@"%.f",pl.duration];
        
        message.messageType = UDMessageMediaTypeVoice;
        //缓存语音
        [[UDCache sharedUDCache] storeData:audioData forKey:message.contentId];
        
        NSArray *audioDBArray = @[content,subString,content_id,[NSString stringWithFormat:@"%ld",(long)UDMessageSuccess],[NSString stringWithFormat:@"%ld",(long)UDMessageTypeReceiving],[NSString stringWithFormat:@"%ld",(long)UDMessageMediaTypeVoice],[NSString stringWithFormat:@"%.f",pl.duration]];
        
        [UDManager insertTableWithSqlString:InsertAudioMsg params:audioDBArray];
        
        if (completion) {
            completion(message);
        }
    }
    else if ([type isEqualToString:@"redirect"]) {
        
        message.messageType = UDMessageMediaTypeRedirect;
        message.messageFrom = UDMessageTypeCenter;
        
        //请求被转移的客服
        [UDManager getRedirectAgentInformation:messageDictionary completion:^(id responseObject, NSError *error) {
            
            //解析数据
            if ([[responseObject objectForKey:@"code"] integerValue] == 1000) {
                
                NSString *nick = [[[responseObject objectForKey:@"result"] objectForKey:@"agent"] objectForKey:@"nick"];
                
                message.text = [NSString stringWithFormat:@"客服转接成功，%@ 为您服务",nick];
                
                //存储转移信息
                NSArray *textDBArray = @[message.text,subString,content_id,[NSString stringWithFormat:@"%ld",(long)UDMessageSuccess],[NSString stringWithFormat:@"%ld",(long)UDMessageTypeCenter],[NSString stringWithFormat:@"%ld",(long)UDMessageMediaTypeRedirect]];
                
                [UDManager insertTableWithSqlString:InsertTextMsg params:textDBArray];
                //block传出
                if (completion) {
                    completion(message);
                }
                //解析客服数据
                NSDictionary *result = [responseObject objectForKey:@"result"];
                UDAgentModel *agentModel = [[UDAgentModel alloc] initWithContentsOfDic:[result objectForKey:@"agent"]];
                
                agentModel.code = [[result objectForKey:@"code"] integerValue];
                
                agentModel.message = [result objectForKey:@"message"];
                
                if (agentModel.code == 2000) {
                    
                    NSString *describeTieleStr = [NSString stringWithFormat:@"客服 %@ 在线",agentModel.nick];
                    
                    agentModel.message = describeTieleStr;
                    
                }
                
                if (redirectAgent) {
                    redirectAgent(agentModel);
                }
                
            }
            
        }];
    }
    else if ([type isEqualToString:@"rich"]) {
        
        NSData *htmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
        UDHpple *xpathParser = [[UDHpple alloc] initWithHTMLData:htmlData];
        
        NSArray *dataPArray = [xpathParser searchWithXPathQuery:@"//p"];
        NSArray *dataAArray = [xpathParser searchWithXPathQuery:@"//a"];
        
        for (UDHppleElement *happleElement in dataPArray) {
            
            if ([UDTools isBlankString:message.text]) {
                message.text = happleElement.content;
            }
            else {
                
                message.text = [NSString stringWithFormat:@"%@\n",message.text];
                message.text = [message.text stringByAppendingString:happleElement.content];
            }
            
        }
        
        NSMutableDictionary *richURLDictionary = [NSMutableDictionary dictionary];
        NSMutableArray *richContetnArray = [NSMutableArray array];
        
        for (UDHppleElement *happleElement in dataAArray) {
            
            [richURLDictionary setObject:[NSString stringWithFormat:@"%@",happleElement.attributes[@"href"]] forKey:happleElement.content];
            [richContetnArray addObject:happleElement.content];
            
            message.richArray = [NSArray arrayWithArray:richContetnArray];
            
            message.richURLDictionary = [NSDictionary dictionaryWithDictionary:richURLDictionary];
            
        }
        
        message.messageType = UDMessageMediaTypeRich;
        
        NSArray *textDBArray = @[content,subString,content_id,[NSString stringWithFormat:@"%ld",(long)UDMessageSuccess],[NSString stringWithFormat:@"%ld",(long)UDMessageTypeReceiving],[NSString stringWithFormat:@"%ld",(long)UDMessageMediaTypeRich]];
        
        [UDManager insertTableWithSqlString:InsertTextMsg params:textDBArray];
        
        if (completion) {
            completion(message);
        }
        
    }

}

@end
