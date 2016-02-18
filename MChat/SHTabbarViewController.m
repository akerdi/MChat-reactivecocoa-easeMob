//
//  SHTabbarViewController.m
//  MChat
//
//  Created by 小帅，，， on 15/11/3.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHTabbarViewController.h"
#import "SHChatListTableViewController.h"
#import "SHListTableViewController.h"
#import "SHShareTableViewController.h"
#import "SHMineTableViewController.h"
#import "SHUIHelper.h"
#import <ReactiveCocoa.h>
#import "TTGlobalUICommon.h"
#import "SHChatListViewModel.h"
#import "SHFriendsListViewModel.h"

@interface SHTabbarViewController ()

@end

@implementation SHTabbarViewController

-(id)init{
    if (self = [super init]) {
        self.viewControllers = [self setupViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(NSArray *)setupViewControllers{
    UINavigationController *chatNav = [self viewControllers:[SHChatListTableViewController sharedInstance]];
    UINavigationController *listNav = [self viewControllers:[[SHListTableViewController alloc]initWithStyle:UITableViewStylePlain]];
    UINavigationController *shareNav = [self viewControllers: [[SHShareTableViewController alloc]initWithStyle:UITableViewStylePlain]];
    UINavigationController *mineNav = [self viewControllers: [[SHMineTableViewController alloc]initWithStyle:UITableViewStyleGrouped]];
    
    [SHUIHelper configAppearenceForNavigationBar:chatNav.navigationBar];
    [SHUIHelper configAppearenceForNavigationBar:listNav.navigationBar];
    [SHUIHelper configAppearenceForNavigationBar:shareNav.navigationBar];
    [SHUIHelper configAppearenceForNavigationBar:mineNav.navigationBar];
    
    
    
    
    [self setTabbarItem:chatNav Title:@"聊我" image:@"Icon_TabBar_Chat" selectedName:@"Icon_TabBar_ChatHL"];
    [self setTabbarItem:listNav Title:@"通讯录" image:@"Icon_TabBar_FriendsList" selectedName:@"Icon_TabBar_FriendsListHL"];
    [self setTabbarItem:shareNav Title:@"动态" image:@"Icon_TabBar_Shared" selectedName:@"Icon_TabBar_SharedHL"];
    [self setTabbarItem:mineNav Title:@"我" image:@"Icon_TabBar_Setting" selectedName:@"Icon_TabBar_SettingHL"];
    
    
    
    RAC(chatNav,tabBarItem.badgeValue) = [RACObserve([SHChatListViewModel sharedInstance], unreadTotalMessages) map:^id(id value) {
        NSInteger badgeValue = [value integerValue];
        return badgeValue>0?[NSString stringWithFormat:@"%ld",badgeValue]:nil;
    }];
    
    
    return @[chatNav,listNav,shareNav,mineNav];
    
    
    
    
    
    
    
}

-(void)setTabbarItem:(UINavigationController *)nav Title:(NSString *)title image:(NSString *)imageName selectedName:(NSString *)selectedName{
    if (TTOSVersionIsAtLeast7()) {
        nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        
    }
}

-(UINavigationController *)viewControllers:(UIViewController *)viewC{
    return [[UINavigationController alloc]initWithRootViewController:viewC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
