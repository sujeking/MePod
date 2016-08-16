//
//  HXSEmergencyInforViewController.m
//  59dorm
//
//  Created by J006 on 16/7/13.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

static CGFloat const headerViewHeight   = 40;
static CGFloat const sectionViewHeight  = 20;
static CGFloat const nextStepViewHeight = 84;

typedef NS_ENUM(NSInteger,HXSEmergencyInforSectionIndex){
    HXSEmergencyInforSectionIndexParent              = 0,//父母
    HXSEmergencyInforSectionIndexRoommate            = 1,//室友
    HXSEmergencyInforSectionIndexClassmate           = 2,//同学
    HXSEmergencyInforSectionIndexBottom              = 3,//底部确认
};

#import "HXSEmergencyInforViewController.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

//view
#import "HXSSubscribeHeaderFooterView.h"
#import "HXSEmergencyInforCell.h"
#import "HXSEmergencyInputCell.h"
#import "HXSEmergencyBottomCell.h"
#import "HXSSubscribeInputTableViewCell.h"

//model
#import "HXSContactManager.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface HXSEmergencyInforViewController ()<ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView                        *mainTableView;
@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *headerView;
@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *footerView;
@property (nonatomic, strong) UIRenderingButton                         *submitButton;
@property (nonatomic, strong) NSMutableArray                            *contractArray;

@property (nonatomic, strong) HXSEmergencyInforCell                     *parentInforCell;
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *parentNameCell;
@property (nonatomic, strong) HXSEmergencyInputCell                     *parentPhoneCell;

@property (nonatomic, strong) HXSEmergencyInforCell                     *roommateInforCell;
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *roommateNameCell;
@property (nonatomic, strong) HXSEmergencyInputCell                     *roommatePhoneCell;

@property (nonatomic, strong) HXSEmergencyInforCell                     *classmateInforCell;
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *classmateNameCell;
@property (nonatomic, strong) HXSEmergencyInputCell                     *classmatePhoneCell;

@property (nonatomic, strong) NSArray<UITableViewCell *>                *sectionParentArray;
@property (nonatomic, strong) NSArray<UITableViewCell *>                *sectionRoommateArray;
@property (nonatomic, strong) NSArray<UITableViewCell *>                *sectionClassmateArray;

@end

@implementation HXSEmergencyInforViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initTheMainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Create

+ (instancetype)createEmergencyInforVC
{
    HXSEmergencyInforViewController *vc = [HXSEmergencyInforViewController controllerFromXib];
    
    return vc;
}


#pragma mark - init

