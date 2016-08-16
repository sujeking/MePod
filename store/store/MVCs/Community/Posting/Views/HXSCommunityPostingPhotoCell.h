//
//  ImageTableViewCell.h
//  masony
//
//  Created by  黎明 on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSCommunityPostingPhotoCell : UITableViewCell

@property (assign, nonatomic) CGFloat cellHeight;
@property (strong, nonatomic) NSMutableArray *images;
@property (copy, nonatomic)  void (^imageViewTapBlock)(UIImageView *imageView);
@end
