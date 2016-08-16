//
//  HXSH5TableViewCell.h
//  store
//
//  Created by  黎明 on 16/7/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/**
 *  社区帖子列表H5样式Cell
 */


#import <UIKit/UIKit.h>

@interface HXSCommunityH5Cell : UITableViewCell

@property (nonatomic, copy) void (^loadCommunityH5detail)();

- (void)setCellContentWithImageUrlStr:(NSString *)imageUrl titleText:(NSString *)text;
@end
