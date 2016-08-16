//
//  HXSBorrowPurposeItem.m
//  store
//
//  Created by hudezhi on 15/8/7.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowPurposeItem.h"

#import "HXMacrosUtils.h"

static NSString *BorrowPurposeCodeKey  = @"purposeCode";
static NSString *BorrowPurposeNameKey  = @"purposeName";
static NSString *BorrowPurposeImageKey = @"purposeImage";

@implementation HXSBorrowPurposeItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.purposeCode = @"";
        self.purposeName = @"";
        self.purposeImageUrlStr = @"";
        
        if (DIC_HAS_STRING(dictionary, @"code")) {
            self.purposeCode = [dictionary objectForKey:@"code"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"name")) {
            self.purposeName = [dictionary objectForKey:@"name"];
        }
        
        if (DIC_HAS_STRING(dictionary, @"image")) {
            self.purposeImageUrlStr = [dictionary objectForKey:@"image"];
        }
    }
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_purposeCode forKey:BorrowPurposeCodeKey];
    [aCoder encodeObject:_purposeName forKey:BorrowPurposeNameKey];
    [aCoder encodeObject:_purposeImageUrlStr forKey:BorrowPurposeImageKey];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.purposeCode        = [aDecoder decodeObjectForKey:BorrowPurposeCodeKey];
        self.purposeName        = [aDecoder decodeObjectForKey:BorrowPurposeNameKey];
        self.purposeImageUrlStr = [aDecoder decodeObjectForKey:BorrowPurposeImageKey];
    }
    
    return self;
}

@end
