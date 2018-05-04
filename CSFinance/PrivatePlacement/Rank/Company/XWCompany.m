//
//  XWCompany.m
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWCompany.h"

 
@implementation XWCompany

@end

@implementation XWCompanyData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [XWCompany class]};
}
@end

@implementation XWCompanyResponse
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XWCompanyData class]};
}
@end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
