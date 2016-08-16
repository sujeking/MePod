//
//  HXSBorrowSubmitInfo.h
//  store
//
//  Created by hudezhi on 15/8/3.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSBorrowPurposeItem.h"
#import "HXSBorrowMonthlyMortgageInfo.h"
#import "HXSBankCardItem.h"
/*
 * Borrow Contact information
*/
@interface HXSBorrowContactInfo : NSObject<NSCoding>

@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *contactPhone;
@property (nonatomic, strong) NSString *relationShip;

+ (instancetype) borrowContactInfoWithName:(NSString *)name phoneNum: (NSString *)phoneNum relationShip:(NSString *)relationship;

@end



/*
 * Borrow Submit information when borrow
 */

@interface HXSBorrowSubmitInfo : NSObject <NSCoding>

// data for step 1
@property (nonatomic, strong) HXSBorrowPurposeItem *purpose;
@property (nonatomic, strong) HXSInstallmentSelectEntity *installmentSelectEntity;
@property (nonatomic, assign) double amount;

// data for step 2
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *idCardNum;
@property (nonatomic, strong) HXSBankCardItem *boundBankCard;

// data for step 3
@property (nonatomic, strong) NSString *collegeName;
@property (nonatomic, strong) NSString *entranceYear;
@property (nonatomic, strong) NSString *educationBackground;
@property (nonatomic, strong) NSString *majorName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *emailStr;

// data for step 4 (Borrow Contact List)
@property (nonatomic, strong) NSArray *contactList;

@property (nonatomic, readonly) NSDictionary* dictionary;

@property (nonatomic, strong) NSDictionary *contactDictionary;

@end
