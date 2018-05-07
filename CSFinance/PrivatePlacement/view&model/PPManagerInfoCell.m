//
//  PPManagerInfoCell.m
//  CSFinance
//
//  Created by vivi wu on 2018/5/6.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "PPManagerInfoCell.h"

#define kIconWH  kSelfH*0.6

@interface PPManagerInfoCell ()
@property (nonatomic, strong, nullable) UILabel *leftKLabel;
@property (nonatomic, strong, nullable) UILabel *rightKLabel;
@end

@implementation PPManagerInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"userid.png"];
        self.textLabel.text = @"基金管理人 XXX";
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.detailTextLabel.text = @"从业16年，管理过118只产品";
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat txtW = kSelfW - kIconWH -20.0;
    CGFloat txH = kSelfH *0.2;
    [self.imageView setFrame:CGRectMake(10.0, 20.0, kIconWH, kIconWH)];
    [self.textLabel setFrame:CGRectMake(20.0 + kIconWH, 10.0, txtW, txH)];
    [self.detailTextLabel setFrame:CGRectMake(20.0 + kIconWH, txH +10.0, txtW, txH)];
    
    [self.leftValueLabel setFrame:CGRectMake(20.0 + kIconWH, txH*2 +10.0, txtW/2, txH+10.0)];
    [self.rightValueLabel setFrame:CGRectMake(20.0 + kIconWH +txtW/2, txH*2 +10.0, txtW/2, txH+10.0)];
    
    [self.leftKLabel setFrame:CGRectMake(20.0 + kIconWH, txH *3+20.0, txtW/2, txH)];
    [self.rightKLabel setFrame:CGRectMake(20.0 + kIconWH +txtW/2, txH *3+20.0, txtW/2, txH)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)leftValueLabel
{
    if (!_leftValueLabel) {
        _leftValueLabel = [self instanceNewLabel];
        _leftValueLabel.font =[UIFont systemFontOfSize:20.0];
        _leftValueLabel.textColor = UIColor.redColor;
    }
    return _leftValueLabel;
}

- (UILabel *)rightValueLabel
{
    if (!_rightValueLabel) {
        _rightValueLabel = [self instanceNewLabel];
        _rightValueLabel.font =[UIFont systemFontOfSize:20.0];
        _rightValueLabel.textColor = UIColor.redColor;
    }
    return _rightValueLabel;
}

- (UILabel *)leftKLabel
{
    if (!_leftKLabel) {
        _leftKLabel = [self instanceNewLabel];
        _leftKLabel.text = @"累计收益";
    }
    return _leftKLabel;
}

- (UILabel *)rightKLabel
{
    if (!_rightKLabel) {
        _rightKLabel = [self instanceNewLabel];
        _rightKLabel.text = @"今年收益";
    }
    return _rightKLabel;
}

-(UILabel*)instanceNewLabel{
    
    UILabel * la = UILabel.new;
    la.textColor = UIColor.lightGrayColor;
    la.text = @"--";
    la.font =  [UIFont systemFontOfSize:14.0];
    la.textAlignment = NSTextAlignmentLeft;
    la.numberOfLines = 1;
    la.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview: la];
    return la;
}

@end
