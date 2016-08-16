//
//  HXURLShortenService.h
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXURLShortenService : NSObject

+(HXURLShortenService *)sharedInstance;

-(void)shortenURL:(NSString *)url target:(id)target selector:(SEL)selector;

@end