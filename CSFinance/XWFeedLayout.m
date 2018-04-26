//
//  XWFeedLayout.m
//  CSFinance
//
//  Created by vivi wu on 2018/4/25.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWFeedLayout.h"

@implementation XWCellLayout
- (instancetype)init{
    self = [super init];
    if (self) {
        //        _size = CGSizeZero;
        _size = CGSizeMake(kScreenW-10.0, 125.0);
        _title = @"title";
    }
    return self;
}
@end

@implementation XWSectionLayout
- (instancetype)initWithData:(NSArray<XWCellLayout*>*)celllayouts{
    self = [super init];
    if (self) {
        _headerSize = CGSizeZero;
        _headerTitle = @"headerTitle";
        _footerSize = CGSizeZero;
        _footerTitle = @"footerTitle";
        _celllayouts = [celllayouts copy];
    }
    return self;
}
@end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++

@implementation XWFeedLayout

@end
