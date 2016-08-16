//
//  HXSDigitalMobileAddressPickerView.m
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileAddressPickerView.h"

#import "HXSDigitalMobileDetailModel.h"

@interface HXSDigitalMobileAddressPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *picketToolbar;
@property (nonatomic, strong) NSMutableArray *pickerViewDataSource;
@property (nonatomic, strong) NSMutableArray *selectedAddressMArr;
@property (nonatomic, copy) HXSDigitalMobileCustomerPickView block;

@property (nonatomic, strong) HXSDigitalMobileDetailModel  *digitalMobileDetialModel;
@property (nonatomic, strong) UIView *parentView;

@end

@implementation HXSDigitalMobileAddressPickerView


#pragma mark - Public Methods

+ (void)showWithPickerViewDataSource:(NSArray *)pickerViewDataSource
                            selected:(NSArray *)selectedAddressArr
                        toolBarColor:(UIColor *)color
                       completeBlock:(HXSDigitalMobileCustomerPickView)block
{
    HXSDigitalMobileAddressPickerView *customView = [[HXSDigitalMobileAddressPickerView alloc] initWithPickerViewDataSource:pickerViewDataSource
                                                                                                                   selected:selectedAddressArr
                                                                                                              completeBlock:block];
    if(color) {
        customView.picketToolbar.backgroundColor = color;
        [customView.picketToolbar setBackgroundImage:[UIImage imageWithColor:color] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    [customView show];
}


#pragma mark - Lifecycle Methods

- (id)initWithPickerViewDataSource:(NSArray *)pickerViewDataSource
                          selected:(NSArray *)selectedAddressArr
                     completeBlock:(HXSDigitalMobileCustomerPickView)block
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self)
    {
        UIView * parentView = nil;
        UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
        if (parentView == nil) parentView = keyWindow;
        if (parentView == nil) parentView = [UIApplication sharedApplication].windows[0];
        self.parentView = parentView;
        self.block = block;
        
        self.pickerViewDataSource = [[NSMutableArray alloc] initWithArray:pickerViewDataSource];
        self.selectedAddressMArr = [[NSMutableArray alloc] initWithArray:selectedAddressArr];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.3];
        
        if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(btnCancelClick)];
            [self addGestureRecognizer:tap];
        } else {
            UIView *view = [[UIView alloc] initWithFrame:self.frame];
            
            view.backgroundColor = [UIColor clearColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(btnCancelClick)];
            [view addGestureRecognizer:tap];
            
            [self addSubview:view];
        }
        
        self.picketToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
        self.picketToolbar.barStyle = UIBarStyleDefault;
        self.picketToolbar.translucent = NO;
        self.picketToolbar.backgroundColor = HXS_MAIN_COLOR;
        [self.picketToolbar setBackgroundImage:[UIImage imageWithColor:HXS_MAIN_COLOR] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.picketToolbar sizeToFit];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+44, SCREEN_WIDTH, 216)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 10;
        
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelClick)];
        [btnCancel setTintColor:[UIColor grayColor]];
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btnDoneClick)];
        [btnDone setTintColor:[UIColor grayColor]];
        
        UIBarButtonItem* fixedSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace2.width = 10;
        
        NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:fixedSpace,btnCancel,flexible,btnDone,fixedSpace2, nil];
        [self.picketToolbar setItems:arrBarButtoniTems];
        
        [self addSubview:self.pickerView];
        [self addSubview:self.picketToolbar];
    }
    return self;
}

- (void)dealloc
{
    self.block                = nil;
    self.pickerViewDataSource = nil;
    self.selectedAddressMArr  = nil;
}


#pragma mark - Setter Getter Methods

- (HXSDigitalMobileDetailModel *)digitalMobileDetialModel
{
    if (nil == _digitalMobileDetialModel) {
        _digitalMobileDetialModel = [[HXSDigitalMobileDetailModel alloc] init];
    }
    
    return _digitalMobileDetialModel;
}


#pragma mark - Target Methods

