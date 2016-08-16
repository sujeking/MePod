//
//  HXSCategoryListViewController.m
//  store
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCategoryListViewController.h"
#import "HXSCategoryModel.h"

static NSInteger const kkCategoryTableviewCellHeight = 44; //cell的高度

@interface HXSCategoryListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation HXSCategoryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectIndex = 0;
    
    self.view.backgroundColor = [UIColor colorWithR:1.0 G:1.0 B:1.0 A:0.3];
    
    [self initialTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat expectHeight = [self.categoryItems count] * kkCategoryTableviewCellHeight;
    if (expectHeight > self.view.height) {
        self.tableViewHeightConstraint.constant = self.view.height;
    } else {
        self.tableViewHeightConstraint.constant = expectHeight;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initialTableView
{
    self.categoryTableView.tableFooterView = [[UIView alloc] init];
    
    self.tableViewHeightConstraint.constant = 0;
    
    [self.view layoutIfNeeded];
}


#pragma mark - Dismiss View

- (void)dismissView:(NSInteger)selectIndex
{
    self.tableViewHeightConstraint.constant = 0;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [weakSelf.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [self removeFromParentViewController];
                         [self.view removeFromSuperview];

                         if (weakSelf.dismissBlock) {
                             
                             if (selectIndex != -1) {
                                 HXSCategoryModel *model = weakSelf.categoryItems[selectIndex];
                                 
                                  weakSelf.dismissBlock(selectIndex,model);
                             } else {
                                 
                                 weakSelf.dismissBlock(selectIndex,nil);
                             }
                             
                         }
                     }];
}


#pragma mark -tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoryItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"categorycell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    NSInteger row = indexPath.row;

    HXSCategoryModel *categoryModel = self.categoryItems[row];
    
    cell.tintColor = UIColorFromRGB(0x00A3FA);
    
    cell.textLabel.text = categoryModel.categoryName;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];

    if (self.selectIndex == indexPath.row) {

        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        cell.textLabel.textColor = UIColorFromRGB(0x00A3FA);
    } else {

        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.selectIndex = indexPath.row;
    
    [self.categoryTableView reloadData];
    
    [self dismissView:self.selectIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kkCategoryTableviewCellHeight;
}


#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissView:-1];
//    没有选择，应该返回刚才选择的地方
    if (self.unSelectBlock) {
        self.unSelectBlock();
    }
}

-(void)dealloc
{
    self.dismissBlock = nil;
    self.categoryItems = nil;
}

@end
