//
//  MutiPlayerViewController.h
//  XHomePage
//
//  Created by csco on 2018/4/17.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define STATUS_BAR_TAP_NOTIFICATION @"STATUS_BAR_TAP_NOTIFICATION"

@class AAPLPlayerView;

@interface MutiPlayerViewController : UIViewController

@property (readonly) AVQueuePlayer *player;

/*
 @{
 NSURL(asset URL) : @{
 NSString(title) : NSString,
 NSString(thumbnail) : UIImage
 }
 }
 */
@property NSMutableDictionary *loadedAssets;

@property CMTime currentTime;
@property (readonly) CMTime duration;
@property float rate;


@end
