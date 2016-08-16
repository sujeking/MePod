/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

/*
 Bugfixes and support for iOS4 by Jenox
 tmjenox@googlemail.com
 */
#import "HXModalAlert.h"
#include <libkern/OSAtomic.h>

@implementation HXModalAlertDelegate
@synthesize type,alertView;
@synthesize index,inputValue;
@synthesize isOS4,isLandscape;

#pragma mark Object Lifecycle

// initializes the delegate
- (id)init
{
    return [self initWithType: HXModalAlertTypeCustom];
}

// initializes the delegate with a given type
- (id)initWithType: (HXModalAlertType)aType
{
    // sets the RunLoop, the type, the system version and subscribes for orientation changes
    if (self = [super init])
    {
        self.type = aType;
        self.isOS4 = ([[UIDevice currentDevice].systemVersion floatValue] >= 4.0);
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateOrientation) name: UIDeviceOrientationDidChangeNotification object: nil];
        [self updateOrientation];
    }
    return self;
}

#pragma mark UIAlertViewDelegate Methods

// customizes the AlertView before presenting it to the user
- (void)willPresentAlertView: (UIAlertView *)anAlertView
{
    if (self.type == HXModalAlertTypePrompt)
    {
        // places the TextField above the buttons
        [self placeTextField];
        
        // gives focus to the TextField and changes the position of the title (if iOS4 is running)
        if (self.isOS4)
        {
            [[self.alertView viewWithTag: 1000] becomeFirstResponder];
            [self placeTitle];
        }
    }
    
}

// customizes the AlertView after presenting it to the user
- (void)didPresentAlertView: (UIAlertView *)alert
{
    if (self.type == HXModalAlertTypePrompt)
    {
        // gives focus to the TextField (if a system version other than iOS4 is running)
        if (!self.isOS4)
        {
            [[self.alertView viewWithTag: 1000] becomeFirstResponder];
        }
        
        // moves the AlertView in order to make enough space for the keyboard
        [self moveAlert];
    }
}

// handles a touch on one of the buttons
- (void)alertView: (UIAlertView *)anAlertView willDismissWithButtonIndex: (NSInteger)anIndex
{
    // saves the index of the touched button
    self.index = anIndex;
    
    if (self.type == HXModalAlertTypePrompt)
    {
        // dismisses the keyboard and saves the TextField's text
        UITextField *textField = (UITextField *)[anAlertView viewWithTag: 1000];
        [textField resignFirstResponder];
        self.inputValue = textField.text;
        
        if ( UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone) {
            // updates the center of the AlertView in order to avoid a sudden movement to the screen's center
            if (self.isLandscape)
            {
                alertView.center = CGPointMake(240.0,(self.isOS4 ? 79.0 : 90.0));
            }
            else
            {
                alertView.center = CGPointMake(160.0,(self.isOS4 ? 142.0 : 170.0));
            }
        }
    }
}

// stops the RunLoop when the AlertView has disappeared
- (void)alertView: (UIAlertView *)anAlertView didDismissWithButtonIndex: (NSInteger)buttonIndex
{
    CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark UITextFieldDelegate Methods

// dismissed the keyboard - just as if the user touched the "Ok" button
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [alertView dismissWithClickedButtonIndex: 1 animated: YES];
    return YES;
}

#pragma mark Custom Methods

