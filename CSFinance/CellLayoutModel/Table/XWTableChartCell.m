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
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (0 == _chartStyle) {
        _segCtr = [[XWSegmentedControl alloc]initWithSectionTitles:@[@"成立以来", @"近一个月", @"近三个月", @"近一年"]];
        _segCtr.frame = CGRectMake(10.0, 10.0, kScreenW-20.0, 35.0);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
