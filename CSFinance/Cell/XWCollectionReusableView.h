//
//  XWCollectionReusableView.h
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWFeedLayout.h"

typedef NS_ENUM(NSInteger, XWCollectionReusableViewStyle) {
    XWCollectionReusableViewStyleNormal=0,
    XWCollectionReusableViewStyleDetail
};

typedef void(^XWActionHandle)(XWItemLayout *);
@interface XWCollectionReusableView : UICollectionReusableView
@property(nonatomic, strong)UIView * contentView;
@property(nonatomic, strong)UILabel * titleLabel;
//@property(nonatomic, strong)UILabel * detailLabel;
@property(nonatomic, strong)UIButton * detailButton;

@property(nonatomic, strong)XWItemLayout * layoutModel;
@property(nonatomic, copy)XWActionHandle actionHandle;

-(void)refreshWithLayoutModel:(id)model;

@end
