//
//  HXSCommunityPostingParamEntity.m
//  store
//
//  Created by J006 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityPostingParamEntity.h"

@implementation HXSCommunityPostingParamEntity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.contentStr forKey:@"contentStr"];
    [aCoder encodeObject:self.photoURLStr forKey:@"photoURLStr"];
    [aCoder encodeObject:self.topicIDStr forKey:@"topicIDStr"];
    [aCoder encodeObject:self.topicTitileStr forKey:@"topicTitileStr"];
    [aCoder encodeObject:self.schoolIDStr forKey:@"schoolIDStr"];
    [aCoder encodeObject:self.schoolNameStr forKey:@"schoolNameStr"];
    [aCoder encodeObject:self.photoURLArray forKey:@"photoURLArray"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super init];
    if (self)
    {
        _contentStr      = [aDecoder decodeObjectForKey:@"contentStr"];
        _photoURLStr     = [aDecoder decodeObjectForKey:@"photoURLStr"];
        _topicIDStr      = [aDecoder decodeObjectForKey:@"topicIDStr"];
        _topicTitileStr  = [aDecoder decodeObjectForKey:@"topicTitileStr"];
        _schoolIDStr     = [aDecoder decodeObjectForKey:@"schoolIDStr"];
        _schoolNameStr   = [aDecoder decodeObjectForKey:@"schoolNameStr"];
        _photoURLArray   = [aDecoder decodeObjectForKey:@"photoURLArray"];
    }
    return self;
}

@end
