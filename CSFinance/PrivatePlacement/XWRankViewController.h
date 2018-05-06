//
//  XWRankViewController.h
//  XWFundsRank
//
//  Created by vivi wu on 2018/5/5.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PPRankType) {
    PPRankTypeFund=0,
    PPRankTypeManager=1,
    PPRankTypeCompany=2,
};

@interface XWRankViewController : UIViewController
@property(nonatomic, assign) PPRankType rankType;
@end

static inline UIEdgeInsets xw_safeAreaInset(UIView *view) {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

