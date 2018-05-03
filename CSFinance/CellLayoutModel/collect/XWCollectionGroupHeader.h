//
//  XWCollectionGroupHeader.h
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWItemLayout.h"

typedef NS_ENUM(NSInteger, XWCollectionGroupHeaderStyle) {
    XWCollectionGroupHeaderStyleNormal=0,
    XWCollectionGroupHeaderStyleDetail
};

typedef void(^XWActionHandle)(XWItemLayoutGroup *);

@interface XWCollectionGroupHeader : UICollectionReusableView
@property(nonatomic, strong) UIView * contentView;
@property(nonatomic, strong) UILabel * titleLabel;
//@property(nonatomic, strong)UILabel * detailLabel;
@property(nonatomic, strong) UIButton * detailButton;

@property(nonatomic, strong) XWItemLayoutGroup * groupModel;
@property(nonatomic, copy) XWActionHandle actionHandle;

-(void)refreshWithGroupLayoutModel:(XWItemLayoutGroup *)groupModel;    //XWItemLayout

@end
