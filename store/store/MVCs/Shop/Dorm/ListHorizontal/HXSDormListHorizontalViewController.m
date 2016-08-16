//
//  HXSDormListHorizontalViewController.m
//  store
//
//  Created by ArthurWang on 15/11/3.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSDormListHorizontalViewController.h"

// Controllers
#import "HXSWebViewController.h"

// Model
#import "HXSShop.h"
#import "HXSDormItemList.h"
#import "HXSDormCategory.h"
#import "HXSDormCartManager.h"
#import "HXSShopEntity.h"

// Views
#import "HXSDormItemTableViewCell.h"
#import "HXSDormItemMaskView.h"

static NSString *DormItemTableViewCell           = @"HXSDormItemTableViewCell";
static NSString *DormItemTableViewCellIdentifier = @"HXSDormItemTableViewCell";

static CGFloat const kHeightCell             = 100.0f;
static NSString * const kDormCartUpdateRid   = @"rid";
static NSString * const kDormCartUpdateCount = @"count";

@interface HXSDormListHorizontalViewController () <UITableViewDataSource,
                                                   UITableViewDelegate,
                                                   HXSDormItemTableViewCellDelegate,
                                                   HXSFoodieItemPopViewDelegate>

@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, assign) BOOL    autoScrolling;

@property (nonatomic, strong) NSMutableArray *requestParamMArr;

@end

@implementation HXSDormListHorizontalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lastPosition  = 0;
    self.autoScrolling = NO;

    [self initialTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.itemList     = nil;
    self.listDelegate = nil;
}


#pragma mark - Public Methods

- (void)reloadDataShouldAnimation:(BOOL)animation
{
    if (animation) {
        [HXSLoadingView showLoadingInView:self.view];
        
        [self.listDelegate reloadItemList];
    } else {
        [self.tableView endRefreshing];
        [HXSLoadingView closeInView:self.view];
        
        [self.tableView reloadData];
    }
}

- (void)stopReloadData
{
    [self.tableView endRefreshing];
    [HXSLoadingView closeInView:self.view];
}

- (void)scrollToAssignRowWhenClickIndex:(int)index
{
    NSInteger sectionCount = [self.tableView numberOfSections];
    
    if (sectionCount > index) {
        NSInteger rowCount = [self.tableView numberOfRowsInSection:index];
        if (rowCount > 0) {
            int i = index;
            int section = [self.itemList visibleToAct:i];
            
            if (section >= 0 && section < sectionCount) {
                NSInteger rows = [self.tableView numberOfRowsInSection:section];
                if (rows > 0) {
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                    self.autoScrolling = YES;
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                    __weak typeof(self) weakSelf = self;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        weakSelf.autoScrolling = NO;
                    });
                }
            }
        }
    }

}


#pragma mark - Initial Methods

- (void)initialTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:DormItemTableViewCell bundle:nil]
         forCellReuseIdentifier:DormItemTableViewCellIdentifier];
    
    self.tableView.layer.masksToBounds = NO;
    
    __weak typeof (self) weakSelf = self;
    
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf.listDelegate reloadItemList];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreItems];
    }];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Target Methods

- (void)addUpdateDormCartRequestWithParam:(NSDictionary *)paramDic
{
    NSNumber *ridNum = [paramDic objectForKey:kDormCartUpdateRid];
    
    for (NSTimer *timer in self.requestParamMArr) {
        NSDictionary *tempParamDic = (NSDictionary *)(timer.userInfo);
        NSNumber *tempRidNum = [tempParamDic objectForKey:kDormCartUpdateRid];
        if ([tempRidNum integerValue] == [ridNum integerValue]) {
            [timer invalidate];
            [self.requestParamMArr removeObject:timer];
            
            break;
        }
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(updateDormCartInfoWithParam:)
                                                    userInfo:paramDic
                                                     repeats:NO];
    
    [self.requestParamMArr addObject:timer];
    
}

