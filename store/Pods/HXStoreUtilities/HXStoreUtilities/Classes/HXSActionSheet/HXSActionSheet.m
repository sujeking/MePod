//
//  HXSActionSheet.m
//  Test
//
//  Created by hudezhi on 15/11/25.
//  Copyright © 2015年 59store. All rights reserved.
//

#import "HXSActionSheet.h"
#import "HXSWXApiManager.h"
#import "HXSActionSheetCell.h"
#import "HXSActionSheetCellNormal.h"
#import "UIColor+Extensions.h"
#import "UIView+Extension.h"

static NSString *HXSActionSheetCellIdentify       = @"kHXSActionSheetCell";
static NSString *HXSActionSheetCellNormalIdentify = @"HXSActionSheetCellNormal";

//================================================================================================================================================
@interface HXSAction ()

@property (nonatomic, strong) HXSActionSheetEntity *methodsEntity;
@property (nonatomic, copy)   HXSActionHandler handler;

@end

@implementation HXSAction

+ (instancetype)actionWithMethods:(HXSActionSheetEntity *)methodsEntity
                          handler: (HXSActionHandler)handler
{
    HXSAction *action = [[HXSAction alloc] init];
    action.methodsEntity = methodsEntity;
    action.handler = handler;
    
    return action;
}

@end


@interface HXSActionSheet ()<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray  *_items;
    UIButton        *_cancelButton;
    
    UIView          *_grayBackgroundView;
    UITableView     *_tableView;
}

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *cancelTitle;

- (void)setup;
- (void)hide;

@end

@implementation HXSActionSheet

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    _items = [NSMutableArray array];
    
    _grayBackgroundView = [[UIView alloc] init];
    _grayBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:_grayBackgroundView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTap.numberOfTouchesRequired = 1;
    singleTap.numberOfTapsRequired = 1;
    [_grayBackgroundView addGestureRecognizer:singleTap];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 3.0;
    _tableView.separatorColor = [UIColor colorWithRGBHex:0xE1E2E3];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXSActionSheet" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    [_tableView registerNib:[UINib nibWithNibName:@"HXSActionSheetCell" bundle:bundle] forCellReuseIdentifier:HXSActionSheetCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"HXSActionSheetCellNormal" bundle:bundle] forCellReuseIdentifier:HXSActionSheetCellNormalIdentify];
    
    [self addSubview:_tableView];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _grayBackgroundView.frame = self.bounds;
    
    CGFloat padding = 10.0;
    CGFloat tableHeight = (_items.count > 5) ? 220.0 : _items.count *44 + (_message.length > 0)*44.0;
    
    CGFloat height = (_cancelTitle.length > 0) ? tableHeight + padding *2 + 44.0 : tableHeight + padding;

    _tableView.frame = CGRectMake(padding, self.height - height, self.width - 2*padding, tableHeight);
    _tableView.scrollEnabled = (_items.count > 5);
    
    _cancelButton.frame = CGRectMake(padding, _tableView.bottom + padding, self.width - 2*padding, 44.0);
}

#pragma mark - Getter/Setter

- (void)setCancelTitle:(NSString *)cancelTitle
{
    if (cancelTitle.length < 1) {
        return;
    }
    
    _cancelTitle = cancelTitle;
    
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 3.0;
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        
        UIColor *titleColor = [UIColor colorWithRGBHex:0x666666];
        [_cancelButton setTitleColor: titleColor forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor highlightedColorFromColor:titleColor] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_cancelButton];
    }
    
    [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
}

#pragma mark - Public Method

- (void)addAction:(HXSAction *)action
{
    if (![_items containsObject:action]) {
        
        HXSActionSheetEntity *methodsEntity = action.methodsEntity;
        if (![HXSWXApiManager sharedManager].isWechatInstalled
            && ([methodsEntity.payTypeIntNum intValue] == kHXSOrderPayTypeWechatApp)) {
            return;
        }
        
        [_items  addObject:action];
    }
}

+ (instancetype)actionSheetWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle
{
    HXSActionSheet *actionSheet = [[HXSActionSheet alloc] initWithFrame:CGRectZero];
    actionSheet.message = message;
    actionSheet.cancelTitle = cancelTitle;

    return actionSheet;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.frame = window.bounds;
    [window addSubview:self];
    
    CGFloat padding = 10.0;
    CGFloat tableHeight = (_items.count > 5) ? 220.0 : _items.count *44 + (_message.length > 0)*44.0;
    CGFloat height = (_cancelTitle.length > 0) ? tableHeight + padding *2 + 44.0 : tableHeight + padding;
    
    _tableView.frame = CGRectMake(padding, window.height, window.width - 2*padding, tableHeight);
    _cancelButton.frame = CGRectMake(padding, _tableView.bottom + padding, window.width - 2*padding, 44.0);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         _tableView.frame = CGRectMake(padding, window.height - height, window.width - 2*padding, tableHeight);
                         _cancelButton.frame = CGRectMake(padding, _tableView.bottom + padding, window.width - 2*padding, 44.0);
                     } completion:nil];
}

#pragma mark - Private Method

- (void)hide
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGFloat padding = 10.0;
    CGFloat tableHeight = (_items.count > 5) ? 220.0 : _items.count *44 + (_message.length > 0)*44.0;
    
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(padding, window.height, window.width - 2*padding, tableHeight);
        _cancelButton.frame = CGRectMake(padding, _tableView.bottom + padding, window.width - 2*padding, 44.0);
    } completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}


#pragma mark - Target/Action

- (void)cancelButtonPressed
{
    [self hide];
}

- (void)singleTap
{
    [self hide];
}


#pragma mark - UITableViewDataSource/UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_message.length < 1) {
        return 0.1;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_message.length < 1) {
        return nil;
    }
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = _message;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRGBHex:0x999999];
    label.font = [UIFont systemFontOfSize:14.0];
    label.frame = CGRectMake(0, 0, tableView.width, 44.0);
    
    [header addSubview:label];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    HXSAction *action = [_items objectAtIndex:indexPath.row];
    
    if (0 < [action.methodsEntity.iconURLStr length]) {
        HXSActionSheetCell *sheetCell = [tableView dequeueReusableCellWithIdentifier:HXSActionSheetCellIdentify];
        
        [sheetCell setupWithEntity:action.methodsEntity];
        
        cell = sheetCell;
    } else {
        HXSActionSheetCellNormal *sheetCell = [tableView dequeueReusableCellWithIdentifier:HXSActionSheetCellNormalIdentify];
        
        sheetCell.sheetTitleLabel.text = action.methodsEntity.nameStr;
        
        cell = sheetCell;
    }
    
    
    
    if (indexPath.row == (_items.count - 1)) {
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.width/2.0, 0, tableView.width/2.0);
    }
    else {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (indexPath.row >= 0 && indexPath.row < _items.count) {
        HXSAction *action = _items[indexPath.row];
        
        [self hide];
        
        action.handler(action);
    }
}

@end
