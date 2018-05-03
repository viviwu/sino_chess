//
//  ZFJVideo.h
//  CSFinance
//
//  Created by csco on 2018/5/3.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSObject+YYModel.h"

@interface ZFJVideo : NSObject
@property NSString * ID;        //id "530"
@property NSString * thumb;     //"https:\/\/oss-cn-hangzhou.aliyuncs.com\/jfzapp-static2\/ad\/0aac976a28bb04364cf37eadbc70a3a4.jpg"
@property NSString * choiceType;//"video"
@property NSString * cate;      //"1"
@property NSString * url;       //"http:\/\/h5.jinfuzi.com\/fortune\/video\/530"
@property NSString * type;      //"3"
@property NSString * weight;    //
@property NSString * title;     //" 2018资本市场高峰论坛暨金斧子上海财富中心乔迁典礼——人工智能行业分享"
@property NSString * cateDesc;  //"路演直播"
@property NSString * endTime;   //"1524304200"
@property NSString * number;    //"6170观看"
@property NSString * orderNumber;       //
@property NSString * duration;       //"00:50:38"
@property NSString * startTime;       //"1524292200"
@property NSString * status;       //"3"
@end

@interface ZFJVideoList: NSObject
@property (nonatomic, strong) NSDictionary * page;
@property (nonatomic, strong) NSArray<ZFJVideo *> *videoItems;
@property NSString * cate;
@end
