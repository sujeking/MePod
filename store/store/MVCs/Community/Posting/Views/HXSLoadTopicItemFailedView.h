//
//  HXSUnLoadTopicListView.h
//  store
//
//  Created by  黎明 on 16/5/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReLoadTopicItemBlock)(void);

@interface HXSLoadTopicItemFailedView : UIView

@property (nonatomic, copy) ReLoadTopicItemBlock reLoadTopicItemBlock;
@end
