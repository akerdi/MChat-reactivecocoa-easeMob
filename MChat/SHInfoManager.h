//
//  SHInfoManager.h
//  MChat
//
//  Created by 小帅，，， on 15/11/3.
//  Copyright (c) 2015年 Hong. All rights reserved.
//
/*
 {
 LastLoginTime = 1446527016595;
 jid = "shaohung#chatwe_akerdi@easemob.com";
 password = Aa123456;
 resource = mobile;
 token = YWMtPWJt2IHoEeWDEef0xnd8SQAAAVIAuC7074ByQtR1w1dvNH0S9Yph63p4Av8;
 username = akerdi;
 }

 */
#import <Foundation/Foundation.h>

@interface SHInfoManager : NSObject
@property (nonatomic, strong) NSNumber *LastLoginTime;
@property (nonatomic, copy) NSString *jid;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *resource;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *username;

+(id)sharedInfoInstance;

-(void)setInfoWithDiction:(NSDictionary *)dic;

@end
