//
//  XWImageTitleCell.m
//  CSFinance
//
//  Created by csco on 2018/4/27.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWImageTitleCell.h"

@implementation XWImageTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellStyle = XWImageTitleCellStyleMenu;
        [self.contentView addSubview: self.titleLabel];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.text = @"---";
        _titleLabel.font =  [UIFont systemFontOfSize:14.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _titleLabel;
}

- (void)refreshWithLayoutModel:(XWItemLayout*)model
{
    self.titleLabel.text = model.title;
    self.imageView.image = model.image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imgWH = kSelfH;
    if (_cellStyle == XWImageTitleCellStyleMenu) {
        imgWH = kSelfH * 0.6;
    }else if (_cellStyle == XWImageTitleCellStyleUser) {
        imgWH = kSelfH * 0.7;
    }else{
        imgWH = kSelfH * 0.9;
    }
    CGFloat txtH = kSelfH - imgWH;
    CGFloat insetW = (kSelfW - imgWH)/2; 
    [self.imageView setFrame:CGRectMake(insetW, 0, imgWH, imgWH)];
    [self.titleLabel setFrame:CGRectMake(0, imgWH, kSelfW, txtH)];
    
    _imageView.layer.cornerRadius = imgWH/2;
    _imageView.clipsToBounds = YES;
    _imageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _imageView.layer.borderWidth = 0.5;
}

@end
