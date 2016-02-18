//
//  SHChatTableViewController.m
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHChatListTableViewController.h"
#import "SHChatListTableViewCell.h"
#import "SHChatViewController.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "UISearchBar+SHRAC.h"
#import "UISearchDisplayController+SHRAC.h"
#import "SHTools.h"
#import "EaseMob.h"
#import "SHHttpManager.h"
#import "SHAddFriendsPOPView.h"
#import "UIViewAdditions.h"
#import "SHChatViewModel.h"
#import "SHAddGroupViewController.h"

@interface SHChatListTableViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, strong) NSArray *resultArray;

@end

@implementation SHChatListTableViewController

+(id)sharedInstance{
    static id instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc]initWithStyle:UITableViewStylePlain];
    });
    return instance;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(id)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.viewModel = [SHChatListViewModel sharedInstance];
    }
    return self;
}


-(NSArray *)search:(NSString *)text{
    NSMutableArray *array = [NSMutableArray array];
    for (EMConversation *conversation in self.viewModel.chatListArray) {
        if ([[conversation.chatter lowercaseString] rangeOfString:[text lowercaseString]].location !=NSNotFound) {
            [array addObject:conversation];
        }
    }
    return array;
    
}

-(void)searchUI{
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = ChatList_ROWHEIGHT;
    
    
    self.searchBar = [[UISearchBar alloc]init];
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    
    
    self.displayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.searchResultsTableView.rowHeight = ChatList_ROWHEIGHT;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate =self;
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    @weakify(self);
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    [self searchUI];
    
    
    
    RAC(self,title) = [RACObserve(self.viewModel, unreadTotalMessages) map:^id(NSNumber *value) {
        NSInteger unReadCount = [value integerValue];
        return unReadCount>0?[NSString stringWithFormat:@"聊我(%ld)",unReadCount]:@"聊我";
    }];
    
    RAC(self,searching) = [self.displayController rac_isActive];
    RAC(self,resultArray) = [self rac_liftSelector:@selector(search:) withSignals:self.searchBar.rac_textDidChange, nil];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightItemClick)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}


-(void)rightItemClick{
    
    SHAddFriendsPOPView *addView = [[SHAddFriendsPOPView alloc]initWithFrame:CGRectMake(0, 0, 120, 240)];
    addView.right = self.view.right-8;
    addView.top = self.view.top+8;
    [[UIApplication sharedApplication].keyWindow addSubview:addView];
    @weakify(self);
    addView.block = ^(NSIndexPath *indexPath){
        @strongify(self);
        if (!indexPath.row) {
            
            self.tabBarController.tabBar.hidden = YES;
            SHAddGroupViewController *addGroupVC = [[SHAddGroupViewController alloc]init];
            [self.navigationController pushViewController:addGroupVC animated:YES];
        }else if (indexPath.row==1){
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"添加好友" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertV.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertV show];
            [[alertV rac_buttonClickedSignal]subscribeNext:^(id x) {
                if ([x boolValue]) {//1
                    NSMutableDictionary *diction = [[NSMutableDictionary alloc]init];
                    [diction setObject:[alertV textFieldAtIndex:0].text forKey:@"buddy"];
                    [diction setObject:@"请求加好友" forKey:@"message"];
                    BOOL isSuccess = [[SHHttpManager sharedManager] addBuddyWithDiction:diction];
                    NSLog(@"fsadfads--%d",isSuccess);
                }
            }];
        }else if (indexPath.row==2){
            NSLog(@"扫一扫扫一扫扫一扫");
        }
    };
    
    
}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searching?self.resultArray.count:[self.viewModel numberOfItemsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SHChatListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    EMConversation *conversation = self.searching?self.resultArray[indexPath.row]:[self.viewModel objectAtIndexPath:indexPath];;
    [cell shouldUpdateCellWithObject:conversation];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id object = nil;
    if (self.searching) {
        object = [self.resultArray objectAtIndex:indexPath.row];
    }else{
        object = [self.viewModel objectAtIndexPath:indexPath];
    }
    EMConversation *o = (EMConversation *)object;
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter: o.chatter conversationType:o.conversationType];
    NSInteger unreadCount = conversation.unreadMessagesCount;
    [SHChatViewModel nowChatterMarkOnUSERDEFAULT:conversation.chatter];
    BOOL markSuccess = [conversation markAllMessagesAsRead:YES];
    if (markSuccess) {
        [self.viewModel decreaseTotalUnreadMessagesWithCount:unreadCount];
        [self.tableView reloadData];
    }
    self.tabBarController.tabBar.hidden = YES;
    SHChatViewController *chatVC = [[SHChatViewController alloc]initWithConversation:conversation];
    chatVC.type = conversation.conversationType;
    [self.navigationController pushViewController:chatVC animated:YES];
    NSLog(@"----%@",indexPath);
    
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMConversation *conversation = [self.viewModel objectAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteRecentContactWithChatter:@{
                                                        @"buddy":conversation.chatter,
                                                        @"deleteMessages" : @(1)
                                                        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
