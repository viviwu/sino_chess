//
//  XWTableGroupHeader.h
//  CSFinance
//
//  Created by csco on 2018/5/3.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWItemLayout.h"

typedef NS_ENUM(NSInteger, XWCollectionGroupHeaderStyle) {
    XWCollectionGroupHeaderStyleNormal=0,
    XWCollectionGroupHeaderStyleDetail
};

typedef void(^XWActionHandle)(XWItemLayout *);

@interface XWTableGroupHeader : UITableViewHeaderFooterView

//@property(nonatomic, strong)UIView * contentView;
@property(nonatomic, strong)UILabel * titleLabel;
//@property(nonatomic, strong)UILabel * detailLabel;
@property(nonatomic, strong)UIButton * detailButton;

@property(nonatomic, strong)XWItemLayout * layoutModel;
@property(nonatomic, copy)XWActionHandle actionHandle;

-(void)refreshWithLayoutModel:(id)model;

@end
