//
//  HXSShopCategoryToolView.m
//  store
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopCategoryToolView.h"

// Controllers
#import "HXSCategoryListViewController.h"

// Views
#import "HXSLocationCustomButton.h"

// Others
#import "HXSCategoryRequest.h"
#import "HXSLocationCustomButton+HXSPullButton.h"


static NSInteger const kScrollTabbarSideButtonWidth = 15;
static NSInteger const kScrollTabbarLeftMargin      = 8;
#define SCROLL_TABBAR_BAR_WIDTH  ((SCREEN_WIDTH - kScrollTabbarSideButtonWidth*2)/4)  // 4 is setup the

@interface HXSShopCategoryToolView()

@property (nonatomic, strong) HXSCategoryListViewController *categoryListViewController;
@property (nonatomic, strong) NSDictionary *categoryItems;
@property (nonatomic, strong) UIScrollView *scrollView;

//工具按钮数组
@property (nonatomic, strong) NSMutableArray *tabItems;
@property (nonatomic, assign) BOOL  isShowList;
@property (nonatomic, assign) NSInteger currentSelectIndex;
@property (nonatomic, assign) NSInteger lastSelectIndex;

@end


@implementation HXSShopCategoryToolView

#pragma mark - life

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if(self) {
        self.isShowList = NO;
        
        [self setBackgroundColor:[UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1]];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.isShowList = NO;
        
        [self setBackgroundColor:[UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.scrollView.frame = CGRectMake(5, 0,
                                       CGRectGetWidth(self.frame) - kScrollTabbarSideButtonWidth*2,
                                       CGRectGetHeight(self.frame));
}

- (void)dealloc{

    self.scrollView                     = nil;
    self.categoryListViewController     = nil;
    self.categoryItems                  = nil;
    self.tabItems                       = nil;
}

//没有选择分类列表而隐藏列表，
- (void)unSelectAllCategoryItem
{
    [self setButtonSelected:self.lastSelectIndex];
}


#pragma mark - 懒加载

- (HXSCategoryListViewController *)categoryListViewController
{
    if (nil == _categoryListViewController) {
        _categoryListViewController = [HXSCategoryListViewController controllerFromXib];
        if ([self.categoryItems.allKeys containsObject:@"categories"]) {
            [_categoryListViewController setCategoryItems:self.categoryItems[@"categories"]];
            __weak typeof (self) weakSelf = self;
            
            [_categoryListViewController setDismissBlock:^(NSInteger selectIndex, HXSCategoryModel *model) {
                
                [weakSelf endingSelectCategoryCallBack:selectIndex categroyModel:model];
            }];
            
            [_categoryListViewController setUnSelectBlock:^{
                [weakSelf unSelectAllCategoryItem];
            }];
        }
    }
    return _categoryListViewController;
}

- (NSMutableArray *)tabItems
{
    if (nil == _tabItems) {
        
        _tabItems = [NSMutableArray array];
    }
    return _tabItems;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {

        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 0,
                                                                    CGRectGetWidth(self.frame) - kScrollTabbarSideButtonWidth*2,
                                                                    CGRectGetHeight(self.frame))];

        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
}

- (void)endingSelectCategoryCallBack:(NSInteger)selectIndex categroyModel:(HXSCategoryModel *)model
{
    self.isShowList = NO;
    
    if (selectIndex != -1) {
        
        [self.tabItems replaceObjectAtIndex:0 withObject:self.categoryItems[@"categories"][selectIndex]];
        
        if(self.selectCategoryType) {
            
            self.selectCategoryType(model);
        }
    }
    
    //更新按钮箭头方向
    for (UIView *subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *subButton = (UIButton *)subview;
            if (subButton.tag == 0) {
                [UIView animateWithDuration:0.5 animations:^{
                    [subButton.imageView setTransform:CGAffineTransformMakeRotation(- 2 *M_PI)];
                }];
            }
        }
    }
    
    [self updateButtonTitle];
}


#pragma mark - UI&Action

/**
 *  初始化子控件
 */
- (void)setupSubViews
{
    [self addSubview:self.scrollView];
    
    if ([self.categoryItems.allKeys containsObject:@"recommended_categories"]) {
        [self.tabItems addObjectsFromArray:self.categoryItems[@"recommended_categories"]];
    }
    
    if ([self.categoryItems.allKeys containsObject:@"categories"]) {
        [self.tabItems insertObject:[self.categoryItems[@"categories"] firstObject] atIndex:0];
    }
    
    [self.scrollView setContentSize:CGSizeMake((SCROLL_TABBAR_BAR_WIDTH + kScrollTabbarSideButtonWidth) * self.tabItems.count, CGRectGetHeight(self.bounds))];
    
    for (int index = 0 ; index<self.tabItems.count; index++) {
        
        HXSCategoryModel *categoryModel = self.tabItems[index];
        NSString *titleStr = categoryModel.categoryName;
        HXSLocationCustomButton *button = [HXSLocationCustomButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitleColor:UIColorFromRGB(0x6F5F61) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x00A3FA) forState:UIControlStateSelected];
        
        if (index == 0) {
            button.selected = YES;
            UIImage *downImageHighlighted   = [UIImage imageNamed:@"ic_classify_downarrow"];
            UIImage *downImageSelected      = [UIImage imageNamed:@"ic_classify_downarrow"];
            UIImage *downImageNormal        = [UIImage imageNamed:@"ic_downcontent"];

            [button setImage:downImageNormal forState:UIControlStateNormal];
            [button setImage:downImageSelected forState:UIControlStateSelected];
            [button setImage:downImageHighlighted forState:UIControlStateHighlighted];
        }
        
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(onClickTabButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        button.frame = CGRectMake((SCROLL_TABBAR_BAR_WIDTH + 15) * index + kScrollTabbarLeftMargin, 0,
                                  SCROLL_TABBAR_BAR_WIDTH+15, CGRectGetHeight(self.bounds));
        
        [self.scrollView addSubview:button];
    }
}

