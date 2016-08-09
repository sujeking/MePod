//
//  CustomView.h
//
//  Code generated using QuartzCode 1.21 on 16/5/5.
//  www.quartzcodeapp.com
//

#import <UIKit/UIKit.h>


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

typedef NS_ENUM(NSInteger, REFRESH_STATUS) {
    REFRESH_STATUS_NORMAL           = 1,
    REFRESH_STATUS_BEFORE_REFRESH   = 2,
    REFRESH_STATUS_REFRESHING       = 3,
};

@interface CustomView : UIView

@property (nonatomic, strong) CAShapeLayer *greenPathLayer;
@property (nonatomic, strong) CAShapeLayer *redPathLayer;
@property (nonatomic, strong) CAShapeLayer *yellowPathLayer;
@property (nonatomic, strong) CAShapeLayer *bluePathLayer;

@property (nonatomic, strong) CAShapeLayer *ball;
@property (nonatomic, strong) CAShapeLayer *ball1;
@property (nonatomic, strong) CAShapeLayer *ball2;
@property (nonatomic, strong) CAShapeLayer *ball3;

@property (nonatomic, strong) CAShapeLayer *mainlayer;
@property (nonatomic, weak) UIScrollView *parentScrollView;
@property (nonatomic, assign) REFRESH_STATUS topRefreshStatus;
@property (nonatomic, copy) void (^refreshingCallback)();

- (void)adjustStatusByTop:(float)y;

@end