- (void)updateDormCartInfoWithParam:(NSTimer *)timer
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)(timer.userInfo)];
    
    NSNumber *currentRid = [paramDic objectForKey:kDormCartUpdateRid];
    
    for (NSTimer *timer in self.requestParamMArr) {
        NSDictionary *tempParamDic = (NSDictionary *)timer.userInfo;
        NSNumber *rid = [tempParamDic objectForKey:kDormCartUpdateRid];
        if ([rid integerValue] == [currentRid integerValue]) {
            
            [self.requestParamMArr removeObject:timer];
            break;
        }
    }
    
    NSNumber *countNum = [paramDic objectForKey:kDormCartUpdateCount];
    
    [MobClick event:@"dorm_add_cart" attributes:@{@"rid":currentRid}];
    [[HXSDormCartManager sharedManager] addItem:currentRid quantity:[countNum intValue]];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = HXS_VIEWCONTROLLER_BG_COLOR;
    
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemList.itemList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDormItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HXSDormItemTableViewCell" forIndexPath:indexPath];

    cell.delegate = self;
    
    if(self.itemList.itemList.count > indexPath.section) {
        
        HXSDormItem *item = self.itemList.itemList[indexPath.row];
        
        [cell setItem:item dormStatus:(int)[self.shopEntity.statusIntNum integerValue]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 10.0, 0, 0);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/**
 *  加载更多
 */
- (void)loadMoreItems
{
    if (self.loadMoreAction) {
        self.loadMoreAction();
    }
}


#pragma mark - HXSDormItemTableViewCellDelegate

- (void)dormItemTableViewCellDidShowDetail:(HXSDormItemTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath.section >= [self.itemList.itemList count]) { // index out of bounds
        return;
    }
    
    [HXSUsageManager trackEvent:kUsageEventFoodDetailInfo parameter:@{@"business_type":@"夜猫店"}];
    
    CGRect frame = cell.imageImageVeiw.frame;
    frame = [cell convertRect:frame toView:[AppDelegate sharedDelegate].window];

    HXSDormItem * item = [self.itemList.itemList objectAtIndex:indexPath.row];
    UIImage *image = cell.imageImageVeiw.image;
    
    HXSDormItemMaskDatasource *dataSource = [[HXSDormItemMaskDatasource alloc] init];
    dataSource.image = image;
    dataSource.initialImageFrame = frame;
    dataSource.item = item;
    dataSource.shopEntity = self.shopEntity;
    
    HXSDormItemMaskView *itemMaskView = [[HXSDormItemMaskView alloc] initWithDataSource:dataSource delegate:self];
    [[AppDelegate sharedDelegate].window addSubview:itemMaskView];
    [itemMaskView show];
}

- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event
{
    [self onStartEvent:event];
}

- (void)updateCountOfRid:(NSNumber *)countNum inItem:(HXSDormItem *)item
{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               item.rid,     kDormCartUpdateRid,
                               countNum,     kDormCartUpdateCount, nil];
    
    [self addUpdateDormCartRequestWithParam:paramsDic];
}


#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    if (scrollView == self.tableView) {
        
        CGFloat currentPostion = scrollView.contentOffset.y;
        
        if (currentPostion - _lastPosition > 25 ) {
            _lastPosition = currentPostion;
            
            if (0 < currentPostion) {
                [self.listDelegate hideView];
            }
            
        } else if (_lastPosition - currentPostion > 45) {
            _lastPosition = currentPostion;
            
            if (0 > currentPostion) {
                [self.listDelegate showView];
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        _lastPosition = scrollView.contentOffset.y;
    }
}

#pragma mark - clickevent delegate

- (void)onStartEvent:(HXSClickEvent *)event
{
    if(event.eventUrl && event.eventUrl.length > 0){
        [MobClick event:@"dorm_click_event" attributes:@{@"url":event.eventUrl}];
        
        HXSWebViewController * webViewController = [HXSWebViewController controllerFromXib];
        [webViewController setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",event.eventUrl]]];
        webViewController.title = event.title;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}


#pragma mark - Setter Getter

- (NSMutableArray *)requestParamMArr
{
    if (nil == _requestParamMArr) {
        _requestParamMArr = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _requestParamMArr;
}



@end
