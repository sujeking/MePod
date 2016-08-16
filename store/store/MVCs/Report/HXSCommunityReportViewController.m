//
//  HXSCommunityReportViewController.m
//  store
//
//  Created by J006 on 16/5/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityReportViewController.h"
#import "HXSCommunityReportTableViewCell.h"
#import "HXSWebViewController.h"
#import "HXSCommunityReportModel.h"

@interface HXSCommunityReportViewController ()

@property (nonatomic ,strong) UIBarButtonItem *postBarButton;// 右上角提交按钮
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic ,strong) NSArray<HXSCommunityReportItemEntity *> *reportTypeItemsArray;// 举报条目集合
@property (nonatomic ,strong) UIView  *sectionHeaderView;
@property (nonatomic ,strong) UILabel *sectionHeaderLabel;
@property (weak, nonatomic) IBOutlet UIButton *reportMustKnowButton;// 举报须知
@property (nonatomic ,strong) HXSCommunityReportModel       *reportModel;
@property (nonatomic ,strong) HXSCommunityReportParamEntity *paramEntity;

@end

@implementation HXSCommunityReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTheNavigationBar];
    
    [self initTheTableView];
    
    [self initTheNetworking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark init

- (void)initCommunityReportViewControllerWithType:(HXSCommunityReportType)type
                                        andWithID:(NSString *)idStr
{
    [self.paramEntity setReportType:type];
    switch (type)
    {
        case kHXSCommunityReportTypePost:
        {
            [_paramEntity setPostIDStr:idStr];
            break;
        }
        case kHXSCommunityReportTypeComment:
        {
            [_paramEntity setCommentIDStr:idStr];
            break;
        }
    }
}

- (void)initTheNavigationBar
{
    [self.navigationItem setTitle:@"举报"];
    [self.navigationItem setRightBarButtonItem:self.postBarButton];
}

- (void)initTheNetworking
{
    [self fetchTheReportListNetworking];
}

- (void)initTheTableView
{
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCommunityReportTableViewCell class]) bundle:nil]
     forCellReuseIdentifier:NSStringFromClass([HXSCommunityReportTableViewCell class])];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if(_reportTypeItemsArray && _reportTypeItemsArray.count > 0)
    {
        rows = _reportTypeItemsArray.count;
    }
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 0;
    
    if(_reportTypeItemsArray && _reportTypeItemsArray.count > 0)
    {
        sections = 1;
    }
    
    return sections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSCommunityReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCommunityReportTableViewCell class])
                                                                        forIndexPath:indexPath];
    [cell initCommunityReportTableViewCellWithReportEntity:[_reportTypeItemsArray objectAtIndex:indexPath.row]
                                        andWithParamEntity:self.paramEntity];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 50;
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_paramEntity setReasonStr:[_reportTypeItemsArray objectAtIndex:indexPath.row].reasonStr];
    [tableView reloadData];
    [self checkTheRightBarButton];
}

#pragma mark Button Action

/**
 *  举报须知
 *
 *  @param sender
 */
- (IBAction)reportMustKnowAction:(id)sender
{
    NSString *url = [[ApplicationSettings instance]currentReportURL];
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark nerworking

/**
 *  获取举报所有项目条目
 */
- (void)fetchTheReportListNetworking
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    [self.reportModel fetchTheReportReasonComplete:^(HXSErrorCode code, NSString *message, NSArray<HXSCommunityReportItemEntity *> *reportReasonArray)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if(code == kHXSNoError && reportReasonArray)
        {
            weakSelf.reportTypeItemsArray = reportReasonArray;
            [weakSelf.mainTableView reloadData];
        }
        else
        {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
            [weakSelf.reportMustKnowButton setHidden:YES];
        }
    }];
}


/**
 *  提交帖子网络访问
 */
- (void)postTheReportNetworking
{
    [_postBarButton setEnabled:NO];
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    [self.reportModel reportTheContentWithParamEntity:_paramEntity
                                             complete:^(HXSErrorCode code, NSString *message, NSString *resultStatus)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if(code == kHXSNoError && resultStatus)
        {
            NSString *succMessageStr = @"举报成功";
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]];
            [MBProgressHUD showInView:weakSelf.view
                           customView:imageView
                               status:succMessageStr
                           afterDelay:0.5
                        completeBlock:^
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            [weakSelf.postBarButton setEnabled:YES];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

#pragma mark BarButtonAction

/**
 *  提交帖子操作
 */
- (void)postBarButtonAction:(UIBarButtonItem *)postBarButton
{
    [self postTheReportNetworking];
}

#pragma mark private methords

/**
 *  检测右上角按钮是否可点
 */
- (void)checkTheRightBarButton
{
    if(_paramEntity.reasonStr
       && ![[_paramEntity.reasonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [_postBarButton setEnabled:YES];
    }
    else
    {
        [_postBarButton setEnabled:NO];
    }
}

#pragma mark getter setter

- (UIBarButtonItem *)postBarButton
{
    if(!_postBarButton)
    {
        _postBarButton = [[UIBarButtonItem alloc]initWithTitle:@"提交"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(postBarButtonAction:)];
        [_postBarButton setEnabled:NO];
    }
    return _postBarButton;
}

- (UIView *)sectionHeaderView
{
    if(!_sectionHeaderView)
    {
        _sectionHeaderView = [[UIView alloc]init];
        [_sectionHeaderView setBackgroundColor:[UIColor colorWithR:245 G:246 B:247 A:1.0]];
        [_sectionHeaderView addSubview:self.sectionHeaderLabel];
        [_sectionHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sectionHeaderView).offset(15);
            make.centerY.equalTo(_sectionHeaderView);
        }];
        [_sectionHeaderLabel sizeToFit];
    }
    return _sectionHeaderView;
}

- (UILabel *)sectionHeaderLabel
{
    if(!_sectionHeaderLabel)
    {
        _sectionHeaderLabel = [[UILabel alloc]init];
        [_sectionHeaderLabel setFont:[UIFont systemFontOfSize:13]];
        [_sectionHeaderLabel setText:@"请选择举报原因"];
        [_sectionHeaderLabel setBackgroundColor:[UIColor clearColor]];
        [_sectionHeaderLabel setTextColor:[UIColor colorWithR:153 G:153 B:153 A:1.0]];
    }
    return _sectionHeaderLabel;
}

- (HXSCommunityReportModel *)reportModel
{
    if(!_reportModel)
    {
        _reportModel = [[HXSCommunityReportModel alloc]init];
    }
    return _reportModel;
}

- (HXSCommunityReportParamEntity *)paramEntity
{
    if(!_paramEntity)
    {
        _paramEntity = [[HXSCommunityReportParamEntity alloc]init];
    }
    return _paramEntity;
}

@end
