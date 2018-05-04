//
//  XWFund.h
//  CSFinance
//
//  Created by vivi wu on 2018/5/3.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWFund : NSObject
@property (nonatomic, copy) NSString * fund_id;     //"HF000049U5"
@property (nonatomic, copy) NSString * income;      //"51.72"
@property (nonatomic, copy) NSString * fund_name;   //"红亨稳赢三期"
@property (nonatomic, assign) NSInteger sort_no;    //1
@property (nonatomic, copy) NSNumber * nav;         //"1.5818"
@property (nonatomic, copy) NSString * sharp;       //""
@property (nonatomic, copy) NSString * nav_date;    //"04-20"
@end

@interface XWJsonData : NSObject
@property (nonatomic, assign) NSInteger total;      //6413
@property (nonatomic, assign) BOOL is_login;        //true
@property (nonatomic, strong) NSArray<XWFund *> * list;         //
@end

@interface XWRequestResponse : NSObject
@property (nonatomic, assign) NSInteger status;     //0
@property (nonatomic, strong) XWJsonData * data;     ///Dic<NSString *, XWJsonData *>
@property (nonatomic, copy) NSString * msg;         //"NO ERROR!"
@end

