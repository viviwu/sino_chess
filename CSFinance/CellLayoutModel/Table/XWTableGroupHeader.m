//
//  XWTableGroupHeader.m
//  CSFinance
//
//  Created by csco on 2018/5/3.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWTableGroupHeader.h"
#import "UIButton+Bootstrap.h"

@implementation XWTableGroupHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 5.0, self.frame.size.width, self.frame.size.height-6.0)];
        self.contentView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:self.contentView];
        
        [self.contentView addSubview:self.detailButton];
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [self instanceNewLabel];
        [self.contentView addSubview: _titleLabel];
    }
    return _titleLabel;
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
    if (model.title && kSelfH>15.0) {
        self.titleLabel.text = model.title;
    }
    
    if (model.detail && kSelfH>25.0) {
        [self.detailButton setTitle:model.detail?:@"查看更多" forState:UIControlStateNormal];
        [self.detailButton setFrame:CGRectMake(kSelfW - 120.0, 0, 120.0, kSelfH)];
        [self.detailButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //        [self.detailButton defaultStyle];
        [self.detailButton addAwesomeIcon:FAIconChevronRight beforeTitle:NO];
        [self.detailButton addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchDown];
    }else{
        [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
