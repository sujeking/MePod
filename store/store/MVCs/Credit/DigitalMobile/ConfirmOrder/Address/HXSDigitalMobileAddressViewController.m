//
//  HXSDigitalMobileAddressViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileAddressViewController.h"

// Controller
#import "HXSSelectCityViewController.h"

// Model
#import "HXSDigitalMobileParamEntity.h"
#import "HXSDigitalMobileAddressEntity.h"
#import "HXSAddressViewModel.h"
#import "HXSBuildingEntity.h"

// Views
#import "HXSAddressCell.h"
#import "HXSDigitalMobileAddressPickerView.h"
#import "HXSCustomPickerView.h"


@interface HXSDigitalMobileAddressViewController ()<UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    HXSAddressCellActionDelegate>

@property (nonatomic, strong) HXSAddressViewModel *addressModel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isShowkeyboard;

@property (nonatomic, strong) HXSAddressEntity *addressEntity;
@property (nonatomic, strong) NSMutableArray *selectedAddressArr;  // three entities
@property (nonatomic, strong) NSArray *pickerViewDataSource;

@end

@implementation HXSDigitalMobileAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"收货地址";
    
    [self initTableView];
    [self addkeyboardNotification];
}

- (void)dealloc
{
    [self removeKeyboardNotification];
}

- (void)initData:(HXSAddressEntity *)addressInfo
{
    self.addressEntity             = [[HXSAddressEntity alloc] init];
    self.addressEntity.name        = addressInfo.name;
    self.addressEntity.phone       = addressInfo.phone;
    self.addressEntity.postcode    = addressInfo.postcode;

    self.addressEntity.provinceId  = addressInfo.provinceId;
    self.addressEntity.province    = addressInfo.province;
    self.addressEntity.cityId      = addressInfo.cityId;
    self.addressEntity.city        = addressInfo.city;
    self.addressEntity.countyId    = addressInfo.countyId;
    self.addressEntity.county      = addressInfo.county;
    self.addressEntity.townId      = addressInfo.townId;
    self.addressEntity.town        = addressInfo.town;
    self.addressEntity.siteId      = addressInfo.siteId;
    self.addressEntity.site        = addressInfo.site;
    self.addressEntity.dormentryId = addressInfo.dormentryId;
    self.addressEntity.dormentry   = addressInfo.dormentry;
    self.addressEntity.dormitory   = addressInfo.dormitory;
    
    self.selectedAddressArr = [[NSMutableArray alloc] init];
    
    // 地址信息
    HXSDigitalMobileAddressEntity *provinceEntity = [[HXSDigitalMobileAddressEntity alloc] init];
    provinceEntity.provinceIDIntNum = addressInfo.provinceId;
    provinceEntity.provinceNameStr = addressInfo.province;
    HXSDigitalMobileCityAddressEntity *cityEntity = [[HXSDigitalMobileCityAddressEntity alloc] init];
    cityEntity.cityIDIntNum = addressInfo.cityId;
    cityEntity.cityNameStr = addressInfo.city;
    HXSDigitalMobileCountryAddressEntity *countyEntity = [[HXSDigitalMobileCountryAddressEntity alloc] init];
    countyEntity.countryIDIntNum = addressInfo.countyId;
    countyEntity.countryNameStr = addressInfo.county;
    
    [self.selectedAddressArr addObject:provinceEntity];
    [self.selectedAddressArr addObject:cityEntity];
    [self.selectedAddressArr addObject:countyEntity];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xF4F5F6];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSAddressCell" bundle:nil] forCellReuseIdentifier:@"HXSAddressCellIdentify"];
    [self.view addSubview:self.tableView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
}


#pragma mark - HXSAddressCellActionDelegate

- (void)seletcAreaAction
{
    [self.view endEditing:YES];
    
    [self seletcArea];
}

- (void)selectStreetAction
{
    [self.view endEditing:YES];
    
    [self selectStreet];
}

- (void)selectSchoolAction
{
    [self.view endEditing:YES];
    
    [self selectSchool];
}

- (void)selectBuildingAction
{
    [self.view endEditing:YES];
    
    [self selectBuilding];
}


#pragma mark - keyboard notification

- (void)addkeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (!self.isShowkeyboard) {
        NSDictionary *info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        [self scrollTableViewToVisible:-kbSize.height];
    }
    
    self.isShowkeyboard = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.isShowkeyboard = NO;
    [self scrollTableViewToVisible:0];
}

- (void)scrollTableViewToVisible:(float)paddingBottom
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(paddingBottom);
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.tableView layoutIfNeeded];
    }];
}

- (void)resetTableView
{
    [self scrollTableViewToVisible:0];
    [self.tableView endEditing:YES];
}


