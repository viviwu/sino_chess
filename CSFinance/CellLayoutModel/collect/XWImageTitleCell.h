//
//  XWImageTitleCell.h
//  CSFinance
//
//  Created by csco on 2018/4/27.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWItemLayout.h"
#import "XWImageTitleCell.h"


typedef NS_ENUM(NSInteger, XWImageTitleCellStyle) {
    XWImageTitleCellStyleMenu = 0,   //
    XWImageTitleCellStyleUser = 1,
    XWImageTitleCellStylePoster
};

@interface XWImageTitleCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, assign) XWImageTitleCellStyle cellStyle;
- (void)refreshWithLayoutModel:(XWItemLayout *)model;

@end
