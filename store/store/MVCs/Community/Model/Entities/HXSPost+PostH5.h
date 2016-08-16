//
//  HXSPost+PostH5.h
//  store
//
//  Created by  黎明 on 16/7/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <HXStoreUtilities/HXStoreUtilities.h>

@interface HXSPost (PostH5)

/**帖子类型 0为常规 1为h5【图文混排】 */
@property (nonatomic, strong) NSNumber *postTypeIntNum;
/**图文混排url */
@property (nonatomic, strong) NSString *detailLinkStr;
/**图文混排标题图片 */
@property (nonatomic, strong) NSString *firstImgUrlStr;
/**图文混排标题文字 */
@property (nonatomic, strong) NSString *postTitleStr;
/**圈子名称 */
@property (nonatomic, strong) NSString *circleNameStr;
@end