#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 440.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"HXSAddressCellIdentify"];
    addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
    addressCell.delegate = self;
    [addressCell initCell:self.addressEntity and:self.selectedAddressArr];
    
    return addressCell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resetTableView];
}



#pragma mark - seletcArea

- (void)seletcArea
{
    __weak typeof(self) weakSelf = self;
    [HXSDigitalMobileAddressPickerView showWithPickerViewDataSource:self.pickerViewDataSource selected:self.selectedAddressArr toolBarColor:[UIColor whiteColor] completeBlock:^(NSArray *pickerViewDataSource, NSArray *selectedAddressArr) {
        
        weakSelf.pickerViewDataSource = pickerViewDataSource;
        
        if (selectedAddressArr != weakSelf.selectedAddressArr) {
            weakSelf.selectedAddressArr = (NSMutableArray *)selectedAddressArr;
            
            [weakSelf updateAddressInfo];
        }
        
    }];
}

- (void)updateAddressInfo
{
    HXSDigitalMobileAddressEntity *provinceEntity      = (HXSDigitalMobileAddressEntity *)self.selectedAddressArr[0];
    HXSDigitalMobileCityAddressEntity *cityEntity      = (HXSDigitalMobileCityAddressEntity *)self.selectedAddressArr[1];
    HXSDigitalMobileCountryAddressEntity *countyEntity = (HXSDigitalMobileCountryAddressEntity *)self.selectedAddressArr[2];
    
    self.addressEntity.province    = provinceEntity.provinceNameStr;
    self.addressEntity.provinceId  = provinceEntity.provinceIDIntNum;
    self.addressEntity.city        = cityEntity.cityNameStr;
    self.addressEntity.cityId      = cityEntity.cityIDIntNum;
    self.addressEntity.county      = countyEntity.countryNameStr;
    self.addressEntity.countyId    = countyEntity.countryIDIntNum;
    self.addressEntity.townId      = nil;
    self.addressEntity.town        = nil;
    self.addressEntity.siteId      = nil;
    self.addressEntity.site        = nil;
    self.addressEntity.dormentryId = nil;
    self.addressEntity.dormentry   = nil;
    self.addressEntity.dormitory   = nil;
    
    [self.tableView reloadData];
}


#pragma mark - selectStreet

- (void)selectStreet
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.addressModel fetchAddressTownWithCountry:self.addressEntity.countyId WithComplete:^(HXSErrorCode code, NSString *message, NSArray *streeList) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (kHXSNoError != code) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.0f];

            return ;
        }
        
        if (0 >= [streeList count]) {
            weakSelf.addressEntity.townId = @0;
            weakSelf.addressEntity.town = @"全街道";
            
            [weakSelf.tableView reloadData];
            
            return;
        }
        
        NSString *defaultString = @"";
        if (weakSelf.addressEntity.town != nil) {
            defaultString = weakSelf.addressEntity.town;
        }
        
        [HXSCustomPickerView showWithStringArray:[weakSelf getStreeNameList:streeList] defaultValue:defaultString toolBarColor:[UIColor whiteColor] completeBlock:^(int index, BOOL finished) {
            if (finished) {
                HXSDigitalMobileTownAddressEntity *entity = streeList[index];
                weakSelf.addressEntity.townId = entity.townIDIntNum;
                weakSelf.addressEntity.town = entity.townNameStr;
                
                [weakSelf.tableView reloadData];
            }
        }];
    }];
}

- (NSArray *)getStreeNameList:(NSArray *)streeList
{
    NSMutableArray * nameList = [[NSMutableArray alloc] init];
    for (HXSDigitalMobileTownAddressEntity *entity in streeList) {
        [nameList addObject:entity.townNameStr];
    }
    
    return nameList;
}


#pragma mark - selectSchool

- (void)selectSchool
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.addressModel fetchAllSchoolWithFirstAddress:self.addressEntity.province
                                        secondAddress:self.addressEntity.city
                                             complete:^(HXSErrorCode code, NSString *message, NSArray *schoolList) {
                                                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                 
                                                 if ((kHXSNoError != code)
                                                     || (0 >= [schoolList count])) {
                                                     [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                        status:@"抱歉，您所在的区域暂时无法购买分期商品"
                                                                                    afterDelay:1.5f];
                                                     
                                                     return ;
                                                 }
                                                 
                                                 NSArray *schoolNameList = [weakSelf getSchoolNameList:schoolList];
                                                 
                                                 NSString *defaultSchoolName = @"";
                                                 if (weakSelf.addressEntity.site != nil) {
                                                     defaultSchoolName = weakSelf.addressEntity.site;
                                                 }
                                                 
                                                 [HXSCustomPickerView showWithStringArray:schoolNameList defaultValue:defaultSchoolName toolBarColor:[UIColor whiteColor] completeBlock:^(int index, BOOL finished) {
                                                     if (finished) {
                                                         HXSSite *site = schoolList[index];
                                                         if ([site.site_id integerValue] != [weakSelf.addressEntity.siteId integerValue]) {
                                                             weakSelf.addressEntity.dormentryId = nil;
                                                             weakSelf.addressEntity.dormentry   = nil;
                                                             weakSelf.addressEntity.dormitory   = nil;
                                                         }
                                                         weakSelf.addressEntity.site = site.name;
                                                         weakSelf.addressEntity.siteId = site.site_id;
                                                         
                                                         [weakSelf.tableView reloadData];
                                                     }
                                                 }];
                                             }];
}

