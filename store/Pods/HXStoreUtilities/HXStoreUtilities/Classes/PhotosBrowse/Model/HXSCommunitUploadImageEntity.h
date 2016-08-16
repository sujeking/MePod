//
//  HXSCommunitUploadImageEntity.h
//  store
//
//  Created by J006 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXSCommunityUploadPhotoType)
{
    kHXSCommunityUploadPhotoTypeNO         = 0,//图片未上传
    kHXSCommunityUploadPhotoTypeUploadSucc = 1,//图片上传成功
    kHXSCommunityUploadPhotoTypeUploadFail = 2,//图片上传失败
    kHXSCommunityUploadPhotoTypeUploading  = 3,//图片上传中
};

@interface HXSCommunitUploadImageEntity : NSObject

@property (nonatomic, strong) NSData                            *formData; // data
@property (nonatomic, strong) NSString                          *nameStr; // name
@property (nonatomic, strong) NSString                          *filenameStr; //file name
@property (nonatomic, strong) NSString                          *mimeTypeStr; //mimeType
@property (nonatomic, readwrite) HXSCommunityUploadPhotoType    uploadType; //上传状态
@property (nonatomic, strong) NSString                          *urlStr; //URL
@property (nonatomic, strong) UIImage                           *defaultImage; //默认图片
@property (nonatomic, readwrite) CGRect                         imageViewFrame;//所处的imageView的frame
@property (nonatomic, strong) UIImageView                       *imageView;
@end
