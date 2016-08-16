//
//  HXSFloatingCartView.m
//  store
//
//  Created by chsasaw on 14/11/20.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSFloatingCartView.h"

#import "HXSDormCartTableViewCell.h"
#import "HXSHorizontalLine.h"

#define CART_TOOLBAR_HEIGHT              50
#define TABLE_VIEW_CELL_HEIGHT           74
#define NAVIGATION_AND_STATUS_BAR_HEIGHT 64

@interface HXSFloatingCartView() <UIGestureRecognizerDelegate,
                                  UITableViewDataSource,
                                  UITableViewDelegate,
                                  HXSDormCartTableViewCellDelegate>

@property (nonatomic, strong) UIView                 *contentView;
@property (nonatomic, strong) UIToolbar              *toolbar;
@property (nonatomic, strong) UIView                 *line;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView                 *bgView;
@property (nonatomic, strong) UITableView            *tableView;
@property (nonatomic, strong) UIButton               *cartButton;
@property (nonatomic, strong) UILabel                *emptyLabel;

@end

@implementation HXSFloatingCartView

#pragma mark - View Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.isAnimating = NO;
        
        [self initViewLayout];
        
        [self initNotification];
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        self.tap.numberOfTapsRequired = 1;
        self.tap.numberOfTouchesRequired = 1;
        self.tap.delegate = self;
        [self addGestureRecognizer:self.tap];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.itemsArray       = nil;
    self.cartViewDelegate = nil;
}

#pragma mark - Property Get & Set Methods

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self updateFrameToDisplay:YES animation:YES];
}

#pragma mark - Public Methods

+ (id)viewWithFrame:(CGRect)frame
{
    HXSFloatingCartView * customView = [[HXSFloatingCartView alloc] initWithFrame:frame];
    
    return customView;
}

- (void)show
{
    // Load cart at begining
    [self cartRefreshed:nil];
    
    self.userInteractionEnabled = YES;
    
    UIView * parentView = nil;
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    if (parentView == nil) {
        parentView = keyWindow;
    }
    if (parentView == nil) {
        parentView = [UIApplication sharedApplication].windows[0];
    }
    [parentView addSubview:self];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.layer removeAllAnimations];
    
    [self updateFrameToDisplay:YES animation:YES];
}

- (void)hide:(BOOL)animation
{
    self.isAnimating = YES;
    
    [self.layer removeAllAnimations];
    
    if(animation) {
        [self updateFrameToDisplay:NO animation:YES];
    }else {
        [self removeFromSuperview];
    }
}

#pragma mark - Initial Methods

