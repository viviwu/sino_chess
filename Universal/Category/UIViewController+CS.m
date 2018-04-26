//
//  UIViewController+CS.m
//  CSWealth
//
//  Created by vivi wu on 2018/2/6.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "UIViewController+CS.h"

@implementation UIViewController (CS)
 
-(UIStatusBarStyle)preferredStatusBarStyle{
    NSLog(@"%s", __func__);
    return UIStatusBarStyleLightContent;
}

-(void)setTabBarItemTitle:(NSString*)title Image:(UIImage*)image
//-(void)setTabBarItemImage:(UIImage*)image
{
    self.title = title;
    self.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAutomatic];
    self.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