- (void)show
{
    [self.parentView addSubview:self];
    
    if ((3 == [self.pickerViewDataSource count])
        && (3 == [self.selectedAddressMArr count])) {
        
        [self.pickerView reloadAllComponents];
        [self selectRowInComponents];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.pickerView setFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
            [self.picketToolbar setFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 216, SCREEN_WIDTH, 44)];
        }];
    } else {
        [self fetchAddress];
    }
}

- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.pickerView setFrame:CGRectMake(0, SCREEN_HEIGHT+44, SCREEN_WIDTH, 216)];
        [self.picketToolbar setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnDoneClick
{
    if (nil != self.block) {
        self.block(self.pickerViewDataSource, self.selectedAddressMArr);
    }
    
    [self hide];
}

- (void)btnCancelClick
{
    [self hide];
}


#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.pickerViewDataSource count]; // 省 城市 区
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self.pickerViewDataSource objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *titleStr = nil;
    
    NSArray *entityArr = [self.pickerViewDataSource objectAtIndex:component];
    
    switch (component) {
        case 0:
        {
            HXSDigitalMobileAddressEntity *entity = [entityArr objectAtIndex:row];
            titleStr = entity.provinceNameStr;
        }
            break;
            
        case 1:
        {
            HXSDigitalMobileCityAddressEntity *entity = [entityArr objectAtIndex:row];
            titleStr = entity.cityNameStr;
        }
            break;
            
        case 2:
        {
            HXSDigitalMobileCountryAddressEntity *entity = [entityArr objectAtIndex:row];
            titleStr = entity.countryNameStr;
        }
            break;
        default:
            break;
    }
    
    return titleStr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"component is %ld, row is %ld", (long)component, (long)row);
    
    switch (component) {
        case 0:
        {
            NSArray *proviceArr = [self.pickerViewDataSource objectAtIndex:component];
            HXSDigitalMobileAddressEntity *proviceEntity = [proviceArr objectAtIndex:row];
            HXSDigitalMobileAddressEntity *selectedProviceEntity = [self.selectedAddressMArr objectAtIndex:component];
            if ([proviceEntity.provinceIDIntNum integerValue] !=  [selectedProviceEntity.provinceIDIntNum integerValue]) {
                [MBProgressHUD showInView:self.parentView];
                
                [self.selectedAddressMArr removeAllObjects];
                [self.selectedAddressMArr addObject:proviceEntity];
                [self fetchCityAddressWithProvinceID:proviceEntity.provinceIDIntNum];
            } else {
                // This is the same as provice
            }
        }
            break;
            
        case 1:
        {
            NSArray *cityArr = [self.pickerViewDataSource objectAtIndex:component];
            HXSDigitalMobileCityAddressEntity *cityEntity = [cityArr objectAtIndex:row];
            HXSDigitalMobileCityAddressEntity *selectedCityEntity = [self.selectedAddressMArr objectAtIndex:component];
            if ([cityEntity.cityIDIntNum integerValue] != [selectedCityEntity.cityIDIntNum integerValue]) {
                [MBProgressHUD showInView:self.parentView];
                
                [self.selectedAddressMArr replaceObjectAtIndex:1 withObject:cityEntity];
                
                [self fetchCountryAddressWithCityID:cityEntity.cityIDIntNum];
            } else {
                // This is the same as City
            }
        }
            break;
            
        case 2:
        {
            NSArray *countryArr = [self.pickerViewDataSource objectAtIndex:component];
            HXSDigitalMobileCountryAddressEntity *countryEntity = [countryArr objectAtIndex:row];
            HXSDigitalMobileCountryAddressEntity *selectedCountryEntity = [self.selectedAddressMArr objectAtIndex:component];
            if ([countryEntity.countryIDIntNum integerValue] != [selectedCountryEntity.countryIDIntNum integerValue]) {
                [self.selectedAddressMArr replaceObjectAtIndex:2 withObject:countryEntity];
            } else {
                // This is the same as Country
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Fetch Address Methods

- (void)fetchAddress
{
    [MBProgressHUD showInView:self.parentView];
    
    __weak typeof(self) weakSelf = self;
    
    [self.digitalMobileDetialModel fetchAddressProvince:^(HXSErrorCode status, NSString *message, NSArray *addressArr) {
        if ((kHXSNoError != status)
            || (0 >= [addressArr count])) {
            [MBProgressHUD hideHUDForView:weakSelf.parentView animated:YES];
            if (0 >= [message length]) {
                message = @"获取数据失败";
            }
            NSTimeInterval time = 1.5f;
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.parentView status:message afterDelay:time];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hide];
            });
            
            return ;
        }
        
        BOOL hasSelected = NO;
        HXSDigitalMobileAddressEntity *selectedEntity = [weakSelf.selectedAddressMArr firstObject];
        if ((nil != selectedEntity)
            && [selectedEntity isKindOfClass:[HXSDigitalMobileAddressEntity class]]) {
            for (HXSDigitalMobileAddressEntity *entity in addressArr) {
                if ([entity.provinceIDIntNum integerValue] == [selectedEntity.provinceIDIntNum integerValue]) {
                    hasSelected = YES;
                    break;
                }
            }
        }
        
        if (hasSelected) {
            [weakSelf.selectedAddressMArr replaceObjectAtIndex:0 withObject:selectedEntity];
        } else {
            selectedEntity = [addressArr firstObject];
            
            [weakSelf.selectedAddressMArr removeAllObjects];
            [weakSelf.selectedAddressMArr addObject:selectedEntity];
        }
        
        [weakSelf.pickerViewDataSource removeAllObjects];
        [weakSelf.pickerViewDataSource addObject:addressArr];
        
        
        [self fetchCityAddressWithProvinceID:selectedEntity.provinceIDIntNum];
    }];
}

