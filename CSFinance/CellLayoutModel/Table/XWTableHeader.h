//
//  XWTableHeader.h
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, XWTableHeaderStyle) {
    XWTableHeaderStyleFund=0,
    XWTableHeaderStyleManager=0,
    XWTableHeaderStyleCompany=0,
};

@interface XWTableHeader : UIView

@property (nonatomic, assign) XWTableHeaderStyle headerStyle;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UILabel * detailTextLabel;

@property (nonatomic, strong) UILabel * laLabel;
@property (nonatomic, strong) UILabel * maLabel;
@property (nonatomic, strong) UILabel * raLabel;

@property (nonatomic, strong) UILabel * lbLabel;
@property (nonatomic, strong) UILabel * mbLabel;
@property (nonatomic, strong) UILabel * rbLabel;

- (instancetype)initWithFrame:(CGRect)frame headerStyle:(XWTableHeaderStyle)headerStyle;

@end
