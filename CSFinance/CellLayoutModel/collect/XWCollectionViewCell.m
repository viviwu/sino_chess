//
//  XWCollectionViewCell.m
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWCollectionViewCell.h"
#import "XWItemLayout.h"
#import "NSDate+YYAdd.h"
#import "UIImageView+YYWebImage.h"

#define kContentH self.contentView.bounds.size.height
#define kContentW self.contentView.bounds.size.width

@implementation XWCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellStyle = XWCollectionCellStyleNormal;
//        self.backgroundView
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setCellStyle:(XWCollectionCellStyle)cellStyle
{
    _cellStyle = cellStyle;
}

- (void)setLayoutModel:(XWItemLayout *)layoutModel
{
    _layoutModel = layoutModel;
    [self refreshWithLayoutModel:layoutModel];
}

- (void)refreshWithLayoutModel:(XWItemLayout*)model
{
    self.titleLabel.text = model.title;
    if (model.imgUrl) {
        [self.imageView setImageWithURL:model.imgUrl placeholder:[UIImage imageNamed:@"picture"]];
    }
    if (model.image) {
        self.imageView.image = model.image;
    }
    if (model.detail) {
        self.subtitleLabel.text = model.detail;
    }
    NSString * time = model.linkInfo[@"date"];
    if (time) {
        self.leftLabel.text= time;
    }
    NSString * tag = model.linkInfo[@"tag"];
    if (tag) {
        self.rightLabel.text = tag;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //
//    UIBezierPath * path = [UIBezierPath bezierPath];
//    path.lineWidth = 2;
//    [path moveToPoint: CGPointMake(0, kContentH-2.0)];
//    [path addLineToPoint:CGPointMake(kContentW, kContentH-2.0)];
//    [[UIColor lightGrayColor] set];
//    [path stroke];
}

- (void)layoutSubviews
{
//    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    switch (_cellStyle) {
        case XWCollectionCellStyleNormal:
        {
            [self.imageView setFrame:CGRectMake(10.0, 0, kContentW - 20.0, kContentH - 20.0)];
            [self.titleLabel setFrame:CGRectMake(10.0, kContentH - 20.0, kContentW-20.0, 20.0)];
        }
            break;
        case XWCollectionCellStyleSubtitle:
        {
            [self.imageView setFrame:CGRectMake(10.0, 0, kContentW - 30.0, kContentH - 30.0)];
            [self.titleLabel setFrame:CGRectMake(10.0, kContentH - 30.0, kContentW-20.0, 17.0)];
            [self.subtitleLabel setFrame:CGRectMake(10.0, kContentH - 13.0, kContentW-20.0, 13.0)];
            self.subtitleLabel.textColor = [UIColor darkGrayColor];
        }
            break;
        case XWCollectionCellStyleDuoSubtitle:
        {
            [self.imageView setFrame:CGRectMake(5.0, 0, kContentW - 10.0, kContentH - 30.0)];
            [self.titleLabel setFrame:CGRectMake(5.0, kContentH - 30.0, kContentW-20.0, 17.0)];
            [self.leftLabel setFrame:CGRectMake(5.0, kContentH - 13.0, kContentW/2-5.0, 13.0)];
            self.leftLabel.textColor = [UIColor darkGrayColor];
            [self.rightLabel setFrame:CGRectMake(kContentW/2-5.0, kContentH - 13.0, kContentW/2-5.0, 13.0)];
            self.rightLabel.textColor = [UIColor darkGrayColor];
        }
            break;
        case XWCollectionCellStyleImageTitle:
        {
            [self.imageView setFrame:CGRectMake(0, 0, kContentW, kContentH)];
            [self.titleLabel setFrame:CGRectMake(10.0, kContentH - 30.0, kContentW-20.0, 30.0)];
            self.titleLabel.textColor = [UIColor yellowColor];
        }
            break;
        case XWCollectionCellStyleRightTitle:{
            [self.imageView setFrame:CGRectMake(10.0, kContentH*0.2, kContentH*0.6, kContentH*0.6)];
            CGFloat leftX = 15.0 + kContentH*0.6 ;
            CGFloat rightW = kContentW -leftX -5.0 ;
            [self.titleLabel setFrame:CGRectMake(leftX, 5.0, rightW, kContentH *0.5)];
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            
            [self.leftLabel setFrame:CGRectMake(leftX, kContentH *0.5+5.0, rightW/2, kContentH *0.5-10.0)];
            [self.rightLabel setFrame:CGRectMake(leftX + rightW/2,  kContentH *0.5+5.0, rightW/2, kContentH *0.5-10.0)];
        }
            break;
        case XWCollectionCellStyleLeftTitle:{
            CGFloat leftW = kContentW - kContentH*0.6-20.0;
            CGFloat righX = kContentW - kContentH*0.6-15.0 ;
            [self.imageView setFrame:CGRectMake(righX, kContentH*0.2, kContentH*0.6, kContentH*0.6)];
            
            [self.titleLabel setFrame:CGRectMake(10.0, 5.0, leftW, kContentH *0.5)];
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            [self.leftLabel setFrame:CGRectMake(10.0, kContentH *0.5+5.0, kContentW/2-5.0, kContentH *0.5-10.0)];
            [self.rightLabel setFrame:CGRectMake(leftW/2+20.0, kContentH *0.5+5.0, kContentW/2-5.0, kContentH *0.5-10.0)];
        }
            break;
        case XWCollectionCellStyleTag:
        {
            [self.titleLabel setFrame:CGRectMake(0, 0, kContentW, kContentH)];
            self.titleLabel.layer.cornerRadius = 5.0;
            self.titleLabel.clipsToBounds = YES;
            self.titleLabel.backgroundColor = UIColor.groupTableViewBackgroundColor;
        }
            break;
        default:{
            [self.titleLabel setFrame:CGRectMake(0, 0, kContentW, kContentH)];
        }
            break;
    }
    [super layoutSubviews];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"picture"];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [self instanceNewLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [self instanceNewLabel];
    }
    return _subtitleLabel;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [self instanceNewLabel];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.text = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
        _leftLabel.textColor = [UIColor darkGrayColor];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [self instanceNewLabel];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.text = @"浏览👀233";
        _rightLabel.textColor = [UIColor darkGrayColor];
    }
    return _rightLabel;
}

-(UILabel*)instanceNewLabel{
    
    UILabel * la = UILabel.new;
    la.textColor = UIColor.blackColor;
    la.text = @"*^*";
    la.font =  [UIFont systemFontOfSize:14.0];
    la.textAlignment = NSTextAlignmentCenter;
    la.numberOfLines = 0;
    la.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview: la];
    return la;
}

@end
