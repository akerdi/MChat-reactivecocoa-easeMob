//
//  AppDelegate.m
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "SHLoginViewController.h"
#import "SHTabbarViewController.h"
#import "RDVTabBarController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "TTGlobalUICommon.h"
#import "SHHttpManager.h"


@interface AppDelegate ()

@property (nonatomic, strong) SHTabbarViewController *tabBarController;

@end

@implementation AppDelegate

-(void)netWork{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
}

- (void)configAppAppearance
{
    if (TTOSVersionIsAtLeast7()) {
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBarTintColor:APP_MAIN_COLOR];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else {
        [[UIBarButtonItem appearance] setTintColor:APP_MAIN_COLOR];
        [[UINavigationBar appearance] setTintColor:APP_MAIN_COLOR];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    
    [[UITabBar appearance] setBackgroundColor:APP_MAIN_COLOR];
    [[UITabBar appearance] setTintColor:APP_MAIN_COLOR];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self netWork];
    [self configAppAppearance];
    [SHHttpManager sharedManager];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [[EaseMob sharedInstance]registerSDKWithAppKey:AppKey apnsCertName:nil];
    [[EaseMob sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    
    UINavigationController *nav = [UINavigationController alloc];
    SHLoginViewController *loginVC = [[SHLoginViewController alloc]init];
    nav = [nav initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    
    
    
    
    return YES;
}


-(void)changeToTabbarC{
    
    if (!self.tabBarController) {
        self.tabBarController = [[SHTabbarViewController alloc]init];
    }
    
    self.window.rootViewController = nil;
    self.window.rootViewController = self.tabBarController;
    
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    [[EaseMob sharedInstance]applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[EaseMob sharedInstance]applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

@end
