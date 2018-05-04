//
//  XWTableViewCell.h
//  CSFinance
//
//  Created by csco on 2018/5/3.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWItemLayout.h"

typedef NS_ENUM(NSInteger, XWTableViewCellStyle) {
    XWTableViewCellStyleNormal=0,       //UITableViewCellStyleSubtitle
    XWTableViewCellStyleDuoDetail=1,    //Two Subtitles （title Left）
    XWTableViewCellStyleThreeTitle=2,   //Three title Without image; （horizontal）
    XWTableViewCellStyleFourTitle=3,   //Three title Without image; （horizontal）
    XWTableViewCellStylePreview=4,      //big image above & vertical titles (DuoDetail)
    XWTableViewCellStylePoster          //big image cover & Normal titles
};

@interface XWTableViewCell : UITableViewCell
//@property (nonatomic, readonly, strong, nullable) UIImageView *imageView;
//@property (nonatomic, readonly, strong, nullable) UILabel *textLabel;
//@property (nonatomic, readonly, strong, nullable) UILabel *detailTextLabel;
@property (nonatomic, strong, nullable) UILabel *exTextLabel;    //extra
@property (nonatomic, strong, nullable) UILabel *eyTextLabel;

@property (nonatomic, strong) XWItemLayout * layoutModel;
@property (nonatomic, assign) XWTableViewCellStyle cellStyle;

- (void)refreshWithLayoutModel:(id)model;

@end
