//
//  HXSStoreAppEntryTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSStoreAppEntryTableViewCell.h"

#import "HXSStoreAppEntryEntity.h"
#import "HXSPageControl.h"


#define HEIGHT_ENTRY_IMAGE     40
#define NUMBER_ICONS_DEFAULT   4
#define PADDING_LEFT_AND_RIGHT 21

#define TAG_BASIC            100

@interface HXSStoreAppEntryTableViewCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet HXSPageControl *pageControl;

@property (nonatomic, strong) NSArray *entriesArr;
@property (nonatomic, assign) id<HXSStoreAppEntryTableViewCellDelegate> delegate;

@end

@implementation HXSStoreAppEntryTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Public Methods

- (void)setupCellWithStoreAppEntriesArr:(NSArray *)entriesArr delegate:(id<HXSStoreAppEntryTableViewCellDelegate>)delegate
{
    self.entriesArr = entriesArr;
    self.delegate   = delegate;
    
    self.scrollView.delegate = self;
    
    for (UIView *view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    NSInteger middlePaddingNum = NUMBER_ICONS_DEFAULT - 1;
    NSInteger middleTotalPadding = SCREEN_WIDTH - NUMBER_ICONS_DEFAULT * HEIGHT_ENTRY_IMAGE - 2 * PADDING_LEFT_AND_RIGHT;
    CGFloat paddingWidth = floor(middleTotalPadding / middlePaddingNum);
    UIView *lastView = nil;
    
    for (int i = 0; i < [entriesArr count]; i++) {
        UIView *view = [self createEntryViewAtIndex:i];
        
        if (nil == lastView) {
            [self.scrollView addSubview:view];
            
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.mas_left).with.offset(PADDING_LEFT_AND_RIGHT);
                make.top.bottom.equalTo(self.scrollView);
            }];
            
            lastView = view;
        } else {
            [self.scrollView addSubview:view];
            
            CGFloat offset = 0.0;
            if (0 == (i % NUMBER_ICONS_DEFAULT)) { // the first one at the second page
                offset = PADDING_LEFT_AND_RIGHT;
            } else {
                offset = paddingWidth;
            }
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).with.offset(offset);
                make.top.bottom.equalTo(self.scrollView);
            }];
            
            lastView = view;
        }
        
        if (0 == ((i + 1) % NUMBER_ICONS_DEFAULT)) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            
            [self.scrollView addSubview:label];
            
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
                make.left.equalTo(lastView.mas_right).with.offset(PADDING_LEFT_AND_RIGHT);
                make.top.bottom.equalTo(self.scrollView);
            }];
            
            lastView = label;
        }
        
        if (i == ([entriesArr count] - 1)) {
            // Set the right padding to scroll view
            int pages = ceil((float)[entriesArr count] / NUMBER_ICONS_DEFAULT);
            CGFloat paddingToRight = (pages * SCREEN_WIDTH) - CGRectGetMaxX(lastView.frame);
            
            [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.scrollView.mas_right).with.offset(-paddingToRight);
            }];
            
            [self.scrollView layoutIfNeeded];
        }
        
        [self.scrollView layoutIfNeeded];
    }
    
    int pages = ceil((float)[entriesArr count] / NUMBER_ICONS_DEFAULT);
    self.scrollView.contentSize = CGSizeMake(pages * SCREEN_WIDTH, kHeightEntryCell);
    
    [self.pageControl updateImages:@[[UIImage imageNamed:@"ic_square_selected"],
                                     [UIImage imageNamed:@"ic_square_normal"]]];
    [self.pageControl setNumberOfPages:pages];
    [self.pageControl setCurrentPage:0];
}


#pragma mark - Create Entry View

- (UIView *)createEntryViewAtIndex:(int)index
{
    // view
    UIView *view = [[UIView alloc] init];
    view.tag = index + TAG_BASIC;
    [view setUserInteractionEnabled:YES];
    
    // icon image
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [view addSubview:imageView];
    
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).with.offset(15);
        make.size.mas_equalTo(HEIGHT_ENTRY_IMAGE);
        make.left.right.equalTo(view);
    }];
    
    // title label
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [label setTextColor:UIColorFromRGB(0x333333)];
    
    [view addSubview:label];
    
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(13);
        make.bottom.equalTo(view.mas_bottom).with.offset(-22);
    }];
    
    if(index < self.entriesArr.count) {
        HXSStoreAppEntryEntity *entryEntity = [self.entriesArr objectAtIndex:index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:entryEntity.imageURLStr]
                     placeholderImage:[UIImage imageNamed:@"ic_headhome_defaulticon_loading"]];
        [label setText:entryEntity.titleStr];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onClickEntry:)];
        [view addGestureRecognizer:tap];
    }
    
    return view;
}


#pragma mark 0 Target Methods

- (void)onClickEntry:(UIGestureRecognizer *)gesture
{
    [gesture.view setUserInteractionEnabled:NO];
    
    NSInteger index = gesture.view.tag - TAG_BASIC;
    if(index < self.entriesArr.count) {
        HXSStoreAppEntryEntity *entity = [self.entriesArr objectAtIndex:index];
        
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(storeAppEntryTableViewCell:didSelectedLink:)]) {
            [self.delegate storeAppEntryTableViewCell:self
                                      didSelectedLink:entity.linkURLStr];
        }
    }
    
    [gesture.view setUserInteractionEnabled:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (0 > scrollView.contentOffset.x) {
        return;
    }
    
    int page = (scrollView.contentOffset.x + 50) / scrollView.width;
    
    [self.pageControl setCurrentPage:page];
}

@end
