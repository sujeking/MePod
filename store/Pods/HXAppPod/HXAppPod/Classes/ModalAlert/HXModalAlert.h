/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

/*
 Bugfixes and support for iOS4 by Jenox
 tmjenox@googlemail.com
 */

#import <UIKit/UIKit.h>

typedef enum {
    HXModalAlertTypeCustom,
    HXModalAlertTypePrompt
} HXModalAlertType;


#pragma mark -


@interface HXModalAlertDelegate : NSObject <UIAlertViewDelegate,UITextFieldDelegate>
{
    HXModalAlertType type;
    UIAlertView *alertView;
    NSUInteger index;
    NSString *inputValue;
    BOOL isOS4;
    BOOL isLandscape;
}

- (id)initWithType: (HXModalAlertType)aType;
- (void)moveAlert;
- (void)updateOrientation;
- (void)placeTextField;
- (void)placeTitle;

@property (nonatomic,assign) HXModalAlertType type;
@property (nonatomic,strong) UIAlertView *alertView;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,strong) NSString *inputValue;
@property (nonatomic,assign) BOOL isOS4;
@property (nonatomic,assign) BOOL isLandscape;

@end


#pragma mark -


@interface HXModalAlert : NSObject

+ (NSUInteger)queryWithStatement: (NSString *)statement title:(NSString *)title andButtons: (NSString *)firstButtonTitle, ...;
+ (void)alert:(NSString *)title message:(NSString *)message, ...;
+ (BOOL)ask:(NSString *)title message:(NSString *)message, ...;
+ (BOOL)confirm:(NSString *)title message:(NSString *)message, ...;

+ (void)alert: (NSString *)format, ...;
+ (BOOL)confirm: (NSString *)format, ...;
+ (BOOL)ask: (NSString *)format, ...;

+ (NSString *)prompt: (NSString *)placeholder withStatement: (NSString *)format, ...;

+ (BOOL)isAlerting;
@end