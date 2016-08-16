//
//  UDAgentNavigationMenu.m
//  UdeskSDKExample
//
//  Created by xuchen on 16/3/16.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import "UDAgentNavigationMenu.h"
#import "UDAgentMenuModel.h"
#import "UDViewExt.h"
#import "UDFoundationMacro.h"
#import "UdeskUtils.h"
#import "UDChatViewController.h"
#import "UIImage+UDMessage.h"
#import "UDGeneral.h"
#import "UDTools.h"
#import "UDManager.h"

@interface UDAgentNavigationMenu () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

/**
 *  客服组菜单Tableview
 */
@property (nonatomic, strong) UITableView    *agentMenuTableView;
/**
 *  客服组菜单ScrollView
 */
@property (nonatomic, strong) UIScrollView   *agentMenuScrollView;
/**
 *  自定义客服组菜单数据
 */
@property (nonatomic, strong) NSMutableArray *allAgentMenuData;
/**
 *  客服组分页
 */
@property (nonatomic, assign) int            menuPage;
/**
 *  客服组路径名字
 */
@property (nonatomic, strong) NSString       *pathString;
/**
 *  title
 */
@property (nonatomic, strong) UILabel        *menuTitleLabel;
/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton       *backButton;

@end

@implementation UDAgentNavigationMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        self.allAgentMenuData = [NSMutableArray array];
        
        self.menuPage = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.918f  green:0.922f  blue:0.925f alpha:1];
    
    [self setAgentMenuScrollView];
    
    [self setNavigationTitleName];
    
    [self requestAgentMenu];
    
    [self setBackNavigationItem];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 设置返回按钮
- (void)setBackNavigationItem {
    
    //返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 70, 40);
    [self.backButton setTitle:getUDLocalizedString(@"返回") forState:UIControlStateNormal];
    
    [self.backButton setImage:[UIImage ud_defaultBackImage] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *closeNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    // 调整 leftBarButtonItem 在 iOS7 下面的位置
    if((FUDSystemVersion>=7.0)){
        
        negativeSpacer.width = -19;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,closeNavigationItem];
    }else
        self.navigationItem.leftBarButtonItem = closeNavigationItem;
    
}

- (void)backButtonAction {
    
    //返回到指定控制器
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置MenuScrollView
- (void)setAgentMenuScrollView {
    
    _agentMenuScrollView= [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _agentMenuScrollView.delegate = self;
    _agentMenuScrollView.showsHorizontalScrollIndicator = NO;
    _agentMenuScrollView.showsVerticalScrollIndicator = NO;
    _agentMenuScrollView.userInteractionEnabled = YES;
    _agentMenuScrollView.alwaysBounceHorizontal = NO;
    _agentMenuScrollView.pagingEnabled = YES;
    _agentMenuScrollView.scrollEnabled = NO;
    
    [self.view addSubview:_agentMenuScrollView];
}

#pragma mark - 设置标题
- (void)setNavigationTitleName {
    
    self.menuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UD_SCREEN_WIDTH-100)/2, 0, 100, 44)];
    self.menuTitleLabel.text = getUDLocalizedString(@"请选择客服组");
    self.menuTitleLabel.backgroundColor = [UIColor clearColor];
    self.menuTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.menuTitleLabel.textColor = Config.faqTitleColor;
    self.navigationItem.titleView = self.menuTitleLabel;
}
#pragma mark - 请求客服组选择菜单
- (void)requestAgentMenu {
    
    [UDManager getAgentNavigationMenu:^(id responseObject, NSError *error) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 1000) {
            
            NSArray *result = [responseObject objectForKey:@"result"];
            
            if (result.count > 0) {
                
                for (NSDictionary *menuDict in result) {
                    
                    UDAgentMenuModel *agentMenuModel = [[UDAgentMenuModel alloc] initWithContentsOfDic:menuDict];
                    
                    [self.allAgentMenuData addObject:agentMenuModel];
                    
                }
                
                NSMutableArray *rootMenuArray = [NSMutableArray array];
                
                int tableViewCount = 1;
                //寻找树状的根
                for (UDAgentMenuModel *agentMenuModel in self.allAgentMenuData) {
                    
                    if ([agentMenuModel.parentId isEqualToString:@"item_0"]) {
                        
                        [rootMenuArray addObject:agentMenuModel];
                    }
                    
                    tableViewCount += [agentMenuModel.has_next intValue];
                    
                }
                //根据最大的级数设置ScrollView.contentSize
                self.agentMenuScrollView.contentSize = CGSizeMake(tableViewCount*UD_SCREEN_WIDTH, UD_SCREEN_HEIGHT);
                
                //根据最大的级数循环添加tableView
                for (int i = 0; i<tableViewCount;i++) {
                    
                    UITableView *agentMenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(i*UD_SCREEN_WIDTH, 0, UD_SCREEN_WIDTH, UD_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
                    agentMenuTableView.delegate = self;
                    agentMenuTableView.dataSource = self;
                    agentMenuTableView.tag = 100+i;
                    agentMenuTableView.backgroundColor = self.view.backgroundColor;
                    
                    [self.agentMenuScrollView addSubview:agentMenuTableView];
                    
                    //删除多余的cell
                    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
                    [agentMenuTableView setTableFooterView:footerView];
                    
                }
                //装载数据 刷新第一个tableView
                self.agentMenuData = rootMenuArray;
                
                UITableView *tableview = (UITableView *)[self.agentMenuScrollView viewWithTag:100];
                
                [tableview reloadData];
            }
            else {
                
                [self pushChatViewController];
            }
            
        }
        else {
        
            [self pushChatViewController];
        }
        
    }];
}

