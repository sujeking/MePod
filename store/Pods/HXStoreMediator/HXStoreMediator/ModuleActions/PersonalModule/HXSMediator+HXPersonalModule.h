//
//  HXSMediator+HXPersonalModule.h
//  Pods
//
//  Created by ArthurWang on 16/6/23.
//
//

#import "HXSMediator.h"

@interface HXSMediator (HXPersonalModule)

- (UIViewController *)HXSMediator_orderListViewController;

- (UIViewController *)HXSMediator_couponViewController;

- (UIViewController *)HXSMediator_forgotPasswordViewController;

- (UIViewController *)HXSMediator_addressBookViewController:(NSDictionary *)paramsDic;

- (NSNumber *)HXSMediator_isLoggedin;

- (NSNumber *)HXSMediator_selectedTabIndex:(NSDictionary *)paramsDic;

@end
