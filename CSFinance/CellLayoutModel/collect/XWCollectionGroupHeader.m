//
//  XWCollectionGroupHeader.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWCollectionGroupHeader.h"
#import "UIButton+Bootstrap.h"

@implementation XWCollectionGroupHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 5.0, self.frame.size.width, self.frame.size.height-6.0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView]; 
        [_contentView addSubview:self.titleLabel]; 
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [self instanceNewLabel];
        [_contentView addSubview: _titleLabel];
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

- (void)setGroupModel:(XWItemLayoutGroup *)groupModel
{
    _groupModel = groupModel;
}

- (void)touchAction{
    
    if (_actionHandle) {
        _actionHandle(_groupModel);
    }
}

- (void)refreshWithGroupLayoutModel:(XWItemLayoutGroup*)groupModel
{
    _groupModel = groupModel;
//    NSLog(@"groupLayout.itemGroup==%ld", _groupModel.itemGroup.count);
    if (groupModel.title && kSelfH>15.0) {
        self.titleLabel.text = groupModel.title;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    if (groupModel.detail && kSelfH>25.0) {
        [self.detailButton setTitle:groupModel.detail?:@"查看更多" forState:UIControlStateNormal];
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

@end
