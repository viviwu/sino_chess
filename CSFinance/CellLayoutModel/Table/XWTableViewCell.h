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
    XWTableViewCellStyleDuoDetail=1,    //Two Subtitles
    XWTableViewCellStyleThreeTitle=2,   //Three title Without image;
};

@interface XWTableViewCell : UITableViewCell

@end
