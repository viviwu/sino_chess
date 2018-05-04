//
//  XWManager.m
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWManager.h"


@implementation XWManager

@end

@implementation XWManagerData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [XWManager class]};
}
@end

@implementation XWManagerResponse
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XWManagerData class]};
}
@end

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
