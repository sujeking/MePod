//
//  HXSContactInfoEntity.h
//  store
//
//  Created by 沈露萍 on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSContactInfoEntity : NSObject

/**父母姓名 */
@property (nonatomic, strong) NSString *parentNameStr;
/**父母联系电话 */
@property (nonatomic, strong) NSString *parentTelephoneStr;
/**室友姓名 */
@property (nonatomic, strong) NSString *roommateNameStr;
/**室友电话 */
@property (nonatomic, strong) NSString *roommateTelephoneStr;
/**同学电话 */
@property (nonatomic, strong) NSString *classmateNameStr;
/**同学电话 */
@property (nonatomic, strong) NSString *classmateTelephoneStr;

@end
