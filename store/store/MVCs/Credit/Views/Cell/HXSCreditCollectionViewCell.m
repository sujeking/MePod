//
//  HXSCreditCollectionViewCell.m
//  store
//
//  Created by ArthurWang on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditCollectionViewCell.h"

#import "HXSStoreAppEntryEntity.h"

@interface HXSCreditCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSubtitleLabel;

@end

@implementation HXSCreditCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}


#pragma mark - Public Methods

- (void)setupCollectionCellWithSlideItem:(HXSStoreAppEntryEntity *)slideItem
{
    [self layoutIfNeeded];
    
    if (nil == slideItem) {
        [self.itemImageView setHidden:YES];
        [self.itemNameLabel setHidden:YES];
        [self.itemSubtitleLabel setHidden:YES];
    } else {
        [self.itemImageView setHidden:NO];
        [self.itemNameLabel setHidden:NO];
        [self.itemSubtitleLabel setHidden:NO];
        
        // image
        [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:slideItem.imageURLStr]
                              placeholderImage:[UIImage imageNamed:@"ic_defaulticon_loading"]];
        
        // title
        [self.itemNameLabel setText:slideItem.titleStr];
        
        // subtitle
        [self.itemSubtitleLabel setText:slideItem.subtitleStr];
    }
    
    
}

@end
