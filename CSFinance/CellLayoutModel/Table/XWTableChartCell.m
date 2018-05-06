//
//  XWTableChartCell.m
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWTableChartCell.h"

@implementation XWTableChartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _aaChartView = [[AAChartView alloc]initWithFrame:CGRectMake(0, 40.0, kSelfW+40, kSelfH-40.0)];
        //        _aaChartView.layer.cornerRadius = 8;
        //        _aaChartView.layer.masksToBounds = YES;
        //        _aaChartView.layer.shadowColor = [UIColor blackColor].CGColor;
        //        _aaChartView.layer.shadowOffset = CGSizeMake(2, 4);
        //        _aaChartView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_aaChartView];
        
        _aaChartView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[self configureTheConstraintArrayWithItem:_aaChartView toItem:self]];
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
    if (0 == _chartStyle) {
        _segCtr = [[XWSegmentedControl alloc]initWithSectionTitles:@[@"成立以来", @"近一个月", @"近三个月", @"近一年"]];
        _segCtr.frame = CGRectMake(10.0, 0, kScreenW-20.0, 35.0);
        _segCtr.backgroundColor = [UIColor clearColor];
        _segCtr.indicatorLocation = XWSegIndicatorLocationDown;
        _segCtr.verticalDividerEnabled=YES;
        _segCtr.verticalDividerColor = UIColor.lightGrayColor;
        _segCtr.indicatorColor = UIColor.orangeColor;
        _segCtr.indicatorHeight = 1.0;
        _segCtr.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor]};
        [self.contentView addSubview:_segCtr];
        
        //        __weak typeof(self) weakSelf = self;
        [_segCtr setIndexChangeHandle:^(NSInteger index) {
            //            [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
        }];
    }else{
        
    }
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (NSArray *)configureTheConstraintArrayWithItem:(UIView *)view1 toItem:(UIView *)view2 {
    return  @[[NSLayoutConstraint constraintWithItem:view1
                                           attribute:NSLayoutAttributeLeft
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:view2
                                           attribute:NSLayoutAttributeLeft
                                          multiplier:1.0
                                            constant:0],
              [NSLayoutConstraint constraintWithItem:view1
                                           attribute:NSLayoutAttributeRight
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:view2
                                           attribute:NSLayoutAttributeRight
                                          multiplier:1.0
                                            constant:0],
              [NSLayoutConstraint constraintWithItem:view1
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:view2
                                           attribute:NSLayoutAttributeTop
                                          multiplier:1.0
                                            constant:40.0],
              [NSLayoutConstraint constraintWithItem:view1
                                           attribute:NSLayoutAttributeBottom
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:view2
                                           attribute:NSLayoutAttributeBottom
                                          multiplier:1.0
                                            constant:0],
              
              ];
}

@end
