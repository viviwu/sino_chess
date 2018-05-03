//
//  XWImageSubtitleCell.m
//  CSFinance
//
//  Created by csco on 2018/4/26.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWImageSubtitleCell.h"
#import "XWItemLayout.h"

@implementation XWImageSubtitleCell

- (void)refreshWithLayoutModel:(XWItemLayout*)model
{
    _titleLabel.text = model.title;
    _detailLabel.text = model.detail;
}

@end
