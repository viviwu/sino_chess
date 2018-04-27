//
//  XWCollectionReusableView.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWCollectionReusableView.h"
 #import "UIButton+Bootstrap.h"

@implementation XWCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 5.0, self.frame.size.width, self.frame.size.height-6.0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _titleLabel = [self instanceNewLabel];
        [_contentView addSubview: _titleLabel];
        
        [_contentView addSubview:self.detailButton];
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (UIButton*)detailButton
{
    if(!_detailButton){
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailButton addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchDown];
    }
    return _detailButton;
}

- (void)touchAction{
    
    if (_actionHandle) {
        _actionHandle(_layoutModel);
    }
}

- (void)refreshWithLayoutModel:(XWItemLayout*)model
{
    _layoutModel = model;
    _titleLabel.text = model.title;
    if (model.detail) {
        [self.detailButton setTitle:model.detail?:@"查看更多" forState:UIControlStateNormal];
        [_detailButton setFrame:CGRectMake(kSelfW *0.6, 0, kSelfW *0.4, kSelfH)];
        [_detailButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.detailButton defaultStyle];
        [self.detailButton addAwesomeIcon:FAIconChevronRight beforeTitle:NO];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat len = self.frame.size.width*0.6;
    
    [_titleLabel setFrame:CGRectMake(10.0, 0, len, kSelfH - 6.0)];
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
}

-(UILabel*)instanceNewLabel{
    
    UILabel * la = UILabel.new;
    la.textColor = UIColor.blackColor;
    la.text = @"*^*";
    la.font =  [UIFont systemFontOfSize:14.0];
    la.textAlignment = NSTextAlignmentLeft;
    la.numberOfLines = 0;
    la.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview: la];
    return la;
}

@end
