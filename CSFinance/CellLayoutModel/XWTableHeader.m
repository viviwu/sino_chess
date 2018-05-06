//
//  XWTableHeader.m
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWTableHeader.h"

//#define kSelfH self.bounds.size.height
//#define kSelfW self.bounds.size.width

@implementation XWTableHeader

- (instancetype)initWithFrame:(CGRect)frame headerStyle:(XWTableHeaderStyle)headerStyle
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.headerStyle = headerStyle;
        if(XWTableHeaderStyleManager == headerStyle){
            self.imageView.image = [UIImage imageNamed:@"userid.png"];
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    CGFloat lY = kSelfH *0.5;
    CGFloat lW = kSelfW/3;
    CGFloat LH = kSelfH *0.25;
    CGFloat imgWH = kSelfH *0.4;
    
    if ( XWTableHeaderStyleFund == _headerStyle) {
        //  [self.imageView setFrame:CGRectZero];
        [self.textLabel setFrame:CGRectMake(0, 10.0, kSelfW, LH)];
        [self.detailTextLabel setFrame:CGRectMake(0, LH, kSelfW, LH)];
        
        self.textLabel.text = @"小牛资本  (封闭运行)";
        self.detailTextLabel.text = @"托管人：招商证券";
        
        self.laLabel.text = @"最新净值";
        self.maLabel.text = @"近一年收益";
        self.raLabel.text = @"累计收益";
        
    }else {
        if (XWTableHeaderStyleManager == _headerStyle) {
            self.textLabel.text = @"基金经理（从业28年）";
            self.detailTextLabel.text = @"上海保银投资";
            
            self.laLabel.text = @"旗下基金数";
            self.maLabel.text = @"近一年收益";
            self.raLabel.text = @"累计收益";
        }else if (XWTableHeaderStyleCompany== _headerStyle){
            self.textLabel.text = @"";
            self.detailTextLabel.text = @"上海保银投资管理有限公司";
            
            self.laLabel.text = @"最新净值";
            self.maLabel.text = @"近一年收益";
            self.raLabel.text = @"累计收益";
        }
        CGFloat txtW = kSelfW -(imgWH+30.0);
        [self.imageView setFrame:CGRectMake(25.0, 15.0, imgWH, imgWH)];
        [self.textLabel setFrame:CGRectMake(imgWH+30.0, 10.0, txtW, LH)];
        [self.detailTextLabel setFrame:CGRectMake(imgWH+30.0, LH+10.0, txtW, LH)];
    }
    
    [self.laLabel setFrame:CGRectMake(0, lY, lW, LH)];
    [self.maLabel setFrame:CGRectMake(lW, lY, lW, LH)];
    [self.raLabel setFrame:CGRectMake(lW*2, lY, lW, LH)];
    
    [self.lbLabel setFrame:CGRectMake(0, LH+lY, lW, LH)];
    [self.mbLabel setFrame:CGRectMake(lW, LH+lY, lW, LH)];
    [self.rbLabel setFrame:CGRectMake(lW*2, LH+lY, lW, LH)];
    [super layoutSubviews];
}

//+++++++++++++++++++
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CSico.png"]];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [self instanceNewLabel];
        _textLabel.font =  [UIFont systemFontOfSize:18.0];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel
{
    if (!_detailTextLabel) {
        _detailTextLabel = [self instanceNewLabel];
        _detailTextLabel.font =  [UIFont systemFontOfSize:18.0];
    }
    return _detailTextLabel;
}
//+++++++++++++++++++
- (UILabel *)laLabel
{
    if (!_laLabel) {
        _laLabel = [self instanceNewLabel];
        _laLabel.textColor = [UIColor darkGrayColor];
    }
    return _laLabel;
}
- (UILabel *)maLabel
{
    if (!_maLabel) {
        _maLabel = [self instanceNewLabel];
        _maLabel.textColor = [UIColor darkGrayColor];
    }
    return _maLabel;
}
- (UILabel *)raLabel
{
    if (!_raLabel) {
        _raLabel = [self instanceNewLabel];
        _raLabel.textColor = [UIColor darkGrayColor];
    }
    return _raLabel;
}
//+++++++++++++++++++
- (UILabel *)lbLabel
{
    if (!_lbLabel) {
        _lbLabel = [self instanceNewLabel];
        _lbLabel.font =  [UIFont systemFontOfSize:28.0];
    }
    return _lbLabel;
}

- (UILabel *)mbLabel
{
    if (!_mbLabel) {
        _mbLabel = [self instanceNewLabel];
        _mbLabel.font =  [UIFont systemFontOfSize:28.0];
    }
    return _mbLabel;
}

- (UILabel *)rbLabel
{
    if (!_rbLabel) {
        _rbLabel = [self instanceNewLabel];
        _rbLabel.font =  [UIFont systemFontOfSize:28.0];
    }
    return _rbLabel;
}
//+++++++++++++++++++
-(UILabel*)instanceNewLabel{
    
    UILabel * la = UILabel.new;
    la.textColor = UIColor.blackColor;
    la.text = @"--";
    la.font =  [UIFont systemFontOfSize:14.0];
    la.textAlignment = NSTextAlignmentCenter;
    la.numberOfLines = 0;
    la.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview: la];
    return la;
}

@end
