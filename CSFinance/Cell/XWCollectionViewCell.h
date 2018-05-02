//
//  XWCollectionViewCell.h
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWFeedLayout.h"

typedef NS_ENUM(NSInteger, XWCollectionCellStyle) {
    XWCollectionCellStyleNormal=0,   //image above & title below.
    XWCollectionCellStyleSubtitle,   //image above & title + Subtitle below.
    XWCollectionCellStyleDuoSubtitle,//image above & title + 2 Subtitle(L + R) below.
    XWCollectionCellStyleImageTitle,  //image cover * title.
    
    XWCollectionCellStyleRightTitle,  //Left image & Right Title
    XWCollectionCellStyleLeftTitle,   //Left Title & Right Image
    XWCollectionCellStyleTag
};

@interface XWCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) XWItemLayout * layoutModel;
@property (nonatomic, assign) XWCollectionCellStyle cellStyle;

@property (nonatomic, strong) UIImageView * imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UILabel * subtitleLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *leftLabel;

- (void)refreshWithLayoutModel:(id)model;

@end
