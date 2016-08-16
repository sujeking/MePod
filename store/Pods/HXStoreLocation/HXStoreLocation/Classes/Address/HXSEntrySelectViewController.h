//
//  HXSEntrySelectViewController.h
//  store
//
//  Created by chsasaw on 15/2/3.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSLocationManager.h"
#import "HXSShopModel.h"

@class HXSDormEntry, HXSCity;

@class HXSSite, HXSBuildingEntry ,HXSDormNegoziante;

@interface HXSEntrySelectViewController : HXSBaseViewController

@property (nonatomic, strong) HXSBuildingEntry *building;
@property (nonatomic, copy) GoToDestinationCompletion completionBlock;
@property (nonatomic, weak) IBOutlet UIView *titleButtonView;
@property (nonatomic, weak) IBOutlet UIButton *titleButton;

- (void)updateAddressList;

@end