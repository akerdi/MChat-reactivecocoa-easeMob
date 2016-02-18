//
//  SHSignManager.h
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"


typedef void(^SignManagerBlock)(BOOL);


@interface SHSignManager : NSObject

//+(SHSignManager *)shareInstance;

-(void)loginWithName:(NSString *)name pass:(NSString *)pass completeBlock:(SignManagerBlock)signBlock;
-(void)registerWithName:(NSString *)name pass:(NSString *)pass completeBlock:(SignManagerBlock)signBlock;

-(void)loginOutWithCompleteBlock:(SignManagerBlock)signBlock;

@end
