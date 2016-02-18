//
//  SHHttpManager.h
//  MChat
//
//  Created by 小帅，，， on 15/11/3.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "EaseMob.h"
#import "RVMViewModel.h"



typedef void(^HTTPSuccessBlock)(id,id);
typedef void(^HTTPFailBlock)(id);





@interface SHHttpManager : RVMViewModel

@property (nonatomic, strong) NSMutableArray *unreadBuddyRequest;

+(SHHttpManager *)sharedManager;

#pragma mark ----Conversation

//http://docs.easemob.com/doku.php?id=start:300iosclientintegration:50emconv


-(void)conversationForChatter:(NSDictionary *)diction success:(HTTPSuccessBlock)successBlock fail:(HTTPFailBlock)failBlock;
-(BOOL)removeConversationByChatter:(NSDictionary *)diction;
-(BOOL)removeAllRecentConversation;
-(NSArray *)getConversations;
-(NSArray *)loadAllConversationsFromDatabase;
-(NSUInteger)getUnreadMessagesCountWithDiction:(NSDictionary *)diction;
//这条我觉的一般都用不上
-(void)loadTotleUnreadMessagesFromDataBaseWithSuccess:(HTTPSuccessBlock)successBlock fail:(HTTPFailBlock)failBlock;

-(id)createGroupConversationWithBuddys:(NSArray *)group groupInfo:(NSDictionary *)infoDic;

#pragma mark ----FriendsList && accept reject request

//http://docs.easemob.com/doku.php?id=start:300iosclientintegration:90buddymgmt

-(void)getFriendsListWithDiction:(NSDictionary *)infoDiction success:(HTTPSuccessBlock)successBlock fail:(HTTPFailBlock)failBlock;

-(BOOL)addBuddyWithDiction:(NSDictionary *)diction ;
-(BOOL)acceptBuddyRequestWithDiction:(NSDictionary *)diction;
-(BOOL)rejectBuddyRequestWithDiction:(NSDictionary *)diction;






-(BOOL)sendMessageWitMessasge:(EMMessage *)message;
-(void)didReceiveMessage:(EMMessage *)message;

@end
