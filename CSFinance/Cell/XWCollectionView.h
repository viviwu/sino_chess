//
//  XWCollectionView.h
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCollectionReusableView.h"
#import "XWCollectionViewCell.h"

#import "XWFeedLayout.h"


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

typedef void (^SelectActionHandle)(NSIndexPath *);

@interface XWCollectionView : UICollectionView

@property (nonatomic, copy) NSArray<XWSectionLayout*>* sectionLayouts;
@property (nonatomic, strong) SelectActionHandle selectHandle;

- (void)setSelectHandle:(SelectActionHandle)selectHandle;

- (void)refreshWith:(id)sectionLayouts;

+ (NSArray<XWCellLayout*>*)defaultSectionLayouts;

@end
