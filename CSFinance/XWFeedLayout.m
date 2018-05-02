//
//  XWFeedLayout.m
//  CSFinance
//
//  Created by vivi wu on 2018/4/25.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWFeedLayout.h"
#import "NSDate+YYAdd.h"

@implementation XWItemLayout
- (instancetype)init{
    self = [super init];
    if (self) {
        _reuseID = nil;
        _title = @"no title！";
        _detail = nil;
        _image = nil;
        _linkInfo = nil;
        //@{@"Date":[NSDate dateWithISOFormatString:@"2010-07-09"], @"CTR": @132};
        
        _cellStyle = 0;
        _height = 0;
        _size = CGSizeZero;
    }
    return self;
}
@end

@implementation XWGroupLayout
- (instancetype)initWithData:(NSArray<XWItemLayout*>*)itemLayouts{
    self = [super init];
    if (self) { 
//        _headerLayout = [[XWItemLayout alloc]init];
//        _footerLayout = [[XWItemLayout alloc]init];
        _itemLayouts = [itemLayouts copy];
    }
    return self;
}

- (XWItemLayout *) headerLayout{
    if (!_headerLayout) {
        _headerLayout = [[XWItemLayout alloc]init];
    }
    return _headerLayout;
}

- (XWItemLayout *) footerLayout{
    if (!_footerLayout) {
        _footerLayout = [[XWItemLayout alloc]init];
    }
    return _footerLayout;
}

@end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++

@implementation XWFeedLayout

@end