- (void)pushChatViewController {

    self.menuTitleLabel.text = nil;
    
    self.backButton.hidden = YES;
    
    UDChatViewController *chat = [[UDChatViewController alloc] init];
    
    [self.navigationController pushViewController:chat animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == self.menuPage+100) {
        
        return self.agentMenuData.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *agentMenuCellId = @"agentMenuCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:agentMenuCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:agentMenuCellId];
    }
    
    if (tableView.tag == self.menuPage+100) {
        
        UDAgentMenuModel *agentMenuModel = self.agentMenuData[indexPath.row];
        
        cell.textLabel.text = agentMenuModel.item_name;
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.menuPage ++;
    
    NSMutableArray *menuArray = [NSMutableArray array];
    
    //获取点击菜单选项的子集
    UDAgentMenuModel *didSelectModel = self.agentMenuData[indexPath.row];
    
    for (UDAgentMenuModel *allAgentMenuModel in self.allAgentMenuData) {
        
        if ([allAgentMenuModel.parentId isEqualToString:didSelectModel.menu_id]) {
            
            [menuArray addObject:allAgentMenuModel];
        }
        
    }
    //根据是否还有子集选择push还是执行动画
    if (menuArray.count > 0) {
        
        [UIView animateWithDuration:0.35f animations:^{
            
            self.agentMenuScrollView.contentOffset = CGPointMake(self.menuPage*UD_SCREEN_WIDTH, 0);
            
        } completion:^(BOOL finished) {
            
            if ([UDTools isBlankString:self.pathString]) {
                self.pathString = [NSString stringWithFormat:@"   %@",didSelectModel.item_name];
            }
            else {
                self.pathString = [NSString stringWithFormat:@"%@ > ",self.pathString];
                self.pathString = [self.pathString stringByAppendingString:didSelectModel.item_name];
            }
            
            self.agentMenuData = menuArray;
            
            UITableView *tableview = (UITableView *)[self.agentMenuScrollView viewWithTag:self.menuPage+100];
            
            [tableview reloadData];
            
        }];
        
    }
    else {
        
        //这里--是因为之前的++并没有执行给ScrollView.contentOffset
        self.menuPage -- ;
        
        UDChatViewController *chat = [[UDChatViewController alloc] init];
        
        chat.group_id = didSelectModel.group_id;
        
        [self.navigationController pushViewController:chat animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.menuPage) {
        
        UIButton *pathButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pathButton setTitle:self.pathString forState:UIControlStateNormal];
        pathButton.frame = CGRectMake(0, 0, tableView.ud_width-0, 30);
        pathButton.titleLabel.numberOfLines = 0;
        pathButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [pathButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [pathButton addTarget:self action:@selector(pathBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return pathButton;
    }
    else {
        
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.menuPage) {
        
        CGSize pathSize = [UDGeneral.store textSize:self.pathString fontOfSize:[UIFont systemFontOfSize:17] ToSize:CGSizeMake(tableView.ud_width, CGFLOAT_MAX)];
        
        CGFloat otherH;
        if (pathSize.height==0) {
            otherH = 45;
        }
        else {
            otherH = 25;
        }
        
        return pathSize.height+otherH;
    }
    else {
        
        return 0;
    }
    
}

- (void)pathBackButtonAction:(UIButton *)button {
    
    self.menuPage --;
    
    //判断ScrollView.contentOffset.x是否到头
    if (self.agentMenuScrollView.contentOffset.x>0) {
        
        [UIView animateWithDuration:0.35f animations:^{
            //执行返回
            self.agentMenuScrollView.contentOffset = CGPointMake(self.agentMenuScrollView.contentOffset.x-UD_SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
            //装载这个页面的数据
            NSMutableArray *array = [NSMutableArray array];
            
            UDAgentMenuModel *subMenuModel = self.agentMenuData.lastObject;
            
            NSString *parentId;
            NSString *upString;
            //查找属于上级菜单的父级
            for (UDAgentMenuModel *model in self.allAgentMenuData) {
                
                if ([model.menu_id isEqualToString:subMenuModel.parentId]) {
                    
                    parentId = model.parentId;
                    
                    if ([model.parentId isEqualToString:@"item_0"]) {
                        upString = model.item_name;
                    }
                    else {
                        upString = [NSString stringWithFormat:@" > %@",model.item_name];
                    }
                    
                }
                
            }
            
            //查找与上级菜单的父级同级的菜单选项
            for (UDAgentMenuModel *model in self.allAgentMenuData) {
                
                if ([model.parentId isEqualToString:parentId]) {
                    
                    [array addObject:model];
                }
            }
            
            if (array.count > 0) {
                
                NSMutableString *mString = [NSMutableString stringWithString:self.pathString];
                [mString deleteCharactersInRange:[mString rangeOfString:upString]];
                
                self.pathString = mString;
                
                //装载数据刷新指定tableview
                self.agentMenuData = array;
                
                UITableView *tableview = (UITableView *)[self.agentMenuScrollView viewWithTag:self.menuPage+100];
                
                [tableview reloadData];
            }
            
        }];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    self.menuTitleLabel.text = getUDLocalizedString(@"请选择客服组");
    
    if (ud_isIOS6) {
        self.navigationController.navigationBar.tintColor = Config.agentMenuNavigationColor;
    } else {
        self.navigationController.navigationBar.barTintColor = Config.agentMenuNavigationColor;
        self.navigationController.navigationBar.tintColor = Config.agentMenuBackButtonColor;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.menuTitleLabel.text = nil;
    
    if (ud_isIOS6) {
        self.navigationController.navigationBar.tintColor = Config.oneSelfNavcigtionColor;
    } else {
        self.navigationController.navigationBar.barTintColor = Config.oneSelfNavcigtionColor;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
