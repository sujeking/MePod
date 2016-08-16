//
//  kkkMM.h
//  masony
//
//  Created by  黎明 on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol HXSBoxMenuDelegate <NSObject>
@optional
- (void)boxMenuItemClickAction:(NSIndexPath *)indexPath;
@end


@interface HXSBoxMenu : UIView<UITableViewDelegate,UITableViewDataSource>

//菜单点击回调
@property (nonatomic, strong) id <HXSBoxMenuDelegate> delegate;

+ (instancetype)initWithItemArray:(NSArray<UIImage *> *)itemIconArray
                       itemTitles:(NSArray<NSString *> *)itemTitleArray
                            frame:(CGRect)frame;

- (void)show;
- (void)dismiss;

@end
