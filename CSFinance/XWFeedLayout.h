//
//  XWFeedLayout.h
//  CSFinance
//
//  Created by vivi wu on 2018/4/25.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

//@protocol XWBasicCellModel<NSObject>
//@property (weak, nonatomic) UILabel *titleLabel;
//@property (weak, nonatomic) UIImageView *imageView;
//- (void)refreshWithLayoutModel:(id)model;
//@end

@interface XWItemLayout : NSObject

@property (nonatomic, copy) NSString * reuseID;
@property (nonatomic, assign) NSInteger cellStyle;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) UIImage * image;
@property (nonatomic, copy) NSDictionary * linkInfo;    //url / command /time /...

@property (nonatomic, assign) CGFloat height;    //TableViewCell
@property (nonatomic, assign) CGSize size;  //CollectionViewCell

@end

@interface XWGroupLayout : NSObject
@property (nonatomic, strong) XWItemLayout * headerLayout;
@property (nonatomic, strong) XWItemLayout * footerLayout;
@property (nonatomic, copy) NSString * cellReuseID;

@property (nonatomic, copy) NSArray<XWItemLayout*>* itemLayouts;
- (instancetype)initWithData:(NSArray<XWItemLayout*>*)itemLayouts;

- (XWItemLayout *) headerLayout;
- (XWItemLayout *) footerLayout;

@end

@interface XWFeedLayout : NSObject

@end
