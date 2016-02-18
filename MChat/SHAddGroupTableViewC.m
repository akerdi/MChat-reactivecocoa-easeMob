//
//  SHAddGroupTableViewC.m
//  MChat
//
//  Created by 小帅，，， on 15/11/14.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHAddGroupTableViewC.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "SHFriendsListViewModel.h"
#import "SHFriendsListTableViewCell.h"
#import "SHChatListViewModel.h"
#import "SHUIHelper.h"

@interface SHAddGroupTableViewC ()

@property (nonatomic, strong) SHFriendsListViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *friendsListArray;
@property (nonatomic, strong) NSMutableArray *buddysArray;


@end

@implementation SHAddGroupTableViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"群组·成员";
    self.buddysArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.viewModel = [SHFriendsListViewModel FriendsListViewModel];
    self.friendsListArray = [self.viewModel.friendListArray lastObject];
    
    self.tableView.rowHeight = FriendsList_ROWHEIGHT;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 36, 36);
    
    [button setTitle:@"完成" forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    @weakify(self);
    [[[[button rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        button.enabled = NO;
        [SHUIHelper showTextMessage:@"正在创建"];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [self signalForAddingGroup];
    }] subscribeNext:^(id x) {
        [SHUIHelper hideWaitingMessageImmediately];
        if ([x boolValue]==1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"创建群失败" delegate:nil cancelButtonTitle:@"上一页" otherButtonTitles:@"退回首页", nil];
            [alert show];
            
            [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
                @strongify(self);
                if ([x integerValue]==1) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
    
}

-(RACSignal *)signalForAddingGroup{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buddysArray.count];
        
        [self.buddysArray enumerateObjectsUsingBlock:^(EMBuddy *buddy, NSUInteger idx, BOOL *stop) {
            [array addObject:buddy.username];
        }];
        
        BOOL isSuccess = [[SHChatListViewModel sharedInstance] addGroupConversation:array groupInfo:self.infoDic];
        if (isSuccess) {
            [subscriber sendNext:@(1)];
        }else{
            [subscriber sendNext:@(0)];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return   self.friendsListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHFriendsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendListCell"];
    if (!cell) {
        cell = [[SHFriendsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id object = [self.friendsListArray objectAtIndex:indexPath.row];
    [cell shouldUpdateCellWithObject:object];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMBuddy *buddy = [self.friendsListArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.buddysArray containsObject:buddy]) {
        [self.buddysArray removeObject:buddy];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }else{
        [self.buddysArray addObject:buddy];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
