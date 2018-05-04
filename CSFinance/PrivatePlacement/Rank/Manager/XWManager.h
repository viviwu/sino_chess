//
//  XWManager.h
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XWManager : NSObject
@property (nonatomic, copy) NSString * manager_name;    //"王强",
@property (nonatomic, assign) NSInteger sort_no;        //1
@property (nonatomic, copy) NSString * company_name;    //"上海保银投资",
@property (nonatomic, copy) NSNumber * income;          //"1406.56",
@property (nonatomic, copy) NSString * manager_id;      //"PL00000376"
@end

@interface XWManagerData : NSObject
@property (nonatomic, assign) NSInteger total;          //6413
@property (nonatomic, assign) BOOL is_login;            //true
@property (nonatomic, strong) NSArray<XWManager*>* list;   //
@end

@interface XWManagerResponse : NSObject
@property (nonatomic, assign) NSInteger status;     //0
@property (nonatomic, strong) XWManagerData * data;     ///Dic<NSString *, XWFundData *>
@property (nonatomic, copy) NSString * msg;         //"NO ERROR!"
@end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
