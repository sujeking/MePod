//
//  HXSInfoSubmitCompleteViewController.m
//  store
//
//  Created by  黎明 on 16/7/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSInfoSubmitCompleteViewController.h"
#import "HXSInfoSubmitCompleteTableViewCell.h"

#import "HXSInfoSubmitCompleteFooterView.h"

static NSString * const InfoSubmitCompleteTableViewCell = @"HXSInfoSubmitCompleteTableViewCell";


@interface HXSInfoSubmitCompleteViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation HXSInfoSubmitCompleteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialNavigationBar];
    [self tableViewRegisterCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - init

- (void)initialNavigationBar
{
    self.navigationItem.title = @"资料升级";
}


- (void)tableViewRegisterCell
{
    WS(weakSelf);
    
    UINib *nib = [UINib nibWithNibName:InfoSubmitCompleteTableViewCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:InfoSubmitCompleteTableViewCell];
    
    
    HXSInfoSubmitCompleteFooterView *infoSubmitCompleteFooterView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSInfoSubmitCompleteFooterView class]) owner:nil options:nil].firstObject;
    
    [infoSubmitCompleteFooterView setBackButtonClickBlock:^{
        [weakSelf back];
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    [footerView addSubview:infoSubmitCompleteFooterView];
    
    [infoSubmitCompleteFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(footerView);
    }];
    
    [self.tableview setTableFooterView:footerView];
}


#pragma mark - overwrite

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSInfoSubmitCompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoSubmitCompleteTableViewCell forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

@end
