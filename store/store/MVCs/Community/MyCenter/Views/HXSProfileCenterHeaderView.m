//
//  HXSProfileCenterHeaderView.m
//  store
//
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSProfileCenterHeaderView.h"

@interface HXSProfileCenterHeaderView()

@property (nonatomic ,assign) HXSCommunityProfileUserType type;
@property (nonatomic ,strong) HXSCommunityCommentUser     *user;

@end

@implementation HXSProfileCenterHeaderView

#pragma mark life cycle

+ (id)profileCenterHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self.subviews.count == 0)
    { //means view got loaded from GlobalView.xib or other external nib, cause there aren't any subviews
        HXSProfileCenterHeaderView *viewFromNib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
        //Now connect IBOutlets
        self.backGroundImageView = viewFromNib.backGroundImageView;
        self.avatarImageView = viewFromNib.avatarImageView;
        self.userNameLabel = viewFromNib.userNameLabel;
        self.backGroundTopViewTopConsit = viewFromNib.backGroundTopViewTopConsit;
        [viewFromNib initTheProfileCenterHeaderViewWithUserType:_type andWithUser:_user];
        [viewFromNib setFrame:self.bounds];
        [self addSubview:viewFromNib];
    }
    
    return self;
}

#pragma mark init

- (void)initTheProfileCenterHeaderViewWithUserType:(HXSCommunityProfileUserType)type
                                       andWithUser:(HXSCommunityCommentUser *)user;
{
    NSString *avatarURLStr;
    NSString *nameStr;
    _type = type;
    if(user)
    {
        _user = user;
    }
    
    switch (type)
    {
        case HXSCommunityProfileUserTypeMySelf:
        {
            avatarURLStr = [[[HXSUserAccount currentAccount] userInfo] basicInfo].portrait;
            nameStr      = [[[HXSUserAccount currentAccount] userInfo] basicInfo].nickName;
        }
            break;
            
        case HXSCommunityProfileUserTypeOthers:
        {
            avatarURLStr = user.userAvatarStr;
            nameStr      = user.userNameStr;
            _backGroundTopViewTopConsit.constant = 0;
        }
            break;
    }
    [_avatarImageView setImage:[UIImage imageNamed:@"img_headsculpture_small"]];
    [_backGroundImageView setImage:[UIImage imageNamed:@"img_community@2x.jpg"]];
    if(avatarURLStr
       && ![avatarURLStr isEqualToString:@""]
       && ![avatarURLStr isEqualToString:@"bundlenew_logo"])
    {
        NSURL *avatarURL = [[NSURL alloc]initWithString:avatarURLStr];
        [_avatarImageView sd_setImageWithURL:avatarURL
                            placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if(image)
                [_avatarImageView cornerRadiusForImageViewWithImage:image];
        }];
        [_backGroundImageView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"img_community@2x.jpg"]];
    }
    if(nameStr && ![nameStr isEqualToString:@""])
    {
        [_userNameLabel setText:nameStr];
    }
    
    [_avatarImageView cornerRadiusForImageViewWithImage:_avatarImageView.image];
}


@end
