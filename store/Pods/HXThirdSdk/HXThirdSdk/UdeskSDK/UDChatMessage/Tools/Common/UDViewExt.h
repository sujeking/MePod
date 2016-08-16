/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (UDViewFrameGeometry)
@property CGPoint ud_origin;
@property CGSize ud_size;

@property (readonly) CGPoint ud_bottomLeft;
@property (readonly) CGPoint ud_bottomRight;
@property (readonly) CGPoint ud_topRight;

@property CGFloat ud_height;
@property CGFloat ud_width;

@property CGFloat ud_top;
@property CGFloat ud_left;

@property CGFloat ud_bottom;
@property CGFloat ud_right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;
@end