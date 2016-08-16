//
//  HXSSiteSelectViewController.h
//  store
//
//  Created by chsasaw on 14/10/17.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSSite.h"
#import "HXSZone.h"
#import "HXSCity.h"

@protocol HXSSiteSelectionDelegate <NSObject>

- (void)addressSelectSite:(HXSSite*)site;

@end

@interface HXSSiteSelectViewController : HXSBaseViewController

@property (nonatomic, strong) HXSCity * curCity;
@property (nonatomic, strong) HXSSite * selectedSite;

@property (nonatomic, weak) id<HXSSiteSelectionDelegate> delegate;

- (void)updateAddressList;
- (void)reloadData;

@end