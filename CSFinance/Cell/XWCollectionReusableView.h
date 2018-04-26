//
//  XWCollectionReusableView.h
//  XWScrollBanner
//
//  Created by vivi wu on 2018/4/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWCollectionReusableView : UICollectionReusableView

@property(nonatomic, strong)UILabel * label;

- (void)refreshWithData:(NSString*)data;

@end