// moves the AlertView with an animation in order to make enough space for the keyboard
- (void)moveAlert
{
    // by zhouhesheng, not move ipad
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return;
    }
    // cancels method execution if the alert-type differs from HXModalAlertTypePrompt
    if (self.type != HXModalAlertTypePrompt)
    {
        return;
    }
    
    // fixes some minor bugs according to the system version
    if (self.isOS4)
    {
        [self placeTitle];
    }
    else
    {
        [alertView superview].frame = CGRectMake(0.0,0.0,320.0,480.0);
    }
    
    // sets up a basic animation
    [UIView beginAnimations: nil context: UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.25];
    
    // updates the position of the AlertView, according to the system version and orientation
    if (self.isLandscape)
    {
        if (self.isOS4)
        {
            alertView.center = CGPointMake(240.0,79.0);
            alertView.message = @"\n";
        }
        else
        {
            alertView.center = CGPointMake(240.0,90.0);
        }
    }
    else
    {
        if (self.isOS4)
        {
            alertView.center = CGPointMake(160.0,142.0);
            alertView.message = @"\n\n";
        }
        else
        {
            alertView.center = CGPointMake(160.0,170.0);
        }
    }
    
    // commits the animation
    [UIView commitAnimations];
}

// updates the instance variable that represents the interface orientation
- (void)updateOrientation
{
    self.isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    if (self.type == HXModalAlertTypePrompt)
    {
        // moves the AlertView according to the orientation
        [self moveAlert];
    }
}

// places the TextField above the buttons
- (void)placeTextField
{
    UITextField *textField = (UITextField *)[self.alertView viewWithTag: 1000];
    textField.center = CGPointMake((self.alertView.bounds.size.width / 2.0),(self.alertView.bounds.size.height - 82.0));
}

// updates the position of the AlertView's title
- (void)placeTitle
{
    UILabel *titleLabel = (UILabel *)[[self.alertView subviews] objectAtIndex: 0];
    CGRect frame = titleLabel.frame;
    frame.origin.y = 12.0;
    titleLabel.frame = frame;
}

#pragma mark Memory Management

// cleans up
- (void)dealloc
{	// removes itself as a notification-receiver
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
}
@end


#pragma mark -
static int alerting=0;

@implementation HXModalAlert

+ (BOOL)isAlerting {
    return alerting;
}

// creates a custom alert
+ (NSUInteger)queryWithStatement:(NSString *)statement title:(NSString *)title andButtons:(NSString *)firstButtonTitle, ...
{
    if (firstButtonTitle==nil) return INT32_MAX;
    
    OSAtomicIncrement32(&alerting);
    HXModalAlertDelegate *alertDelegate = [HXModalAlertDelegate new];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:statement
                                                       delegate:alertDelegate
                                              cancelButtonTitle:firstButtonTitle
                                              otherButtonTitles:nil];
    alertDelegate.alertView = alertView;
    
    // adds the other buttons to the AlertView
    {
        va_list buttons;
        va_start(buttons,firstButtonTitle);
        NSString *buttonTitle;
        while ((buttonTitle = va_arg(buttons,NSString *)))
        {
            [alertView addButtonWithTitle: buttonTitle];
        }
        va_end(buttons);
    }
    
    // shows the AlertView and starts the RunLoop
    [alertView show];
    CFRunLoopRun();
    
    // cleans up and returns the index of the touched button
    NSUInteger index = alertDelegate.index;
    
    OSAtomicDecrement32(&alerting);
    return index;
}


// creates a basic alert
+ (void)alert: (NSString *)format, ...
{
    // works out the text which will be displayed within the alert
    if (format==nil) return;
    
    va_list argList;
    va_start(argList,format);
    NSString *statement = [[NSString alloc] initWithFormat: format arguments: argList];
    va_end(argList);
    
    // creates the alert
    [HXModalAlert queryWithStatement:nil title:statement andButtons: NSLocalizedString(@"OK",@"确定"),nil];
}

// creates a basic alert
+ (void)alert:(NSString *)title message:(NSString *)message, ...
{
    if (message==nil) return;
    
    va_list argList;
    va_start(argList,message);
    NSString *statement = [[NSString alloc] initWithFormat:message arguments: argList];
    va_end(argList);
    
    // creates the alert
    [HXModalAlert queryWithStatement: statement title:title andButtons: NSLocalizedString(@"OK",@"确定"),nil];
}


