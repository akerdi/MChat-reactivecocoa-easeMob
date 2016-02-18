//
//  SHSignManager.m
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHSignManager.h"
#import "SHInfoManager.h"

@implementation SHSignManager



//+(SHSignManager *)shareInstance{
//    static SHSignManager *instance = nil;
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        instance = [[self alloc]init];
//    });
//    return instance;
//    
//}

-(void)loginWithName:(NSString *)name pass:(NSString *)pass completeBlock:(SignManagerBlock)signBlock
{
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:name password:pass completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            signBlock(1);
            [[SHInfoManager sharedInfoInstance]setInfoWithDiction:loginInfo];
//            是否为自动登陆，现在默认如此
            BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
            if (!isAutoLogin) {
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                
                //TODO:这里还没有做完，自动登陆完，会有SDK回调
                // 登录成功后，自动去取好友列表
                // SDK获取结束后，会回调
                // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error方法。
//                [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];

            }
        }else{
            signBlock(0);
        }
        NSLog(@"loginInfo:%@error:%@",loginInfo,error);
    } onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}
-(void)registerWithName:(NSString *)name pass:(NSString *)pass completeBlock:(SignManagerBlock)signBlock{
//    EMError *error = nil;
//    
//    BOOL isSuccess = [[EaseMob sharedInstance].chatManager registerNewAccount:name password:pass error:&error];
//    
//    signBlock(isSuccess);
    
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:name password:pass withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            signBlock(1);
        }else{
            signBlock(0);
        }
        NSLog(@"username:%@password:%@error:%@",username,password,error);
    } onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    
    
}


-(void)loginOutWithCompleteBlock:(SignManagerBlock)signBlock{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            signBlock(1);
        }
    } onQueue:nil];
}

@end
