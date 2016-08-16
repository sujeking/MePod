//
//  HXSUnLoadTopicListView.m
//  store
//
//  Created by  黎明 on 16/5/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/**
 *  加载话题选项失败页面
 *
 *  @return
 */


#import "HXSLoadTopicItemFailedView.h"

@implementation HXSLoadTopicItemFailedView

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(reLoadTopicItemList)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)reLoadTopicItemList
{
    if (self.reLoadTopicItemBlock) {
        self.reLoadTopicItemBlock();
    }
}

@end
