//
//  SHUIHelper.h
//  MChat
//
//  Created by 小帅，，， on 15/11/3.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewAdditions.h"
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define HUD_ANIMATION_DRURATION (0.8f)
#define HUD_LOADING_MESSAGE @"努力加载中..."
#define HUD_LOAD_FAILDMESSAGE @"加载失败！"

@interface SHUIHelper : NSObject

// show hud message
+ (void)showTextMessage:(NSString *)message;
+ (void)showTextMessage:(NSString *)message inView:(UIView *)view;
+ (void)showWaitingMessage:(NSString *)message;
+ (void)showWaitingMessage:(NSString *)message inView:(UIView *)view;
+ (void)showWaitingMessage:(NSString *)message inView:(UIView *)view inBlock:(dispatch_block_t)block;

// hide hud message
+ (void)hideWaitingMessage:(NSString *)message;
+ (void)hideWaitingMessage:(NSString *)message inView:(UIView *)view;
+ (void)hideWaitingMessageImmediately;
+ (void)hideWaitingMessageImmediatelyInView:(UIView *)view;

// show alert text
+ (void)showAlertMessage:(NSString *)message;

// configure flat UI
+ (void)configAppearenceForNavigationBar:(UINavigationBar *)navigationBar;
+ (UIBarButtonItem *)createButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)createButtonItemWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;

// create default table footer view
+ (UIView *)createDefaultTableFooterView;

@end
