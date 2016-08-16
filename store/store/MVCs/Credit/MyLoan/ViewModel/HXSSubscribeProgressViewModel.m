//
//  HXSSubscribeProgressViewModel.m
//  59dorm
//
//  Created by J006 on 16/7/11.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeProgressViewModel.h"

@interface HXSSubscribeProgressViewModel()

@property (nonatomic, strong) NSArray<HXSSubscribeProgressSingleModel *> *modelTotalArray;

@end

@implementation HXSSubscribeProgressViewModel

+ (instancetype)createSubscribeProgressViewModelWithCurrentIndex:(NSInteger)index;
{
    HXSSubscribeProgressViewModel *viewModel = [[HXSSubscribeProgressViewModel alloc]init];
    viewModel.modelTotalArray = [[NSArray alloc]init];
    [viewModel addModelToTotalArray:viewModel.modelTotalArray];
    
    return viewModel;
}

- (NSArray<HXSSubscribeProgressSingleModel *> *)getModelArray
{
    if(!_modelTotalArray) {
        return nil;
    }
    
    return _modelTotalArray;
}

#pragma mark init

- (void)addModelToTotalArray:(NSArray *)modelTotalArray
{
    if(!_modelTotalArray) {
        return;
    }
    
    HXSSubscribeProgressSingleModel *idModel = [[HXSSubscribeProgressSingleModel alloc]init];
    idModel.contentStr = @"身份信息";
    idModel.bigImageNameStr = @"ic_shenfenxinxi_selected_big";
    idModel.smallImageNameStr = @"ic_shenfenxinxi_selected";
    idModel.notPassSmallImageNameStr = @"ic_shenfenxinxi_selected";
    
    HXSSubscribeProgressSingleModel *schoolModel = [[HXSSubscribeProgressSingleModel alloc]init];
    schoolModel.contentStr = @"学籍消息";
    schoolModel.bigImageNameStr = @"ic_xuejixinxi_selected_big";
    schoolModel.smallImageNameStr = @"ic_xuejixinxi_selected";
    schoolModel.notPassSmallImageNameStr = @"ic_xuejixinxi_normal";
    
    HXSSubscribeProgressSingleModel *bankModel = [[HXSSubscribeProgressSingleModel alloc]init];
    bankModel.contentStr = @"银行卡信息";
    bankModel.bigImageNameStr = @"ic_yinhangkaxinxi_normal_big";
    bankModel.smallImageNameStr = @"ic_yinhangkaxinxi_selected";
    bankModel.notPassSmallImageNameStr = @"ic_yinhangkaxinxi_normal";
    
    HXSSubscribeProgressSingleModel *authorModel = [[HXSSubscribeProgressSingleModel alloc]init];
    authorModel.contentStr = @"授权信息";
    authorModel.bigImageNameStr = @"ic_shouquanxinxi_normal_big";
    authorModel.smallImageNameStr = @"ic_shouquanxinxi_selected";
    authorModel.notPassSmallImageNameStr = @"ic_shouquanxinxi_normal";
    
    HXSSubscribeProgressSingleModel *submitModel = [[HXSSubscribeProgressSingleModel alloc]init];
    submitModel.contentStr = @"提交成功";
    submitModel.bigImageNameStr = @"ic_tijiaochenggong_selected_big";
    submitModel.smallImageNameStr = @"ic_tijiaochenggong_normal";
    submitModel.notPassSmallImageNameStr = @"ic_tijiaochenggong_normal";
    
    _modelTotalArray = @[idModel,schoolModel,bankModel,authorModel,submitModel];
}

@end
