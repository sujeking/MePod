//
//  HXSTextSelectionViewController.h
//  store
//
//  Created by hudezhi on 15/8/19.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseTableViewController.h"

@interface HXSTextSelectionViewController : HXSBaseTableViewController

@property (nonatomic, strong) NSArray *texts;
@property (nonatomic, copy) void (^completion)(NSString *text);

@end
