//
//  HXSSitePostioningHeaderView.h
//  store
//
//  Created by chsasaw on 15/8/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSSitePostioningHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIButton * button;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * indicatorView;
@property (nonatomic, weak) IBOutlet UIImageView * locationImageView;
@property (nonatomic, weak) IBOutlet UILabel * locationLabel;
@property (nonatomic, weak) IBOutlet UILabel * gpsSiteLabel;

@end