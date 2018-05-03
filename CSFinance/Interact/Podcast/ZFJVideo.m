//
//  ZFJVideo.m
//  CSFinance
//
//  Created by csco on 2018/5/3.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "ZFJVideo.h"

@implementation ZFJVideo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID"  : @"id"};
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"rank", @"orderNumber"];
}

@end

@implementation ZFJVideoList

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"videoItems"  : @"items"};
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"cate", @"page"];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"videoItems" : [ZFJVideo class]};
}
@end
