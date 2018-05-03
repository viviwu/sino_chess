//
//  XWImageTitleCell.m
//  CSFinance
//
//  Created by csco on 2018/4/27.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWImageTitleCell.h"

@implementation XWImageTitleCell
- (void)refreshWithLayoutModel:(XWItemLayout*)model
{
    self.titleLabel.text = model.title;
}

@end
