//
//  HXSegmentControl.h
//  Test
//
//  Created by hudezhi on 15/7/17.
//  Copyright (c) 2015年 59store. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HXSegmentStyle : NSObject

@property(nonatomic) UIColor *borderColor;               // color for border and separator line, default white
@property(nonatomic) UIFont  *titleFont;                 // default: system 15
@property(nonatomic) UIColor *titleColor;                // default white
@property(nonatomic) UIColor *selectedTitleColor;        // default: 0x07A9FA
@property(nonatomic) UIColor *backGroundColor;           // default: 0x07A9FA
@property(nonatomic) UIColor *selectedBackgroundColor;   // default: whiteColor


+ (HXSegmentStyle *)defaultStyle;

@end



/*
 *  How to use:
 *  _segment.titles = @[@"夜猫店", @"零食盒"];
 *  [_segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
 *  or set action in storyBoard/xib, but can not set titles in storyboard/xib for now.
*/

IB_DESIGNABLE
@interface HXSegmentControl : UIControl

@property(nonatomic) HXSegmentStyle *style;  // default style, change if needed

@property(nonatomic) NSInteger   selectedIdx;
@property(nonatomic) NSArray     *titles;    //  title for each segment


- (void)setSelectedIdx:(NSInteger)selectedIdx sendmessage:(BOOL)sendMessage;

@end
