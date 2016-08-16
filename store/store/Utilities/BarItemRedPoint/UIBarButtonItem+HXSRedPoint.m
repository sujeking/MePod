//
//  UIBarButtonItem+HXSRedPoint.m
//  store
//
//  Created by ArthurWang on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "UIBarButtonItem+HXSRedPoint.h"

#import <objc/runtime.h>

NSString const *HXSRedPoint_redPointBadgeKey      = @"HXSRedPoint_redPointBadgeKey";
NSString const *HXSRedPoint_redPointBadgeValueKey = @"HXSRedPoint_redPointBadgeValueKey";

@implementation UIBarButtonItem (HXSRedPoint)

@dynamic redPointBadge, redPointBadgeValue;


- (void)redPointBadgeInit
{
    UIView *superview = nil;
    
    if (self.customView) {
        superview = self.customView;
        // Avoids redPointBadge to be clipped when animating its scale
        superview.clipsToBounds = NO;
    } else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        superview = [(id)self view];
    }
    [superview addSubview:self.redPointBadge];
}

#pragma mark - Utility methods

// Handle redPointBadge display when its properties have been changed (color, font, ...)
- (void)refreshredPointBadge
{
    if (!self.redPointBadgeValue || [self.redPointBadgeValue isEqualToString:@""] || ([self.redPointBadgeValue isEqualToString:@"0"])) {
        self.redPointBadge.hidden = YES;
    } else {
        self.redPointBadge.hidden = NO;
        [self updateRedPointBadgeValueAnimated:YES];
    }
    
}

- (void)updateredPointBadgeFrame
{
    UIView *superview = nil;
    CGFloat defaultOriginX = 0;
    if (self.customView) {
        superview = self.customView;
        defaultOriginX = superview.frame.size.width - self.redPointBadge.frame.size.width/2;
        // Avoids redPointBadge to be clipped when animating its scale
        superview.clipsToBounds = NO;
    } else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        superview = [(id)self view];
        defaultOriginX = superview.frame.size.width - self.redPointBadge.frame.size.width;
    }
    
    // Using const we make sure the redPointBadge doesn't get too smal
    self.redPointBadge.frame = CGRectMake(defaultOriginX, 0, 6, 6);
    self.redPointBadge.layer.cornerRadius = 6 / 2;
    self.redPointBadge.layer.masksToBounds = YES;
}

// Handle the redPointBadge changing value
- (void)updateRedPointBadgeValueAnimated:(BOOL)animated
{
    // Set the new value
    self.redPointBadge.text = self.redPointBadgeValue;
    
    // Animate the size modification if needed
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateredPointBadgeFrame];
    }];
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)removeredPointBadge
{
    // Animate redPointBadge removal
    [UIView animateWithDuration:0.2 animations:^{
        self.redPointBadge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.redPointBadge removeFromSuperview];
        self.redPointBadge = nil;
    }];
}

#pragma mark - Setter Getter Methods

- (UILabel*)redPointBadge
{
    UILabel* lbl = objc_getAssociatedObject(self, &HXSRedPoint_redPointBadgeKey);
    if(lbl == nil) {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        lbl.layer.masksToBounds = YES;
        lbl.layer.cornerRadius  = 3;
        lbl.textColor        = [UIColor redColor];
        lbl.backgroundColor  = [UIColor redColor];
        [self setredPointBadge:lbl];
        [self redPointBadgeInit];
        [self.customView addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
    }
    return lbl;
}
-(void)setredPointBadge:(UILabel *)redPointBadgeLabel
{
    objc_setAssociatedObject(self, &HXSRedPoint_redPointBadgeKey, redPointBadgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// redPointBadge value to be display
- (NSString *)redPointBadgeValue {
    return objc_getAssociatedObject(self, &HXSRedPoint_redPointBadgeValueKey);
}
- (void)setRedPointBadgeValue:(NSString *)redPointBadgeValue
{
    objc_setAssociatedObject(self, &HXSRedPoint_redPointBadgeValueKey, redPointBadgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the redPointBadge value check if we need to remove the redPointBadge
    [self updateRedPointBadgeValueAnimated:YES];
    [self refreshredPointBadge];
}

@end
