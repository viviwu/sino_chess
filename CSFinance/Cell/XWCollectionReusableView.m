//
//  XWCollectionReusableView.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWCollectionReusableView.h"

@implementation XWCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 5.0, self.frame.size.width, self.frame.size.height-6.0)];
        blankView.backgroundColor = [UIColor whiteColor];
        [self addSubview:blankView];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0, self.frame.size.width-20.0, self.frame.size.height-6.0)];
        _label.textColor = [UIColor lightGrayColor];
        _label.font = [UIFont systemFontOfSize:20.0];
        [blankView addSubview:_label];
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (void)refreshWithData:(NSString*)data
{
    _label.text = data;
}

@end
