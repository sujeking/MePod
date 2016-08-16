//
//  HXSBoxLastBillViewController.m
//  store
//
//  Created by ArthurWang on 16/6/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxLastBillViewController.h"

@interface HXSBoxLastBillViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HXSBoxLastBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Intial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"上期消费清单";
}

- (void)initialTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = @"上期的长女啊 账单身的啊 ";
    
    return cell;
}

@end
