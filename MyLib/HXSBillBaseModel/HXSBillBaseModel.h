//
//  HXSBillBaseModel.h
//  store
//
//  Created by  黎明 on 16/7/28.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/************************************************************
 *  针对账单创建的BaseModel
 *  只要将相对的dict 传入即可，但是对于属性的命名规则如下
 *  {'user_name':'xxxxx'}  那么属性名称应该为userNameStr
 *  {'user_tel':1231234}  那么属性名称应该为userTelNum
 *  {'item_obj':{'key':'value'}} 针对value还是dict的 那么则需要重写下面的方法去创建对象，然后自己赋值,
 *  【注意key已经被修改为itemObj了】
 *  
 *  - (void)setValue:(id)value forUndefinedKey:(NSString *)key
 ***********************************************************/
#import <Foundation/Foundation.h>

@interface HXSBillBaseModel : NSObject

+ (instancetype)initWithDict:(id)object;

@end