- (void)initTheMainTableView
{
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSEmergencyInforCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSEmergencyInforCell class])];
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSSubscribeInputTableViewCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSSubscribeInputTableViewCell class])];
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSEmergencyInputCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSEmergencyInputCell class])];
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSEmergencyBottomCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSEmergencyBottomCell class])];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 4;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section)
    {
        case HXSEmergencyInforSectionIndexRoommate:
        {
            cell = [self.sectionRoommateArray objectAtIndex:indexPath.row];
        }
            break;
            
        case HXSEmergencyInforSectionIndexClassmate:
        {
            cell = [self.sectionClassmateArray objectAtIndex:indexPath.row];
        }
            break;
            
        case HXSEmergencyInforSectionIndexBottom:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSEmergencyBottomCell class]) forIndexPath:indexPath];
        }
            break;
            
        default:
        {
            cell = [self.sectionParentArray objectAtIndex:indexPath.row];
        }
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = cellInputHeight;
    
    if(indexPath.section == HXSEmergencyInforSectionIndexBottom)
    {
        height = nextStepViewHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSEmergencyInforSectionIndexParent) {
        height = headerViewHeight;
    } else if(section == HXSEmergencyInforSectionIndexRoommate
            || section == HXSEmergencyInforSectionIndexClassmate) {
        height = sectionViewHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == HXSEmergencyInforSectionIndexParent
       || section == HXSEmergencyInforSectionIndexRoommate
       || section == HXSEmergencyInforSectionIndexClassmate) {
        return self.headerView;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == HXSEmergencyInforSectionIndexBottom) {
        HXSEmergencyBottomCell *bottomCell = (HXSEmergencyBottomCell *)cell;
        _submitButton = bottomCell.confirmButton;
        [_submitButton addTarget:self
                          action:@selector(confirmAction)
                forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - networking

/**
 *  提交紧急联系人信息网络请求
 */
- (void)submitInfoNetworking
{
    
}


#pragma mark - CheckCurrentInput

/**
 *  检测输入框中的数据从而enable 下一步按钮
 */
- (void)checkInputInfoValidation
{
    _submitButton.enabled = [self isBasicInfoValid];
}

- (BOOL)isBasicInfoValid
{
    BOOL isEnable = YES;
    
    return isEnable;
}


#pragma mark - Button Action

/**
 *  确认提交
 */
- (void)confirmAction
{

}

/**
 *  获取手机联系人
 */
- (void)getThePhoneContacts
{
    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
    nav.peoplePickerDelegate = self;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    CFStringRef cfName = ABRecordCopyCompositeName(person);
    NSString *nameStr = [NSString stringWithString:(__bridge NSString *)cfName];
    CFRelease(cfName);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    DLog(@"phoneNO = %@", phoneNO);
    DLog(@"nameStr = %@", nameStr);
    return YES;
}


#pragma mark - getter setter

- (HXSSubscribeHeaderFooterView *)headerView
{
    if(!_headerView) {
        _headerView = [HXSSubscribeHeaderFooterView createSubscribeHeaderFooterViewWithContent:@"请填写三个联系人的信息"
                                                                                     andHeight:headerViewHeight
                                                                                   andFontSize:13
                                                                                  andTextColor:[UIColor colorWithRGBHex:0x07A9FA]];
    }
    
    return _headerView;
}

- (HXSSubscribeHeaderFooterView *)footerView
{
    if(!_footerView) {
        _footerView = [HXSSubscribeHeaderFooterView createSubscribeHeaderFooterViewWithContent:@""
                                                                                     andHeight:sectionViewHeight
                                                                                   andFontSize:13
                                                                                  andTextColor:[UIColor colorWithRGBHex:0x898989]];
    }
    
    return _footerView;
}

- (HXSEmergencyInforCell *)parentInforCell
{
    if(!_parentInforCell) {
        _parentInforCell = [HXSEmergencyInforCell createEmergencyInforCell];
        [_parentInforCell.titleLabel setText:@"父亲/母亲信息"];
    }
    return _parentInforCell;
}

- (HXSEmergencyInforCell *)roommateInforCell
{
    if(!_roommateInforCell) {
        _roommateInforCell = [HXSEmergencyInforCell createEmergencyInforCell];
        [_roommateInforCell.titleLabel setText:@"室友信息"];
    }
    return _roommateInforCell;
}

- (HXSEmergencyInforCell *)classmateInforCell
{
    if(!_classmateInforCell) {
        _classmateInforCell = [HXSEmergencyInforCell createEmergencyInforCell];
        [_classmateInforCell.titleLabel setText:@"同学信息"];
    }
    return _classmateInforCell;
}

- (HXSSubscribeInputTableViewCell *)parentNameCell
{
    if(!_parentNameCell) {
        _parentNameCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_parentNameCell.keyLabel setText:@"姓名"];
        [_parentNameCell.valueTextField addTarget:self
                                     action:@selector(checkInputInfoValidation)
                           forControlEvents:UIControlEventEditingChanged];

    }
    return _parentNameCell;
}

- (HXSSubscribeInputTableViewCell *)roommateNameCell
{
    if(!_roommateNameCell) {
        _roommateNameCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_roommateNameCell.keyLabel setText:@"姓名"];
        [_roommateNameCell.valueTextField addTarget:self
                                           action:@selector(checkInputInfoValidation)
                                 forControlEvents:UIControlEventEditingChanged];
        
    }
    return _roommateNameCell;
}

- (HXSSubscribeInputTableViewCell *)classmateNameCell
{
    if(!_classmateNameCell) {
        _classmateNameCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_classmateNameCell.keyLabel setText:@"姓名"];
        [_classmateNameCell.valueTextField addTarget:self
                                             action:@selector(checkInputInfoValidation)
                                   forControlEvents:UIControlEventEditingChanged];
        
    }
    return _classmateNameCell;
}

- (HXSEmergencyInputCell *)parentPhoneCell
{
    if(!_parentPhoneCell) {
        _parentPhoneCell = [HXSEmergencyInputCell createEmergencyInputCell];
        [_parentPhoneCell.titleLabel setText:@"手机号"];
        [_parentPhoneCell.inputTextField addTarget:self
                                              action:@selector(checkInputInfoValidation)
                                    forControlEvents:UIControlEventEditingChanged];
        [_parentPhoneCell.inputTextField setKeyboardType:UIKeyboardTypePhonePad];
        [_parentPhoneCell.contractButton addTarget:self
                                            action:@selector(getThePhoneContacts)
                                  forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _parentPhoneCell;
}

- (HXSEmergencyInputCell *)roommatePhoneCell
{
    if(!_roommatePhoneCell) {
        _roommatePhoneCell = [HXSEmergencyInputCell createEmergencyInputCell];
        [_roommatePhoneCell.titleLabel setText:@"手机号"];
        [_roommatePhoneCell.inputTextField addTarget:self
                                            action:@selector(checkInputInfoValidation)
                                  forControlEvents:UIControlEventEditingChanged];
        [_roommatePhoneCell.inputTextField setKeyboardType:UIKeyboardTypePhonePad];
        
    }
    return _roommatePhoneCell;
}

- (HXSEmergencyInputCell *)classmatePhoneCell
{
    if(!_classmatePhoneCell) {
        _classmatePhoneCell = [HXSEmergencyInputCell createEmergencyInputCell];
        [_classmatePhoneCell.titleLabel setText:@"手机号"];
        [_classmatePhoneCell.inputTextField addTarget:self
                                              action:@selector(checkInputInfoValidation)
                                    forControlEvents:UIControlEventEditingChanged];
        [_classmatePhoneCell.inputTextField setKeyboardType:UIKeyboardTypePhonePad];
        
    }
    return _classmatePhoneCell;
}

@end
