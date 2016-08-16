//
//  HXSPromptCollectionViewCell.h
//  store
//
//  Created by ArthurWang on 16/7/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSPromptCollectionViewCell : UICollectionViewCell

+ (BOOL)shouldDisplayPromptView;

- (void)updatePromptLabel;

@end
