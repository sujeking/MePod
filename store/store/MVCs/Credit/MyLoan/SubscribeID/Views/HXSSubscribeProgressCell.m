//
//  HXSSubscribeProgressCell.m
//  59dorm
//
//  Created by J006 on 16/7/8.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeProgressCell.h"
#import "HXSSubscribeProgressViewModel.h"
#import "HXSSubscribeProgressSingleView.h"

@interface HXSSubscribeProgressCell()

@property (nonatomic, assign) NSInteger curretnIndex;

@end

@implementation HXSSubscribeProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - init

- (void)initSubscribeProgressCellWithCurrentStepIndex:(NSInteger)stepIndex
{
    
    _curretnIndex = stepIndex;
    
    HXSSubscribeProgressViewModel *model = [HXSSubscribeProgressViewModel createSubscribeProgressViewModelWithCurrentIndex:stepIndex];
    
    NSArray<HXSSubscribeProgressSingleModel *>  *modelArray = [model getModelArray];
    
    HXSSubscribeProgressSingleViewQueueType currentQueueType;
    if(stepIndex == 0) {
        currentQueueType = HXSSubscribeProgressSingleViewQueueTypeFirst;
    } else if(stepIndex == [modelArray count]-1) {
        currentQueueType = HXSSubscribeProgressSingleViewQueueTypeLast;
    } else {
        currentQueueType = HXSSubscribeProgressSingleViewQueueTypeNormal;
    }
    
    UIView *tempView;
    for (NSInteger i = 0; i < [modelArray count]; i++)
    {
        HXSSubscribeProgressSingleModel *singleModel = [modelArray objectAtIndex:i];
        HXSSubscribeProgressSingleView *singleView = [HXSSubscribeProgressSingleView
                                                      createSubscribeProgressSingleViewWithContent:singleModel.contentStr
                                                                                                               andEnableImageName:singleModel.smallImageNameStr
                                                                                                              andDisableImageName:singleModel.notPassSmallImageNameStr
                                                                                                              andCurrentImageName:singleModel.bigImageNameStr
                                                                                                                          andType:[self getTheQueueTypeWithModel:singleModel
                                                                                                                                                        andArray:modelArray]
                                                                                                                   andCurrentStep:[self getTheCurrentTypeWithModel:singleModel
                                                                                                                                                          andArray:modelArray]
                                                                                                                         andWidth:SCREEN_WIDTH/[modelArray count]
                                                                                                                        andHeight:subscribeProgressCellHeight];
        
        [self addSubview:singleView];
        if(!tempView) {
            [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.equalTo(self);
                make.bottom.equalTo(self);
                make.width.mas_equalTo(SCREEN_WIDTH / [modelArray count]);
            }];
        } else {
            [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right);
                make.top.equalTo(self);
                make.bottom.equalTo(self);
                make.width.mas_equalTo(SCREEN_WIDTH / [modelArray count]);
            }];
        }
        tempView = singleView;
    }
}

- (HXSSubscribeProgressSingleViewQueueType)getTheQueueTypeWithModel:(HXSSubscribeProgressSingleModel *)model
                                                           andArray:(NSArray<HXSSubscribeProgressSingleModel *> *)array
{
    HXSSubscribeProgressSingleViewQueueType currentQueueType;
    NSInteger modelIndex = [array indexOfObject:model];
    
    if(modelIndex == 0) {
        currentQueueType = HXSSubscribeProgressSingleViewQueueTypeFirst;
    } else if(modelIndex == [array count] - 1) {
        currentQueueType = HXSSubscribeProgressSingleViewQueueTypeLast;
    } else {
        currentQueueType = HXSSubscribeProgressSingleViewQueueTypeNormal;
    }
    
    return currentQueueType;
}

- (HXSSubscribeProgressSingleViewCurrentType)getTheCurrentTypeWithModel:(HXSSubscribeProgressSingleModel *)model
                                                               andArray:(NSArray<HXSSubscribeProgressSingleModel *> *)array
{
    HXSSubscribeProgressSingleViewCurrentType currentType;
    NSInteger modelIndex = [array indexOfObject:model];
    
    if(modelIndex == _curretnIndex) {
        currentType = HXSSubscribeProgressSingleViewCurrentTypeCurrent;
    } else if(modelIndex < _curretnIndex) {
        currentType = HXSSubscribeProgressSingleViewCurrentTypePass;
    } else {
        currentType = HXSSubscribeProgressSingleViewCurrentTypeNot;
    }
    
    return currentType;
}

@end
