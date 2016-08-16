//
//  HXSAddressDecorationView.m
//  store
//
//  Created by hudezhi on 15/11/2.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSAddressDecorationView.h"

#import "UIViewController+Extensions.h"

@interface HXSAddressDecorationView () {
    UIViewController *_currentController;
}

@property (nonatomic, weak) id<HXSAddressSelectionDelegate> selectionDelegate;

@property (nonatomic, strong) HXSSelectCityViewController *cityCtrl;
@property (nonatomic, strong) HXSSiteSelectViewController *siteCtrl;
@property (nonatomic, strong) HXSBuildingAreaSelectVC *buildingAreaCtrl;
@property (nonatomic, strong) HXSBuildingSelectViewController *buildingCtrl;

@property (nonatomic, strong) NSMutableArray *ctrlArray;
@property (nonatomic, assign) HXSAddressSelectionType currentSelection;

@property (nonatomic) HXSAddressSelectionType lastType;

- (void)setup;

@end

@implementation HXSAddressDecorationView

- (instancetype)initWithDelegate:(id<HXSAddressSelectionDelegate>) delegate
             containerController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        
        self.pagingEnabled = YES;
        self.delegate = self;
        self.selectionDelegate = delegate;
        self.containerController = controller;
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _currentController.view.frame = self.bounds;
    
    if(self.ctrlArray) {
        CGSize contentSize = CGSizeMake(self.bounds.size.width * self.ctrlArray.count, self.bounds.size.height);
        self.contentSize = contentSize;
        for(UIViewController *ctrl in self.ctrlArray) {
            NSInteger index = [self.ctrlArray indexOfObject:ctrl];
            ctrl.view.frame = CGRectMake(self.bounds.size.width * index, 0, self.bounds.size.width, self.bounds.size.height);
        }
    }
}

- (void)dealloc
{
    self.selectionDelegate  = nil;
    self.city               = nil;
    self.site               = nil;
    self.buildingArea       = nil;
    self.building           = nil;
    
    self.cityCtrl           = nil;
    self.siteCtrl           = nil;
    self.buildingAreaCtrl   = nil;
    self.buildingCtrl       = nil;
    self.ctrlArray          = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = self.contentOffset.x/self.bounds.size.width;
    UIViewController *ctrl = [self.ctrlArray objectAtIndex:index];
    if(ctrl == self.cityCtrl) {
        self.currentSelection = HXSAddressSelectionCity;
    } else if(ctrl == self.siteCtrl) {
        self.currentSelection = HXSAddressSelectionSite;
    } else if(ctrl == self.buildingAreaCtrl) {
        self.currentSelection = HXSAddressSelectionBuildingArea;
    } else {
        self.currentSelection = HXSAddressSelectionBuilding;
    }
    if ([_selectionDelegate respondsToSelector:@selector(addressDecorationViewCurrentSelectionChange:)]) {
        [_selectionDelegate addressDecorationViewCurrentSelectionChange:self.currentSelection];
    }
}


#pragma mark - getter/setter

- (HXSSelectCityViewController *)cityCtrl
{
    if(!_cityCtrl){
        _cityCtrl = [HXSSelectCityViewController controllerFromXibWithModuleName:@"HXStoreLocation"];
        _cityCtrl.delegate = _selectionDelegate;
        _cityCtrl.selectCity = self.city;
        [self addSubview:_cityCtrl.view];
    }
    return _cityCtrl;
}

- (HXSSiteSelectViewController *)siteCtrl
{
    if (_siteCtrl == nil) {
        _siteCtrl = [HXSSiteSelectViewController controllerFromXibWithModuleName:@"HXStoreLocation"];
        _siteCtrl.delegate = _selectionDelegate;
        _siteCtrl.curCity = self.city;
        _siteCtrl.selectedSite = self.site;
        [self addSubview:_siteCtrl.view];
    }
    
    return _siteCtrl;
}

- (HXSBuildingAreaSelectVC *)buildingAreaCtrl
{
    if (_buildingAreaCtrl == nil) {
        _buildingAreaCtrl = [HXSBuildingAreaSelectVC controllerFromXibWithModuleName:@"HXStoreLocation"];
        _buildingAreaCtrl.delegate = _selectionDelegate;
        _buildingAreaCtrl.site = self.site;
        _buildingAreaCtrl.selectedBuildingArea = self.buildingArea;
        [self addSubview:_buildingAreaCtrl.view];
    }
    
    return _buildingAreaCtrl;
}

- (HXSBuildingSelectViewController *)buildingCtrl
{
    if (_buildingCtrl == nil) {
        _buildingCtrl = [HXSBuildingSelectViewController controllerFromXibWithModuleName:@"HXStoreLocation"];
        _buildingCtrl.delegate = _selectionDelegate;
        _buildingCtrl.buildingArea = self.buildingArea;
        _buildingCtrl.selectedBuilding = self.building;
        [self addSubview:_buildingCtrl.view];
    }
    
    return _buildingCtrl;
}

- (void)setCity:(HXSCity *)city
{
    _city = city;
    
    if(_cityCtrl)
        _cityCtrl.selectCity = city;
    
    if(_siteCtrl)
        _siteCtrl.curCity = city;
}