// creates an alert with a "Ok" and a "Cancel" button
+ (BOOL)confirm: (NSString *)format, ...
{
    if (format==nil) return NO;
    
    // works out the text which will be displayed within the alert
    va_list argList;
    va_start(argList,format);
    NSString *statement = [[NSString alloc] initWithFormat: format arguments: argList];
    va_end(argList);
    
    // creates the alert
    return !![HXModalAlert queryWithStatement:nil title:statement andButtons: NSLocalizedString(@"Cancel",@"取消"),NSLocalizedString(@"OK",@"确定"),nil];
}

// creates an alert with a "Ok" and a "Cancel" button
+ (BOOL)confirm:(NSString *)title message:(NSString *)message, ...
{
    if (message==nil) return NO;
    
    // works out the text which will be displayed within the alert
    va_list argList;
    va_start(argList,message);
    NSString *statement = [[NSString alloc] initWithFormat: message arguments: argList];
    va_end(argList);
    
    // creates the alert
    return !![HXModalAlert queryWithStatement: statement title:title andButtons: NSLocalizedString(@"Cancel",@"取消"),NSLocalizedString(@"OK",@"确定"),nil];
}

// creates an alert with a "Yes" and a "No" button
+ (BOOL)ask: (NSString *)format, ...
{
    if (format==nil) return NO;
    
    // works out the text which will be displayed within the alert
    va_list argList;
    va_start(argList,format);
    NSString *statement = [[NSString alloc] initWithFormat: format arguments: argList];
    va_end(argList);
    
    // creates the alert
    return ![HXModalAlert queryWithStatement:nil title:statement andButtons:NSLocalizedString(@"YES",@"是"),NSLocalizedString(@"NO",@"否"),nil];
}

// creates an alert with a "Yes" and a "No" button
+ (BOOL)ask:(NSString *)title message:(NSString *)message, ...
{
    if (message==nil) return NO;
    
    // works out the text which will be displayed within the alert
    va_list argList;
    va_start(argList,message);
    NSString *statement = [[NSString alloc] initWithFormat:message arguments: argList];
    va_end(argList);
    
    // creates the alert
    return ![HXModalAlert queryWithStatement: statement title:title andButtons:NSLocalizedString(@"YES",@"是"),NSLocalizedString(@"NO",@"否"),nil];
}

// displays an alert where the user can enter some text
+ (NSString *)prompt: (NSString *)placeholder withStatement:(NSString *)format, ...
{
    if (format==nil) return nil;
    
    OSAtomicIncrement32(&alerting);
    // works out the text which will be displayed within the alert
    va_list argList;
    va_start(argList,format);
    NSString *statement = [[NSString alloc] initWithFormat:format arguments: argList];
    va_end(argList);
    
    // creates the AlertDelegate
    HXModalAlertDelegate *alertDelegate = [[HXModalAlertDelegate alloc] initWithType: HXModalAlertTypePrompt];
    
    // creates the AlertView
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: statement message: @"\n" delegate: alertDelegate cancelButtonTitle: NSLocalizedString(@"Cancel",@"取消") otherButtonTitles:NSLocalizedString(@"OK",@"确定"),nil];
    alertDelegate.alertView = alertView;
    
    // creates the text field and adds it to the AlertView
    UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(0.0,0.0,260.0,30.0)];
    textField.delegate = alertDelegate;
    textField.placeholder = placeholder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.tag = 1000;
    [alertView addSubview: textField];
    // fixes a bug for iOS4 in landscape mode
    if (alertDelegate.isLandscape && alertDelegate.isOS4)
    {
        alertView.message = @"\n\n";
    }
    
    // shows the AlertView and starts the RunLoop
    [alertView show];
    CFRunLoopRun();
    
    // cleans up and returns the entered text
    NSString *inputValue = (alertDelegate.index ? alertDelegate.inputValue : nil);
    OSAtomicDecrement32(&alerting);
    
    return ((inputValue.length > 0) ? inputValue : nil);
}
@end