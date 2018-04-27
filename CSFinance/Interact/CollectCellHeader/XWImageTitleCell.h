//
//  XWImageTitleCell.h
//  CSFinance
//
//  Created by csco on 2018/4/27.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWFeedLayout.h"

@interface XWImageTitleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)refreshWithLayoutModel:(id)model;

@end