/**
 *  跟新分类选择的按钮标题
 */
- (void)updateButtonTitle
{
    for (UIView *subview in self.scrollView.subviews) {

        if ([subview isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)subview;

            if (button.tag == 0) {
                
                HXSCategoryModel *categorymodel = self.tabItems[button.tag];

                NSString *titleStr = categorymodel.categoryName;
                
                [button setTitle:titleStr forState:UIControlStateNormal];
                
                button.frame = CGRectMake(kScrollTabbarSideButtonWidth - kScrollTabbarLeftMargin,
                                          0,SCROLL_TABBAR_BAR_WIDTH + 15, CGRectGetHeight(self.bounds));
            }
        }
        
    }
}

/**
 *  按钮点击事件
 *
 *  @param sender button
 */
- (void)onClickTabButton:(UIButton *)sender
{
    [self setButtonSelected:sender.tag];
    if (sender.tag == 0) {
        
        [UIView animateWithDuration:.5 animations:^{
            sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, M_PI);
        }];
        
        if (self.isShowList) {
            [self dismissView];
        } else {
            [self showListViewController];
        }
    } else {
        self.isShowList = NO;
        if (self.selectCategoryType) {
            
            HXSCategoryModel *model = (HXSCategoryModel *)(self.tabItems[sender.tag]);
            self.selectCategoryType(model);
        }
    }
}

/**
 *  显示分类列表
 */
- (void)showListViewController
{
    self.isShowList = YES;
    
    UIViewController *currentViewController = [self activityViewController];
    
    [currentViewController addChildViewController:self.categoryListViewController];
    
    [currentViewController.view addSubview:self.categoryListViewController.view];
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];

    CGRect rect = [self convertRect: self.bounds toView:window];

    [self.categoryListViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(currentViewController.view).with.insets(UIEdgeInsetsMake(CGRectGetMaxY(rect) - 64, 0, 0, 0));
    }];
    
    [self.categoryListViewController didMoveToParentViewController:currentViewController];
}

/**
 *   获取当前处于activity状态的view controller
 *
 *  @return
 */
- (UIViewController *)activityViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {

        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
        
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

/**
 *  设置当前按钮状态
 *
 *  @param tag button.tag
 */
- (void)setButtonSelected:(NSInteger)tag
{
    
    if (self.currentSelectIndex == tag) {
        return;
    } else {
        self.lastSelectIndex = self.currentSelectIndex;
    }
    
    self.currentSelectIndex = tag;
    
    for (UIView *subview in self.scrollView.subviews) {

        if ([subview isKindOfClass:[UIButton class]]) {
        
            UIButton *subButton = (UIButton *)subview;
            
            if (tag == subButton.tag) {
            
                subButton.selected = YES;
                
                if (tag == 0) {
                
                    if (self.isShowList) {
                        
                        [self.categoryListViewController dismissView: -1];
                        
                        self.isShowList = NO;
                    }
                }
            } else {
                subButton.selected = NO;
                
                if (subButton.tag == 0) {
                    
                    [self.categoryListViewController dismissView: -1];
                    
                    self.isShowList = NO;
                    
                    [UIView animateWithDuration:0.5 animations:^{
                    
                        CGAffineTransform basicAnimation = CGAffineTransformMakeRotation(-2*M_PI);
                        
                        [subButton.imageView setTransform:basicAnimation];
                    }];
                }
            }
        }
    }
}

- (void)dismissView{

    [self.categoryListViewController dismissView: -1];
    self.isShowList = NO;

}


- (void)getCategoryItemsWith:(HXSShopEntity *)shopModel
                    complete:(void (^)(HXSCategoryModel *))completeBlock
{
    [self.tabItems removeAllObjects];
    
    if (self.scrollView.subviews.count != 0) {

        for(UIView *view in self.scrollView.subviews){

            [view removeFromSuperview];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [HXSCategoryRequest getCategoryListWith:shopModel.shopIDIntNum
                                   shopType:shopModel.shopTypeIntNum
                                   complete:^(HXSErrorCode status, NSString *message, NSDictionary *resultDict) {

                                       if (status == kHXSNoError) {
                                           
                                           weakSelf.categoryItems = resultDict;
                                       
                                           [weakSelf setupSubViews];
                                           
                                           HXSCategoryModel *categoryModel = self.tabItems[0];
                                           
                                           completeBlock(categoryModel);
                                       }
    }];
}

- (void)setIsShowList:(BOOL)isShowList
{
    _isShowList = isShowList;
    
}


@end
