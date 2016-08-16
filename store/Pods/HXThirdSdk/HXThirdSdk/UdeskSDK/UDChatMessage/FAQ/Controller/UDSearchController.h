//
//  UDSearchController.h
//  UdeskSDK
//
//  Created by xuchen on 15/11/26.
//  Copyright (c) 2015年 xuchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDContentController.h"

@interface UDSearchController : NSObject
/**
 *  搜索
 */
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
/**
 *  搜索数据
 */
@property (nonatomic, strong) NSArray                   *searchData;


- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController;


@end
