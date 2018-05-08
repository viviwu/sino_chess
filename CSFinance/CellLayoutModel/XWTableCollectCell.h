//
//  XWTableCollectCell.h
//  CSPP
//
//  Created by csco on 2018/3/30.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWImageTitleCell.h"
#import "XWCollectionViewCell.h"

#define kCTCellReuseId @"kCTCellReuseId"
#define kCTCellReuseIdMenu @"XWTableCollectCellType10Menu"
#define kCTCellReuseIdUser @"XWTableCollectCellTypeUserLine"
#define kCTCellReuseIdTags @"XWTableCollectCellTypeDynTags"

typedef NS_ENUM(NSInteger, XWTableCollectCellType) {
    XWTableCollectCellType10Menu = 0,
    XWTableCollectCellTypeUserLine = 1,
    XWTableCollectCellTypeDynTags
};

@interface XWTableCollectCell : UITableViewCell
@property (nonatomic, assign) XWTableCollectCellType cellType;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<XWItemLayout*>* sectionItems;
- (void)refreshWithLayoutModel:(NSArray<XWItemLayout*>*) sectionItems;
@end
