//
//  kkkMM.m
//  masony
//
//  Created by  黎明 on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HXSBoxMenu.h"
#import "HXSBoxMenuCellTableViewCell.h"


//三角形高度【正三角】
CGFloat const TriangleHeight = 7;
CGFloat const TrianglePostionX = 30;
CGFloat const itemHeight = 45.0f;
CGFloat const cellHeight = 43.0f;
CGFloat const radius = 2.0f;



@interface HXSBoxMenu()
@property (nonatomic, strong) NSArray<UIImage *> *itemIconArray;
@property (nonatomic, strong) NSArray<NSString *> *itemTitleArray;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation HXSBoxMenu


+ (instancetype)initWithItemArray:(NSArray<UIImage *> *)itemIconArray
                       itemTitles:(NSArray<NSString *> *)itemTitleArray
                            frame:(CGRect)frame
{
    CGFloat height = itemTitleArray.count * itemHeight;
    frame.size.height = height;
    
    HXSBoxMenu *boxMenu = [[HXSBoxMenu alloc] initWithFrame:frame];
    boxMenu.itemIconArray = itemIconArray;
    boxMenu.itemTitleArray = itemTitleArray;
    return boxMenu;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubView];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.7f);
}

-(void)drawInContext:(CGContextRef)context
{
    [self getSuDrawPath:context];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
}

- (void)getSuDrawPath:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat midy = CGRectGetMidY(rect);
    
    CGContextMoveToPoint(context, midx + TrianglePostionX, miny+TriangleHeight);
    CGContextAddLineToPoint(context, midx + TrianglePostionX+TriangleHeight, miny);
    CGContextAddLineToPoint(context, midx + TrianglePostionX+2*TriangleHeight, miny+TriangleHeight);
    CGContextAddArcToPoint(context, maxx, miny+TriangleHeight, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextAddArcToPoint(context, minx, miny+TriangleHeight,midx,miny+TriangleHeight, radius);
    
    CGContextClosePath(context);
}

- (void)setupSubView
{
    UITableView *tableView = [[UITableView alloc]
                              initWithFrame:CGRectMake(0, 10, self.bounds.size.width,
                                                                           self.bounds.size.height-12)
                              style:UITableViewStylePlain];
    
    tableView.showsVerticalScrollIndicator = NO;
    
    tableView.dataSource      = self;
    tableView.delegate        = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.center          = CGPointMake(CGRectGetWidth(self.bounds)/2, tableView.center.y);
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    [tableView registerNib:[UINib nibWithNibName:@"HXSBoxMenuCellTableViewCell"
                                          bundle:[NSBundle mainBundle]]
    forCellReuseIdentifier:@"HXSBoxMenuCellTableViewCell"];
    
    [self addSubview:tableView];
    [self setNeedsDisplay];
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.bgView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
}

- (void)touchesbgViewAction:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    [view removeFromSuperview];
    [self dismiss];
}


- (void)dismiss
{
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        self.alpha = 1.0f;
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}




#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    HXSBoxMenuCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXSBoxMenuCellTableViewCell"
                                                                        forIndexPath:indexPath];
    cell.backgroundColor     = [UIColor clearColor];
    cell.titleLabel.text     = self.itemTitleArray[row];
    cell.iconImageView.image = self.itemIconArray[row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"%zd",indexPath.row);
    [self dismiss];

    if (self.delegate&&[self.delegate respondsToSelector:@selector(boxMenuItemClickAction:)]) {
        [self.delegate performSelector:@selector(boxMenuItemClickAction:) withObject:indexPath];
    }
}


#pragma mark - GET

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(touchesbgViewAction:)];
        [_bgView addGestureRecognizer:tapGestureRecognizer];
    }
    return _bgView;
}

@end
