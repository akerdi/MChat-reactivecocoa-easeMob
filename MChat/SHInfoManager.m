//
//  SHInfoManager.m
//  MChat
//
//  Created by 小帅，，， on 15/11/3.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHInfoManager.h"

@implementation SHInfoManager

SingletonCreate(sharedInfoInstance);

-(void)setInfoWithDiction:(NSDictionary *)dic{
    self.LastLoginTime = dic[@"LastLoginTime"];
    self.jid = dic[@"jid"];
    self.password = dic[@"password"];
    self.resource = dic[@"resource"];
    self.token = dic[@"token"];
    self.username = dic[@"username"];
}



@end