- (void)fetchCityAddressWithProvinceID:(NSNumber *)proviceIDIntNum
{
    __weak typeof(self) weakSelf = self;
    
    [self.digitalMobileDetialModel fetchAddressCityWithProvice:proviceIDIntNum
                                                     completed:^(HXSErrorCode status, NSString *message, NSArray *addressArr) {
                                                         if ((kHXSNoError != status)
                                                             || (0 >= [addressArr count])) {
                                                             [MBProgressHUD hideHUDForView:weakSelf.parentView animated:YES];
                                                             
                                                             if (0 >= [message length]) {
                                                                 message = @"获取数据失败";
                                                             }
                                                             NSTimeInterval time = 1.5f;
                                                             [MBProgressHUD showInViewWithoutIndicator:weakSelf.parentView status:message afterDelay:time];
                                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                 [weakSelf hide];
                                                             });
                                                             
                                                             return ;
                                                         }
                                                         
                                                         BOOL hasSelected = NO;
                                                         HXSDigitalMobileCityAddressEntity *selectedEntity = [weakSelf.selectedAddressMArr objectAtIndex:1];
                                                         if ((nil != selectedEntity)
                                                             && [selectedEntity isKindOfClass:[HXSDigitalMobileCityAddressEntity class]]) {
                                                             for (HXSDigitalMobileCityAddressEntity *entity in addressArr) {
                                                                 if ([entity.cityIDIntNum integerValue] == [selectedEntity.cityIDIntNum integerValue]) {
                                                                     hasSelected = YES;
                                                                     break;
                                                                 }
                                                             }
                                                         }
                                                         
                                                         if (!hasSelected) {
                                                             selectedEntity = [addressArr firstObject];
                                                         }
                                                         
                                                         if (2 > [weakSelf.pickerViewDataSource count]) {
                                                             [weakSelf.pickerViewDataSource addObject:addressArr];
                                                         } else {
                                                             [weakSelf.pickerViewDataSource replaceObjectAtIndex:1 withObject:addressArr];
                                                         }
                                                         
                                                         if (2 > [weakSelf.selectedAddressMArr count]) {
                                                             [weakSelf.selectedAddressMArr addObject:selectedEntity];
                                                         } else {
                                                             [weakSelf.selectedAddressMArr replaceObjectAtIndex:1 withObject:selectedEntity];
                                                         }
                                                         
                                                         [weakSelf fetchCountryAddressWithCityID:selectedEntity.cityIDIntNum];
                                                         
                                                     }];
}

