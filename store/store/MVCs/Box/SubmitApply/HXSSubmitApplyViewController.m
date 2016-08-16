//
//  HXSSubmitApplyViewController.m
//  store
//
//  Created by ArthurWang on 16/5/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSSubmitApplyViewController.h"
#import "HXSBoxMacro.h"
// Controllers

// Model
#import "HXSBoxInfoEntity.h"
#import "HXSApplyResultInfoModel.h"
#import "HXSBoxModel.h"
// Views
#import "HXSActionSheet.h"
#import <MBProgressHUD.h>
#import "HXSSubmitApplyCell.h"

// Others
#import "HXSNetRequest.h"


@interface HXSSubmitApplyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, strong) HXSSubmitApplyCell *nameCell;
@property (nonatomic, strong) HXSSubmitApplyCell *sexCell;
@property (nonatomic, strong) HXSSubmitApplyCell *enrollmentYearCell;
@property (nonatomic, strong) HXSSubmitApplyCell *boxerMobileCell;
@property (nonatomic, strong) HXSSubmitApplyCell *addressCell;
@property (nonatomic, strong) HXSSubmitApplyCell *dormNameCell;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, strong) HXSBoxInfoEntity *boxInfoEntity;
//店长手机号
@property (nonatomic, strong) NSString *dormMobileStr;
@property (nonatomic, copy) void (^refreshBoxInfo)(void);

@end

static NSString *const male = @"男";
static NSString *const female = @"女";

static CGFloat const cellHeight = 28.0f;



@implementation HXSSubmitApplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    [self initPrama];
    [self initialTable];
    [self fetchApplyResultInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - initial
- (void)initialTable{
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.showsVerticalScrollIndicator = NO;
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.myTable setBackgroundColor:HXS_COLOR_BACKGROUND_MAIN];
    [self.myTable setTableFooterView:self.tableFooterView];
}

- (void)initPrama{
    self.dataArray = @[self.nameCell,self.sexCell,self.enrollmentYearCell,self.boxerMobileCell,self.addressCell,self.dormNameCell];
}

/**
 *  获取申请结果信息
 */
- (void)fetchApplyResultInfo
{
    WS(weakSelf);
    
    [HXSNetRequest fetchApplyResultInfoWithUid:[HXSUserAccount currentAccount].userID complete:^(HXSErrorCode code, NSString *message, HXSApplyResultInfoModel *applyResultInfoModel) {
        if (code == kHXSNoError) {
            
            weakSelf.dormMobileStr = applyResultInfoModel.dormerMobileStr;
            
            weakSelf.nameCell.valueLabel.text = applyResultInfoModel.boxerNameStr;
            weakSelf.sexCell.valueLabel.text = applyResultInfoModel.genderNum.intValue == HXSBoxGenderTypeMale ? @"男":@"女";
            weakSelf.enrollmentYearCell.valueLabel.text = [NSString stringWithFormat:@"%d",applyResultInfoModel.enrollmentYearNum.intValue];
            weakSelf.boxerMobileCell.valueLabel.text = applyResultInfoModel.boxerMobileStr;
            weakSelf.addressCell.valueLabel.text = applyResultInfoModel.addressStr;
            weakSelf.dormNameCell.valueLabel.text = applyResultInfoModel.dormNameStr;
            [weakSelf.myTable reloadData];

        } else {
            [MBProgressHUD showInView:weakSelf.view customView:nil status:message afterDelay:3];
        }
    }];
}

#pragma mark - Public Methods

+ (instancetype)createSubmitApplyVCWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity refresh:(void (^)(void))refreshBoxInfo
{
    HXSSubmitApplyViewController *submitApplyViewController = [HXSSubmitApplyViewController controllerFromXib];
    
    submitApplyViewController.boxInfoEntity = boxInfoEntity;
    submitApplyViewController.refreshBoxInfo = refreshBoxInfo;
    
    return submitApplyViewController;
}

