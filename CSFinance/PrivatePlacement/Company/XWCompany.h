//
//  XWCompany.h
//  CSFinance
//
//  Created by csco on 2018/5/4.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface XWCompany : NSObject
@property (nonatomic, copy) NSString * company_name;    //"上海保银投资",
@property (nonatomic, assign) NSInteger sort_no;        //1
@property (nonatomic, copy) NSNumber * income;          //"1406.56",
@property (nonatomic, copy) NSString * company_id;      //"PL00000376"
@property (nonatomic, copy) NSString * fund_managers;    //"王强","--"
@end

@interface XWCompanyData : NSObject
@property (nonatomic, assign) NSInteger total;          //6413
@property (nonatomic, assign) BOOL is_login;            //true
@property (nonatomic, strong) NSArray<XWCompany*>* list;   //
@end

@interface XWCompanyResponse : NSObject
@property (nonatomic, assign) NSInteger status;     //0
@property (nonatomic, strong) XWCompanyData * data;     ///Dic<NSString *, XWFundData *>
@property (nonatomic, copy) NSString * msg;         //"NO ERROR!"
@end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
