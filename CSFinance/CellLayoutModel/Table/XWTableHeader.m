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
        self.backgroundColor = [UIColor yellowColor];
        self.headerStyle = headerStyle;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    CGFloat inset = kSelfH*0.1;
    CGFloat lY = kSelfH *0.5;
    CGFloat lW = kSelfW/3;
    CGFloat aH = kSelfH *0.2;
    CGFloat bH = kSelfH *0.3;
    
    if ( XWTableHeaderStyleFund == _headerStyle) {
        self.textLabel.text = @"封闭基金";
        self.detailTextLabel.text = @"托管人：招商证券";
        //        [self.imageView setFrame:CGRectZero];
       
//        [self.textLabel setFrame:CGRectMake(inset, inset, kSelfW*0.8, aH)];
//        [self.detailTextLabel setFrame:CGRectMake(inset, bH, kSelfW*0.8, aH)];
        
        self.laLabel.text = @"最新净值";
        self.maLabel.text = @"近一年收益";
        self.raLabel.text = @"累计收益";
        
    }else if ( XWTableHeaderStyleManager == _headerStyle) {
        [self.imageView setFrame:CGRectMake(inset, inset, bH, bH)];
        [self.textLabel setFrame:CGRectMake(kSelfW*0.4, inset, lY, aH)];
        [self.detailTextLabel setFrame:CGRectMake(kSelfW*0.4, bH, lY, aH)];
        
    }else if ( XWTableHeaderStyleCompany== _headerStyle) {
        
        [self.imageView setFrame:CGRectMake(inset, inset, bH, bH)];
        [self.textLabel setFrame:CGRectMake(kSelfW*0.4, inset, lY, aH)];
        [self.detailTextLabel setFrame:CGRectMake(kSelfW*0.4, bH, lY, aH)];
    }else {}
    
    [self.textLabel setFrame:CGRectMake(0, inset, lW, aH)];
    [self.detailTextLabel setFrame:CGRectMake(0, bH, lW, aH)];
    
    [self.laLabel setFrame:CGRectMake(0, lY, lW, aH)];
    [self.maLabel setFrame:CGRectMake(lW, lY, lW, aH)];
    [self.raLabel setFrame:CGRectMake(lW*2, lY, lW, aH)];
    
    [self.lbLabel setFrame:CGRectMake(0, aH+lY, lW, bH)];
    [self.mbLabel setFrame:CGRectMake(lW, aH+lY, lW, bH)];
    [self.rbLabel setFrame:CGRectMake(lW*2, aH+lY, lW, bH)];
    NSLog(@"textLabel-----%@", NSStringFromCGRect(self.textLabel.frame));
    NSLog(@"detailTextLabel-----%@", NSStringFromCGRect(self.detailTextLabel.frame));
    NSLog(@"rbLabel-----%@", NSStringFromCGRect(self.rbLabel.frame));
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
    return _laLabel;
}

- (UILabel *)detailTextLabel
{
    if (!_detailTextLabel) {
        _detailTextLabel = [self instanceNewLabel];
        _detailTextLabel.font =  [UIFont systemFontOfSize:18.0];
    }
    return _laLabel;
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