- (void)refresh
{
    [self fetchApplyResultInfo];
}

#pragma mark - Override Mehods

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"提交申请";
    self.parentViewController.navigationItem.title = @"提交申请";
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}


/**
 *  联系店长
 */
- (void)connectDormAction
{
    WS(weakSelf);

    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = self.dormMobileStr;

    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity handler:^(HXSAction *action) {
        [HXSUsageManager trackEvent:kUsageEventBoxApplyContactDorm parameter:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",weakSelf.dormMobileStr]]];
    }];
    [sheet addAction:callAction];
    [sheet show];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [footer setBackgroundColor:[UIColor whiteColor]];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 4)
    {
        return [self getTableViewCellHeightWithText:self.addressCell.valueLabel.text];
    }
    else
    {
        return cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSSubmitApplyCell *cell = [self.dataArray objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - Setter Getter Methods

- (CGFloat)getTableViewCellHeightWithText:(NSString *)text
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                     context:nil].size;
    return size.height > cellHeight ? size.height : cellHeight;
}

- (HXSSubmitApplyCell *)nameCell
{
    if(!_nameCell){
        _nameCell = [HXSSubmitApplyCell submitApplyCell];
        _nameCell.keyLabel.text = @"姓       名：";
        _nameCell.tagImage.hidden = NO;
    }
    return _nameCell;
}

- (HXSSubmitApplyCell *)sexCell
{
    if(!_sexCell){
        _sexCell = [HXSSubmitApplyCell submitApplyCell];
        _sexCell.keyLabel.text = @"性       别：";
    }
    return _sexCell;
}

- (HXSSubmitApplyCell *)enrollmentYearCell
{
    if(!_enrollmentYearCell){
        _enrollmentYearCell = [HXSSubmitApplyCell submitApplyCell];
        _enrollmentYearCell.keyLabel.text = @"入学年份：";
    }
    return _enrollmentYearCell;
}

- (HXSSubmitApplyCell *)boxerMobileCell
{
    if(!_boxerMobileCell){
        _boxerMobileCell = [HXSSubmitApplyCell submitApplyCell];
        _boxerMobileCell.keyLabel.text = @"手机号码：";
    }
    return _boxerMobileCell;
}

- (HXSSubmitApplyCell *)addressCell
{
    if(!_addressCell){
        _addressCell = [HXSSubmitApplyCell submitApplyCell];
        _addressCell.keyLabel.text = @"寝室地址：";
        _addressCell.valueLabel.numberOfLines = 0;
    }
    return _addressCell;
}

- (HXSSubmitApplyCell *)dormNameCell
{
    if(!_dormNameCell){
        _dormNameCell = [HXSSubmitApplyCell submitApplyCell];
        _dormNameCell.keyLabel.text = @"供货店长：";
    }
    return _dormNameCell;
}

- (UIView *)tableFooterView
{
    if(!_tableFooterView){
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 325)];
        [_tableFooterView setBackgroundColor:HXS_COLOR_BACKGROUND_MAIN];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 208)/2, 44, 208, 140)];
        [imageView setImage:[UIImage imageNamed:@"img_lingshihe_shenqingyitijiao"]];
        [_tableFooterView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 208)/2, 199, 208, 18)];
        label.text = @"零食盒申请已提交";
        [label setFont:[UIFont systemFontOfSize:18]];
        [label setTextColor:[UIColor colorWithRGBHex:0x446f97]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [_tableFooterView addSubview:label];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 190)/2, 259, 190, 40)];
        button.layer.cornerRadius = 4;
        button.layer.borderColor = HXS_COLOR_MASTER.CGColor;
        button.layer.borderWidth = 1;
        [button setTitleColor:HXS_COLOR_MASTER forState:UIControlStateNormal];
        [button setTitle:@"联系店长，一切搞定" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_tableFooterView addSubview:button];
        
        [button addTarget:self action:@selector(connectDormAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableFooterView;
}



@end