- (void)initViewLayout
{
    // Background View
    self.bgView = [[UIView alloc] init];
    
    self.bgView.backgroundColor = [UIColor colorWithWhite:.0f alpha:.3f]; // alpha改成0.3看起来没有那么“闪”
    self.bgView.frame = self.bounds;
    self.bgView.alpha = 0;
    [self addSubview:self.bgView];
    self.bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    // Content View
    self.contentView = [[UIView alloc] init];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    // Tool Bar
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height, SCREEN_WIDTH, CART_TOOLBAR_HEIGHT)];
    self.toolbar.barStyle = UIBarStyleDefault;
    self.toolbar.translucent = NO;
    self.toolbar.tintColor = HXS_TEXT_COLOR;
    [self.toolbar sizeToFit];
    [self.contentView addSubview:self.toolbar];
    
    self.line = [[HXSHorizontalLine alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolbar.frame) - HXS_LINE_WIDTH, self.contentView.frame.size.width, HXS_LINE_WIDTH)];
    [self.contentView addSubview:self.line];
    
    UIBarButtonItem *margin = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    margin.width = 15;
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexible.width = 15;
    
    // Cart Button
    self.cartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, CART_TOOLBAR_HEIGHT)];
    [self.cartButton setTitle:@"购物车" forState:UIControlStateNormal];
    [self.cartButton setTitleColor:[UIColor colorWithR:0 G:0 B:0 A:0.4] forState:UIControlStateNormal];
    [self.cartButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.cartButton setBackgroundColor:[UIColor clearColor]];
    [self.cartButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.cartButton addTarget:self action:@selector(btnDoneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cartBtn = [[UIBarButtonItem alloc] initWithCustomView:self.cartButton];
    
    
    UIBarButtonItem* flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton * dumprubbishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dumprubbishButton setTitle:@"清空购物车" forState:UIControlStateNormal];
    [dumprubbishButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [dumprubbishButton setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
    [dumprubbishButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [dumprubbishButton addTarget:self action:@selector(clearCart) forControlEvents:UIControlEventTouchUpInside];
    [dumprubbishButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    CGSize size = [dumprubbishButton sizeThatFits:CGSizeMake(SCREEN_WIDTH, CART_TOOLBAR_HEIGHT)];
    [dumprubbishButton setFrame:CGRectMake(0, 0, size.width + 30, CART_TOOLBAR_HEIGHT)];
    UIBarButtonItem *btnClear = [[UIBarButtonItem alloc] initWithCustomView:dumprubbishButton];

    
    NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:flexible, cartBtn, flexible2, btnClear, margin, nil];
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        arrBarButtoniTems = [[NSArray alloc] initWithObjects:flexible, cartBtn, flexible2, btnClear, nil];
    }
    
    [self.toolbar setItems:arrBarButtoniTems];
    
    // Table View
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.contentView addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSDormCartTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HXSDormCartTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 55;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorFromRGB(0xF1F2F2);
    
    // Emtpy Label
    self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
    [self.emptyLabel setText:@"购物车空空如也"];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyLabel setTextColor:HXS_TEXT_COLOR];
    [self.tableView addSubview:self.emptyLabel];
    
    // set frame
    [self updateFrameToDisplay:YES animation:NO];
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartRefreshed:) name:kUpdateDormCartComplete object:nil];
    
    // 便利店购物车更新时用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartRefreshed:) name:kStoreCartDidUpdated object:nil];
}

#pragma mark - Target Methods

