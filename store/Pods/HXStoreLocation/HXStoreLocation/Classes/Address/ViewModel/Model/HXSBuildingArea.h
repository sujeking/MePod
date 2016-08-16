//
//  HXSBuildingArea.h
//  Pods
//
//  Created by 格格 on 16/7/15.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

#import "HXBaseJSONModel.h"
#import "HXSBuildingEntity.h"

@protocol HXSBuildingArea

@end

@interface HXSBuildingArea : HXBaseJSONModel

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray<HXSBuildingNameEntity> *buildingsArr;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

- (NSDictionary *)encodeAsDic;


@end
