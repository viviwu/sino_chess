//
//  XWTableChartCell.h
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWSegmentedControl.h"
#import <AAChartView/AAChartView.h>

typedef NS_ENUM(NSInteger, XWTableChartStyle) {
    XWTableChartStyleFund=0,
    XWTableChartStyleManager=1,
    XWTableChartStyleCompany=2,
};

@interface XWTableChartCell : UITableViewCell
@property (nonatomic, nullable) XWSegmentedControl * segCtr;
@property (nonatomic, assign) XWTableChartStyle chartStyle;

@end
