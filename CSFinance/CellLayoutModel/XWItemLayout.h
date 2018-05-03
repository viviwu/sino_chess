//
//  XWItemLayout.h
//  CSFinance
//
//  Created by vivi wu on 2018/4/25.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
 
@interface XWItemLayout : NSObject
@property (nonatomic, copy) NSString * reuseID;
@property (nonatomic, assign) NSInteger cellStyle;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) NSURL * imgUrl;
@property (nonatomic, copy) UIImage * image;
@property (nonatomic, copy) NSURL * url;
@property (nonatomic, copy) NSDictionary * linkInfo;    //url / command /time /...
  
@property (nonatomic, assign) CGFloat height;    //TableViewCell
@property (nonatomic, assign) CGSize size;  //CollectionViewCell
@property (nonatomic, strong) id model;
@end

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

@interface XWItemLayoutGroup : XWItemLayout

@property (nonatomic, copy) NSString * cellReuseID;
@property (nonatomic, assign) NSInteger groupStyle; //XWCollectionCellStyle

//@property (nonatomic, strong) id groupModel;
@property (nonatomic, copy) NSArray<XWItemLayout*>* itemGroup;
- (instancetype)initWithModelGroup:(NSArray<XWItemLayout*>*)itemGroup;

//- (XWItemLayout *) headerLayout;
//- (XWItemLayout *) footerLayout;

@end
 
