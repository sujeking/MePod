//
//  HXSCommunityContentFooterTableViewCell.m
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityContentFooterTableViewCell.h"
#import "NSDate+Extension.h"
#import "HXSAccountManager.h"
@implementation HXSCommunityContentFooterTableViewCell

- (void)awakeFromNib
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setPostEntity:(HXSPost *)postEntity
{
    NSInteger timelong = [postEntity.createTimeLongNum longValue];
    
    NSString *timeStr = [self updateTimeForRow:timelong];
    
    self.postTimeLabel.text = timeStr;
    
    if(postEntity.viewCountNum){
        
        self.postBrowseCountLabel.text = [postEntity.viewCountNum stringValue];
    } else {
        
        self.postBrowseCountLabel.text = @"0";
    }
}

- (NSString *)updateTimeForRow:(NSInteger)timeInterval
{
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建时间戳
    NSTimeInterval createTime = timeInterval;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转分钟
    NSInteger minutes = time/60;
    if (minutes < 60) {
        if(minutes == 0){
            
            return @"刚刚";
        } else {
            
            return [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
        }
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    
    //秒转天数
    NSInteger days = time/3600/24;
    if(days >= 6) {
        
        return @"6天前";
    } else {

        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
}




@end
