//
//  SHListTableViewController.m
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHListTableViewController.h"
#import "SHFriendsListTableViewCell.h"
#import "SHFriendsListViewModel.h"
#import "UISearchBar+SHRAC.h"
#import "UISearchDisplayController+SHRAC.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "SHChatViewController.h"
#import "SHChatListTableViewController.h"
#import "SHBuddyRequestTableVC.h"
#import "SHChatListViewModel.h"
#import "SHChatViewModel.h"


@interface SHListTableViewController ()
{
    NSString *_unreadBuddyRequestStr;
}

@property (nonatomic, strong) SHFriendsListViewModel *viewModel;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSString *unreadBuddyRequestStr;
@end

@implementation SHListTableViewController

-(id)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        _unreadBuddyRequestStr = @"新的朋友";
        self.viewModel = [SHFriendsListViewModel FriendsListViewModel];
    }
    return self;
}

-(NSArray *)search:(NSString *)text{
    NSMutableArray *array = [NSMutableArray array];
    for (EMBuddy *buddy in [self.viewModel.friendListArray lastObject]) {
        if ([[buddy.username lowercaseString] rangeOfString:[text lowercaseString]].location !=NSNotFound) {
            [array addObject:buddy];
        }
    }
    return array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    self.unreadBuddyRequestStr = @"新的朋友";
    @weakify(self);
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        NSInteger unreadBuddyRequestCount = [SHHttpManager sharedManager].unreadBuddyRequest.count;
        self.unreadBuddyRequestStr = unreadBuddyRequestCount>0?[NSString stringWithFormat:@"新的朋友(%ld)",unreadBuddyRequestCount]:@"新的朋友";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    self.searchBar = [[UISearchBar alloc]init];
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    
    self.displayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    
    self.tableView.rowHeight = FriendsList_ROWHEIGHT;
    
    RAC(self,searching) = [self.displayController rac_isActive];
    RAC(self,resultArray) = [self rac_liftSelector:@selector(search:) withSignals:self.searchBar.rac_textDidChange, nil];
    
    
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
        [self.viewModel.updatedContentSignal sendNext:nil];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searching?1:self.viewModel.friendListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searching?self.resultArray.count:[self.viewModel numberOfItemsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = self.searching?self.resultArray[indexPath.row]:[self.viewModel objectAtIndexPath:indexPath];
    UITableViewCell *cell = nil;
//    else if ([object isKindOfClass:[EMBuddy class]]) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"friendListCell"];
    if (!cell) {
        cell = [[SHFriendsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendListCell"];
    }
    [(SHFriendsListTableViewCell *)cell shouldUpdateCellWithObject:object];
    if (indexPath.row==0&&indexPath.section==0&&self.searching==0) {
        cell.textLabel.text = self.unreadBuddyRequestStr;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Log(indexPath);
    
    if (indexPath.section) {
        self.tabBarController.selectedIndex = 0;
        
        EMBuddy *buddy = self.searching?self.resultArray[indexPath.row]:[self.viewModel objectAtIndexPath:indexPath];
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:buddy.username conversationType:eConversationTypeChat];
        [conversation markAllMessagesAsRead:YES];
//        给予当前聊天对象标示
        [SHChatViewModel nowChatterMarkOnUSERDEFAULT:conversation.chatter];
        //这里做一个操作，如果是新的聊天，那么会再ChatListVC刷新
        NSArray *chatListArray = [SHChatListViewModel sharedInstance].chatListArray;
        if (chatListArray.count) {
            [chatListArray enumerateObjectsUsingBlock:^(EMConversation *chatListConversation, NSUInteger idx, BOOL *stop) {
                if ([chatListConversation.chatter isEqualToString:conversation.chatter]) {
                    *stop = YES;
                }else{
                    if (idx==chatListArray.count-1) {
                        [(RACSubject *)[SHChatListViewModel sharedInstance].updatedContentSignal sendNext:nil];
                    }
                }
            }];
        }else{
            [(RACSubject *)[SHChatListViewModel sharedInstance].updatedContentSignal sendNext:nil];
        }
        SHChatViewController *chatViewC = [[SHChatViewController alloc]initWithConversation:conversation];
        //强制隐藏底部导航栏
        self.tabBarController.tabBar.hidden = YES;
        
        [[(SHChatListTableViewController *)[SHChatListTableViewController sharedInstance] navigationController] pushViewController:chatViewC animated:YES];
    }else{
        NSLog(@"=======%ld      %ld",indexPath.section,indexPath.row);
        switch (indexPath.row) {
            case 0:
            {
                SHBuddyRequestTableVC *requestVC = [[SHBuddyRequestTableVC alloc]initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:requestVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
