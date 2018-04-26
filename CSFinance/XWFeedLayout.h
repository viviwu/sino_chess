//
//  XWFeedLayout.h
//  CSFinance
//
//  Created by vivi wu on 2018/4/25.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface XWCellLayout : NSObject

@property (nonatomic, assign) CGSize size;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) UIImage * image;

@end

@interface XWSectionLayout : NSObject
@property (nonatomic, copy) NSString * cellReuseID;
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, copy) NSString * headerTitle;
@property (nonatomic, assign) CGSize footerSize;
@property (nonatomic, copy) NSString * footerTitle;
@property (nonatomic, copy) NSArray<XWCellLayout*>* celllayouts;
- (instancetype)initWithData:(NSArray<XWCellLayout*>*)celllayouts;

@end

@interface XWFeedLayout : NSObject

@end
