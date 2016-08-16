//
//  HXDServiceSelectViewController.m
//  dorm
//
//  Created by hudezhi on 15/7/10.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.
//

#import "HXSServiceSelectViewController.h"

@interface HXSServiceSelectViewController ()

-(void)setupBarButtonItem;
-(void)cancel;

-(NSString*)titleForServiceType:(HXSEnvironmentType)type;

@end

@implementation HXSServiceSelectViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择环境";
    
    [self setupBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Methods

-(void)setupBarButtonItem
{
    UIBarButtonItem* cancelBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    [cancelBtnItem setTitlePositionAdjustment:UIOffsetMake(-5.0, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = cancelBtnItem;
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return HXSServiceURLCounts;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* _serviceUrlCellIdentifier = @"serviceUrlCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_serviceUrlCellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_serviceUrlCellIdentifier];
    }
    
    HXSEnvironmentType type = (HXSEnvironmentType)indexPath.row;
    cell.textLabel.text = [self titleForServiceType:type];
    if([[ApplicationSettings instance] currentEnvironmentType] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.tintColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXSEnvironmentType type = (HXSEnvironmentType)indexPath.row;
    [[ApplicationSettings instance] setCurrentEnvironmentType:type];
    
    DLog(@"---------- Current Service URL : %@", [[ApplicationSettings instance] currentServiceURL]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Get Set Methods
-(NSString*)titleForServiceType:(HXSEnvironmentType)type
{
    switch(type) {
        case HXSEnvironmentProduct: return @"生产环境";
        case HXSEnvironmentTemai:   return @"特卖环境";
        case HXSEnvironmentStage:   return @"Stage测试";
        case HXSEnvironmentQA:      return @"QA环境";
        default:
            break;
    }
    
    return @"";
}


@end
