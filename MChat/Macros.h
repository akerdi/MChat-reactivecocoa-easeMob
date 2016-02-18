
//
//  Macros.h
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#ifndef MChat_Macros_h
#define MChat_Macros_h

#pragma mark----- ---import Class

#import "NimbusCore.h"

#pragma mark---------define text



#define AppKey @"easemob-demo#chatdemoui"//@"shaohung#chatwe"
#define SDK_NAME @"easemob.com"

#define NowUserName @"nowUserName"
//用来判别是否在和谁聊天
#define NOW_CHATTER @"nowChatter"
#define NEW_MESSAGE_COME @"NEW_MESSAGE_COME"

#define HEAD_IMAGE_DEFAULT_NAME @"headImage_default"
#define Log(log) NSLog(@"%s---%@",__func__,log)


#pragma mark---------define function


#define APP_MAIN_COLOR RGBCOLOR(33.f, 40.f, 42.f)//(63.f,195.f,235.f)//(243.f,214.f,50.f)//
#define CELL_PADDING_10 10
#define CELL_PADDING_8 8
#define CELL_PADDING_6 6
#define CELL_PADDING_4 4
#define CELL_PADDING_2 2
//消息页面Cell固定高度
#define ChatList_ROWHEIGHT 68.f
//朋友列表Cell固定高度
#define FriendsList_ROWHEIGHT 55.f
// group头部高度
#define GROUP_SECTION_HEADER_HEIGHT 20.f

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define USERD [NSUserDefaults standardUserDefaults]


#define SingletonCreate(sharedInstance) + (id)sharedInstance {\
static dispatch_once_t once;\
static id sharedInstance;\
dispatch_once(&once, ^{ sharedInstance = [[self alloc] init]; }); return sharedInstance; }


#endif