- (NSArray *)getSchoolNameList:(NSArray *)schoolList
{
    NSMutableArray *nameList = [[NSMutableArray alloc] init];
    for (HXSSite *site in schoolList) {
        [nameList addObject:site.name];
    }
    
    return nameList;
}


#pragma mark - selectBuilding

- (void)selectBuilding
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.addressModel fetchAllBuilding:self.addressEntity.siteId WithComplete:^(HXSErrorCode code, NSString *message, NSArray *buildingList) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ((kHXSNoError != code)
            || (0 >= [buildingList count])) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:@"抱歉，您所在的区域暂时无法购买分期商品"
                                           afterDelay:1.5f];
            
            return ;
        }
        
        NSArray *nameList = [weakSelf getBuildingNameList:buildingList];
        NSString *defaultString = @"";
        if (weakSelf.addressEntity.dormentry != nil) {
            defaultString = weakSelf.addressEntity.dormentry;
        }
        
        [HXSCustomPickerView showWithStringArray:nameList defaultValue:defaultString toolBarColor:[UIColor whiteColor] completeBlock:^(int index, BOOL finished) {
            if (finished) {
                HXSBuildingNameEntity *build = [weakSelf getBuildingNameEntityWithIndex:index inBuildingList:buildingList];
                
                if ([build.dormentryIDIntNum integerValue] != [weakSelf.addressEntity.dormentryId integerValue]) {
                    self.addressEntity.dormitory   = nil;
                }
                
                weakSelf.addressEntity.dormentry = [nameList objectAtIndex:index];
                weakSelf.addressEntity.dormentryId = build.dormentryIDIntNum;
                
                [weakSelf.tableView reloadData];
            }
        }];
    }];
}

- (NSArray *)getBuildingNameList:(NSArray *)buildingList
{
    NSMutableArray *nameList = [[NSMutableArray alloc] init];
    for (HXSBuildingEntity *build in buildingList) {
        NSString *nameStr = (0 < [build.nameStr length]) ? build.nameStr : @"";
        for (HXSBuildingNameEntity *nameEntity in build.buildingsArr) {
            [nameList addObject:[NSString stringWithFormat:@"%@ %@", nameStr, nameEntity.buildingNameStr]];
        }
    }
    
    return nameList;
}

- (HXSBuildingNameEntity *)getBuildingNameEntityWithIndex:(int)index
                                          inBuildingList:(NSArray *)buildingList
{
    int count = 0;
    
    for (int i = 0; i < [buildingList count]; i++) {
        HXSBuildingEntity *build = [buildingList objectAtIndex:i];
        for (int j = 0; j < [build.buildingsArr count]; j++) {
            if (count == index) {
                HXSBuildingNameEntity *nameEntity = [build.buildingsArr objectAtIndex:j];
                
                return nameEntity;
            }
            
            count++;
        }
    }

    return nil;
}


#pragma mark - save address info

- (void)saveAddressInfoAction:(HXSAddressEntity *)addressEntity
{
    self.addressEntity = addressEntity;
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.addressModel saveAddressInfo:self.addressEntity Complete:^(HXSErrorCode code, NSString *message, HXSAddressEntity *addressInfo) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (kHXSNoError == code) {
            if ([weakSelf.delegate respondsToSelector:@selector(didSaveAddress:)]) {
                [weakSelf.delegate performSelector:@selector(didSaveAddress:) withObject:addressInfo];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒" message:@"地址保存失败" leftButtonTitle:@"确定" rightButtonTitles:nil];
            [alertView show];
        }
    }];
}


#pragma mark - HXSPickViewDelegate

- (void)clickedConfirmButton:(UIPickerView *)pickView
{
    // Do nothing
}


#pragma mark - Setter Getter Methods

- (HXSAddressViewModel *)addressModel
{
    if (nil == _addressModel) {
        _addressModel = [[HXSAddressViewModel alloc] init];
    }
    
    return _addressModel;
}

@end