- (void)cartRefreshed:(NSNotification *)noti
{    
    [self.tableView reloadData];
    
    if (self.itemsArray && self.itemsArray.count > 0) {
        self.emptyLabel.hidden = YES;
    } else {
        self.emptyLabel.hidden = NO;
    }
    
    if (0 < [self.itemsArray count]) {
        [self updateFrameToDisplay:YES animation:YES];
    } else {
        [self updateFrameToDisplay:NO animation:NO];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.tap) {
        CGPoint point = [gestureRecognizer locationInView:self];
        if (point.y < self.contentView.frame.origin.y) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    if (point.y < self.contentView.frame.origin.y) {
        [self hide:YES];
    }
}

-(void)btnDoneClick
{
    [self hide:YES];
}

- (void)clearCart
{
    [self.superview sendSubviewToBack:self];
    
    __weak typeof(self) weakSelf = self;
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"清空购物车"
                                                                      message:@"您确定不要这些东西了吗？"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"清空"];
    alertView.leftBtnBlock = ^(){
        [weakSelf.superview bringSubviewToFront:self];
    };
    
    alertView.rightBtnBlock = ^{
        [self.cartViewDelegate clearCart];
        
        [weakSelf hide:NO];
    };
    
    [alertView show];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_VIEW_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDormCartTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HXSDormCartTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.itemsArray.count) {
        HXSFloatingCartEntity * item = [self.itemsArray objectAtIndex:indexPath.row];
        cell.cartCellDelegate = self;
        
        [cell setCartItem:item];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing
        && (indexPath.row < self.itemsArray.count)
        && (editingStyle == UITableViewCellEditingStyleDelete)) {
        
        NSInteger currentCount = [self.itemsArray count];
        HXSFloatingCartEntity *item = [self.itemsArray objectAtIndex:indexPath.row];
        
        [MobClick event:@"dorm_remove_cart" attributes:@{@"item_id":item.itemIDNum}];
        
        [self.cartViewDelegate updateItem:item.itemIDNum quantity:[NSNumber numberWithInt:0]];
        
//        [self.itemsArray removeObjectAtIndex:indexPath.row]; // 无需删除了否则会重复删除，此时itemsArray，已经被更新了
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        currentCount--;
        if (0 < currentCount) {
            [self updateFrameToDisplay:YES animation:YES];
        } else {
            [self updateFrameToDisplay:NO animation:NO];
        }
        
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark - HXSDormCartTableViewCellDelegate

- (void)dormCartCell:(HXSDormCartTableViewCell *)cell
          udpateItem:(NSNumber *)itemIDNum
            quantity:(NSNumber *)quantityNum
{
    [self.cartViewDelegate updateItem:itemIDNum quantity:quantityNum];
}


- (void)dormCartCell:(HXSDormCartTableViewCell *)cell
       udpateProduct:(NSString *)productIDStr
            quantity:(NSNumber *)quantityNum
{
    [self.cartViewDelegate updateProduct:productIDStr quantity:quantityNum];
}

#pragma mark - Update Frame

- (void)updateFrameToDisplay:(BOOL)toDispaly animation:(BOOL)isAnimation
{
    CGFloat maxHeightOfTableView = self.height - CART_TOOLBAR_HEIGHT - NAVIGATION_AND_STATUS_BAR_HEIGHT;
    CGFloat heightOfTableView = MIN(maxHeightOfTableView, [self.itemsArray count] * TABLE_VIEW_CELL_HEIGHT);
    
    if (toDispaly) {
        if (isAnimation) {
            self.isAnimating = YES;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.bgView.alpha = 1.0f;
                [self setupContentViewFrameToShowWithTableViewHeight:heightOfTableView];
                
            } completion:^(BOOL finished) {
                
                self.isAnimating = NO;
                
            }];
        } else {
            [self setupContentViewFrameToShowWithTableViewHeight:heightOfTableView];
        }
    } else {
        if (isAnimation) {
            [UIView animateWithDuration:0.3 animations:^{
                
                self.bgView.alpha = .0f;
                
                [self setupContentViewFrameToHiddenWithTableViewHeight:heightOfTableView];
                
            } completion:^(BOOL finished) {
                
                self.isAnimating = NO;
                
                [self removeFromSuperview];
                
            }];
        } else {
            [self setupContentViewFrameToHiddenWithTableViewHeight:heightOfTableView];
            
            [self removeFromSuperview];
        }
        
    }
    
}

- (void)setupContentViewFrameToShowWithTableViewHeight:(CGFloat)height
{
    [self.contentView setFrame:CGRectMake(0, self.height - CART_TOOLBAR_HEIGHT - height, SCREEN_WIDTH, CART_TOOLBAR_HEIGHT + height)];
    [self.tableView setFrame:CGRectMake(0, CART_TOOLBAR_HEIGHT, SCREEN_WIDTH, height)];
    [self.toolbar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CART_TOOLBAR_HEIGHT)];
    [self.line setFrame:CGRectMake(0, CART_TOOLBAR_HEIGHT - 1, SCREEN_WIDTH, 1)];
}

- (void)setupContentViewFrameToHiddenWithTableViewHeight:(CGFloat)height
{
    [self.contentView setFrame:CGRectMake(0, self.height - CART_TOOLBAR_HEIGHT - height, SCREEN_WIDTH, CART_TOOLBAR_HEIGHT + height)];
    [self.tableView setFrame:CGRectMake(0, self.contentView.frame.size.height+CART_TOOLBAR_HEIGHT, SCREEN_WIDTH, height)];
    [self.toolbar setFrame:CGRectMake(0, self.contentView.frame.size.height, SCREEN_WIDTH, CART_TOOLBAR_HEIGHT)];
    [self.line setFrame:CGRectMake(0, self.contentView.frame.size.height + CART_TOOLBAR_HEIGHT - 1, SCREEN_WIDTH, 1)];
}





@end
