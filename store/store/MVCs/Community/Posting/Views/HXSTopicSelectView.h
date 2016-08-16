//
//  HXSTopicSelectView.h
//  store
//
//  Created by  黎明 on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
//话题选择回调
typedef void(^SelectedTopicBlock) (id obj);

@interface HXSTopicSelectView : UIView

@property (nonatomic, copy) SelectedTopicBlock selectedTopicBlock;

- (instancetype)initWithTags:(NSArray *)tags key:(NSString *)key selectedString:(NSString *)value;
@end