- (void)fetchCountryAddressWithCityID:(NSNumber *)cityIDIntNum
{
    __weak typeof(self) weakSelf = self;
    
    [self.digitalMobileDetialModel fetchAddressCountryWithCity:cityIDIntNum
                                                     completed:^(HXSErrorCode status, NSString *message, NSArray *addressArr) {
                                                         [MBProgressHUD hideHUDForView:weakSelf.parentView animated:YES];
                                                         
                                                         if ((kHXSNoError != status)
                                                             || (0 >= [addressArr count])) {
                                                             if (0 >= [message length]) {
                                                                 message = @"获取数据失败";
                                                             }
                                                             
                                                             NSTimeInterval time = 1.5f;
                                                             [MBProgressHUD showInViewWithoutIndicator:weakSelf.parentView status:message afterDelay:time];
                                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                 [weakSelf hide];
                                                             });
                                                             
                                                             return ;
                                                         }
                                                         
                                                         BOOL hasSelected = NO;
                                                         HXSDigitalMobileCountryAddressEntity *selectedEntity = [weakSelf.selectedAddressMArr objectAtIndex:2];
                                                         if ((nil != selectedEntity)
                                                             &&[selectedEntity isKindOfClass:[HXSDigitalMobileCountryAddressEntity class]]) {
                                                             for (HXSDigitalMobileCountryAddressEntity *entity in addressArr) {
                                                                 if ([entity.countryIDIntNum integerValue] == [selectedEntity.countryIDIntNum integerValue]) {
                                                                     hasSelected = YES;
                                                                     break;
                                                                 }
                                                             }
                                                         }
                                                         
                                                         if (!hasSelected) {
                                                             selectedEntity = [addressArr firstObject];
                                                         }
                                                         
                                                         if (3 > [weakSelf.pickerViewDataSource count]) {
                                                             [weakSelf.pickerViewDataSource addObject:addressArr];
                                                         } else {
                                                             [weakSelf.pickerViewDataSource replaceObjectAtIndex:2 withObject:addressArr];
                                                         }
                                                         
                                                         if (3 > [weakSelf.selectedAddressMArr count]) {
                                                             [weakSelf.selectedAddressMArr addObject:selectedEntity];
                                                         } else {
                                                             [weakSelf.selectedAddressMArr replaceObjectAtIndex:2 withObject:selectedEntity];
                                                         }
                                                         
                                                         [weakSelf show];
                                                     }];
}

- (void)selectRowInComponents
{
    NSArray *provinceArr = [self.pickerViewDataSource objectAtIndex:0];
    HXSDigitalMobileAddressEntity *provinceEntity = [self.selectedAddressMArr objectAtIndex:0];
    for (int selectedProvince = 0; selectedProvince < [provinceArr count]; selectedProvince++) {
        HXSDigitalMobileAddressEntity *entity = [provinceArr objectAtIndex:selectedProvince];
        if ([entity.provinceIDIntNum integerValue] == [provinceEntity.provinceIDIntNum integerValue]) {
            [self.pickerView selectRow:selectedProvince inComponent:0 animated:YES];
            break;
        }
    }
    
    NSArray *cityArr = [self.pickerViewDataSource objectAtIndex:1];
    HXSDigitalMobileCityAddressEntity *cityEntity = [self.selectedAddressMArr objectAtIndex:1];
    
    for (int i = 0; i < [cityArr count]; i++) {
        HXSDigitalMobileCityAddressEntity *entity = [cityArr objectAtIndex:i];
        if ([entity.cityIDIntNum integerValue] == [cityEntity.cityIDIntNum integerValue]) {
            [self.pickerView selectRow:i inComponent:1 animated:YES];
            break;
        }
    }
    NSArray *countryArr = [self.pickerViewDataSource objectAtIndex:2];
    HXSDigitalMobileCountryAddressEntity *countryEntity = [self.selectedAddressMArr objectAtIndex:2];
    
    for (int i = 0; i < [countryArr count]; i++) {
        HXSDigitalMobileCountryAddressEntity *entity = [countryArr objectAtIndex:i];
        if ([entity.countryIDIntNum integerValue] == [countryEntity.countryIDIntNum integerValue]) {
            [self.pickerView selectRow:i inComponent:2 animated:YES];
            
            break;
        }
    }
}

@end
