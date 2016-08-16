//
//  HXSDigitalMobileSelectionTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectionContentType){
    kSelectionContentTypeAddress = 0,
    kSelectionContentTypeParam   = 1,
};

@interface HXSDigitalMobileSelectionTableViewCell : UITableViewCell

- (void)setupCellWithTitile:(NSString *)titleStr content:(NSString *)contentStr type:(SelectionContentType)type;

@end
