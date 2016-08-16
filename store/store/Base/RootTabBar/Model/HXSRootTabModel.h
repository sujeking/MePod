//
//  HXSRootTabModel.h
//  store
//
//  Created by  黎明 on 16/8/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HXSRootTabModel : HXBaseJSONModel

@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *iconUrl;
@property (nonatomic ,strong) UIColor *titleSelectColor;
@property (nonatomic ,strong) UIColor *titleNormalColor;

@end