- (void)setSite:(HXSSite *)site
{
    _site = site;
    if(_siteCtrl)
        _siteCtrl.selectedSite = site;
    
    if(_buildingAreaCtrl)
        _buildingAreaCtrl.site = site;
}

- (void)setBuildingArea:(HXSBuildingArea *)buildingArea
{
    _buildingArea = buildingArea;
    if(_buildingAreaCtrl)
        _buildingAreaCtrl.selectedBuildingArea = buildingArea;
    
    if(_buildingCtrl)
        _buildingCtrl.buildingArea = buildingArea;
}

- (void)setBuilding:(HXSBuildingEntry *)building
{
    _building = building;
}

- (void)setSelectionDestination:(HXSAddressSelectionType)selectionDestination
{
    _selectionDestination = selectionDestination;
    switch (selectionDestination) {
        case HXSAddressSelectionCity:
        {
            self.ctrlArray = [NSMutableArray arrayWithObjects:self.cityCtrl, nil];
            
            if(_siteCtrl) {
                [_siteCtrl.view removeFromSuperview];
                _siteCtrl = nil;
            }
            
            if(_buildingAreaCtrl) {
                [_buildingAreaCtrl.view removeFromSuperview];
                _buildingAreaCtrl = nil;
            }
            
            if(_buildingCtrl) {
                [_buildingCtrl.view removeFromSuperview];
                _buildingCtrl = nil;
            }
        }
            break;
        case HXSAddressSelectionSite:
        {
            self.ctrlArray = [NSMutableArray arrayWithObjects:self.cityCtrl,self.siteCtrl,nil];
            if(_buildingAreaCtrl){
                [_buildingAreaCtrl.view removeFromSuperview];
                _buildingAreaCtrl = nil;
            }
            
            if(_buildingCtrl){
                [_buildingCtrl.view removeFromSuperview];
                _buildingCtrl = nil;
            }
        }
            break;
        case HXSAddressSelectionBuildingArea:
        {
            self.ctrlArray = [NSMutableArray arrayWithObjects:self.cityCtrl,self.siteCtrl,self.buildingAreaCtrl,nil];
            
            if(_buildingCtrl){
                [_buildingCtrl.view removeFromSuperview];
                _buildingCtrl = nil;
            }
        
        }
            break;
        case HXSAddressSelectionBuilding:
        {
            self.ctrlArray = [NSMutableArray arrayWithObjects:self.cityCtrl,self.siteCtrl,self.buildingAreaCtrl,self.buildingCtrl,nil];
        }
            break;
        default:
            break;
    }
}


#pragma mark - Private Method

- (void)setup
{
    _lastType = -1;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}

- (UIViewController *)controllerForAddressType:(HXSAddressSelectionType)type
{
    switch (type) {
        case HXSAddressSelectionCity:
        {
            return self.cityCtrl;
        }
            break;
        case HXSAddressSelectionSite:
        {
            self.siteCtrl.curCity = _city;
            [self.siteCtrl updateAddressList];
            
            return self.siteCtrl;
        }
            break;
        case HXSAddressSelectionBuildingArea:
        {
            self.buildingAreaCtrl.site = _site;
            [self.buildingAreaCtrl updateAddressList];
            
            return self.buildingAreaCtrl;
        }
            break;
        case HXSAddressSelectionBuilding:
        {
            self.buildingCtrl.buildingArea = _buildingArea;
            [self.buildingCtrl updateAddressList];
            
            return self.buildingCtrl;
        }
         break;
        default:
            break;
    }
    return nil;
}


#pragma mark - Public Method

- (void)showAddressSelectionType:(HXSAddressSelectionType)type
{
    if((int)type < self.ctrlArray.count) {
        
        switch (type) {
            case HXSAddressSelectionCity:
                
                break;
            case HXSAddressSelectionSite:
                [self.siteCtrl updateAddressList];
                break;
            case HXSAddressSelectionBuildingArea:
                [self.buildingAreaCtrl updateAddressList];
                break;
            case HXSAddressSelectionBuilding:
                [self.buildingCtrl updateAddressList];
                break;
            default:
                break;
        }
        
        CGSize contentSize = CGSizeMake(self.bounds.size.width * self.ctrlArray.count, self.bounds.size.height);
        self.contentSize = contentSize;
        for(UIViewController *ctrl in self.ctrlArray) {
            NSInteger index = [self.ctrlArray indexOfObject:ctrl];
            ctrl.view.frame = CGRectMake(self.bounds.size.width * index, 0, self.bounds.size.width, self.bounds.size.height);
        }
        
        CGRect visibleReact = CGRectMake(self.bounds.size.width * type, 0, self.bounds.size.width, self.bounds.size.height);
        [self scrollRectToVisible:visibleReact animated:YES];
        if ([_selectionDelegate respondsToSelector:@selector(addressDecorationViewCurrentSelectionChange:)]) {
            [_selectionDelegate addressDecorationViewCurrentSelectionChange:type];
        }
    }
}

@end
