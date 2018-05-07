//
//  XWOpinionComposeViewController.h
//  YYKitExample
//
//  Created by ibireme on 15/9/8.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XWOpinionComposeViewType) {
    XWOpinionComposeViewTypeStatus,  ///< 发观点
    XWOpinionComposeViewTypeRetweet, ///< 转发观点
    XWOpinionComposeViewTypeComment, ///< 发评论
};

/// 发布观点
@interface XWOpinionComposeViewController : UIViewController
@property (nonatomic, assign) XWOpinionComposeViewType type;
@property (nonatomic, copy) void (^dismiss)(void);
@end
