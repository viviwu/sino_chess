//
//  XWFund.m
//  CSFinance
//
//  Created by vivi wu on 2018/5/3.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWFund.h"

//+++++++++++++++++++++++++++++++++++++++++++++++
@implementation XWFund
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"ID"  : @"id"};
//}
+ (NSArray *)modelPropertyBlacklist {
    return @[@"sharp"];
}
@end

@implementation XWFundData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [XWFund class]};
}
@end

@implementation XWFundResponse
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XWFundData class]};
}
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    // 自动 model-mapper 不能完成的，这里可以进行额外处理
//    NSLog(@"***********************dic==%@", dic);
//    _data = [XWFundData modelWithJSON:dic];
//    return YES;
//}
@end

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

