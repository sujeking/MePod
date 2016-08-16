//
//  HXAppConfig.h
//  store
//
//  Created by chsasaw on 14-10-13.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface HXMailComponents : NSObject

@property (nonatomic, strong) NSArray* receivers;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSData* logAttachement;

@end

@interface HXAppConfig : NSObject

+ (HXAppConfig *)sharedInstance;

@property(nonatomic, strong) NSString              *appName;
@property(nonatomic, strong) NSString              *appVersion;
@property(nonatomic, strong) NSString              *appBuild;

@property(nonatomic, strong) NSOrderedSet          *historyVersions;

@end

