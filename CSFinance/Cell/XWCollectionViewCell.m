//
//  XWCollectionViewCell.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWCollectionViewCell.h"
#import "XWFeedLayout.h"

@implementation XWCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _label = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0, self.frame.size.width-20.0, self.frame.size.height* 0.6)];
//        _label.textColor = [UIColor blackColor];
//        _label.textAlignment = NSTextAlignmentCenter;
//        _label.font = [UIFont systemFontOfSize:16.0];
//        _detailLabel.numberOfLines =0;
//        [self addSubview:_label];
//        
//        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, self.frame.size.height*0.6, self.frame.size.width-20.0, self.frame.size.height*0.4)];
//        _detailLabel.textColor = [UIColor darkGrayColor];
//        _detailLabel.font =[UIFont systemFontOfSize:14.0];
//        _detailLabel.numberOfLines =0;
//        _detailLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:_detailLabel];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)refreshWithLayoutModel:(XWItemLayout*)model
{
    _titleLabel.text = model.title;
    _leftLabel.text = model.detail;
}
@end
