//
//  HXSMainPrintTypeEntity.h
//  store
//  打印主界面上提供的打印种类对象
//  Created by J006 on 16/5/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXSMainPrintType){
    kHXSMainPrintTypeDocument   = 0,//文档打印
    kHXSMainPrintTypePhoto      = 1,//照片打印
    kHXSMainPrintTypeScan       = 2,//扫描
    kHXSMainPrintTypeCopy       = 3,//复印
};

@interface HXSMainPrintTypeEntity : NSObject

/**类型名称*/
@property (nonatomic ,strong) NSString          *typeName;
/**图片名称*/
@property (nonatomic ,strong) NSString          *imageName;
/**所处店铺*/
@property (nonatomic ,strong) HXSShopEntity     *shopEntity;
/**打印类型*/
@property (nonatomic ,assign) HXSMainPrintType  printType;

@end
