//
//  HXSPost+PostH5.m
//  store
//
//  Created by  黎明 on 16/7/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPost+PostH5.h"
#import <objc/runtime.h>
@implementation HXSPost (PostH5)

static char key_type;
static char key_detail_link;
static char key_first_img;
static char key_post_title;
static char key_circle_name;
#pragma mark - postTypeIntNum GET && SET

- (NSNumber *)postTypeIntNum
{
    return objc_getAssociatedObject(self, &key_type);
}

- (void)setPostTypeIntNum:(NSNumber *)postTypeIntNum
{
    objc_setAssociatedObject(self, &key_type, postTypeIntNum, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - detailLinkStr GET && SET

- (NSString *)detailLinkStr
{
    return objc_getAssociatedObject(self, &key_detail_link);
}

- (void)setDetailLinkStr:(NSString *)detailLinkStr
{
    objc_setAssociatedObject(self, &key_detail_link, detailLinkStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - firstImgUrlStr GET && SET

- (NSString *)firstImgUrlStr
{
   return objc_getAssociatedObject(self, &key_first_img);
}

- (void)setFirstImgUrlStr:(NSString *)firstImgUrlStr
{
    objc_setAssociatedObject(self, &key_first_img, firstImgUrlStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - postTitleStr GET && SET

- (NSString *)postTitleStr
{
    return objc_getAssociatedObject(self, &key_post_title);
}

- (void)setPostTitleStr:(NSString *)postTitleStr
{
    objc_setAssociatedObject(self, &key_post_title, postTitleStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark circleNameStr GET && SET

- (NSString *)circleNameStr
{
    return objc_getAssociatedObject(self, &key_circle_name);
}

- (void)setCircleNameStr:(NSString *)circleNameStr
{
   objc_setAssociatedObject(self, &key_circle_name, circleNameStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
