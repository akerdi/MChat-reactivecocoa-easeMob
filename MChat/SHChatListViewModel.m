
//  SHChatViewModel.m
//  MChat
//
//  Created by 小帅，，， on 15/11/4.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHChatListViewModel.h"
#import "SHHttpManager.h"
#import "SHInfoManager.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>


@interface SHChatListViewModel ()



@end

@implementation SHChatListViewModel

SingletonCreate(sharedInstance);

-(id)init{
    if (self = [super init]) {
        
        self.chatListArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        @weakify(self);
        SHInfoManager *infoManager = [SHInfoManager sharedInfoInstance];
        RAC(self,active) = [RACObserve(infoManager, token) map:^id(id value) {
            if (value) {
                return @(1);
            }else{
                return @(0);
            }
        }];
        self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"%@updatedContentSignal",NSStringFromClass([SHChatListViewModel class])];
        
//        - (void)didReceiveMessage:(EMMessage *)message
        
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self loadAllConversation];
            [self loadAllUnreadMesssageCount];
        }];
    }
    return self;
}

-(void)loadAllConversation{
    if (self.chatListArray.count) {
        [self.chatListArray removeAllObjects];
    }
    
    [self.chatListArray addObjectsFromArray:[[SHHttpManager sharedManager]loadAllConversationsFromDatabase]];
    [(RACSubject *)self.updatedContentSignal sendNext:nil];
}
-(void)loadAllUnreadMesssageCount{
    self.unreadTotalMessages = @([[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase]);
}



-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatListArray objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    return self.chatListArray.count;
}


-(void)decreaseTotalUnreadMessagesWithCount:(NSUInteger)readCount{
    self.unreadTotalMessages =  @([self.unreadTotalMessages integerValue]-readCount);
}


- (BOOL)resetUnreadMessagesCountWithChatter:(NSDictionary *)diction{
    self.unreadTotalMessages = @(0);
    return YES;
}

-(void)deleteRecentContactWithChatter:(NSDictionary *)diction{
    BOOL isSuccess = [[SHHttpManager sharedManager] removeConversationByChatter:diction];
    if (isSuccess) {
        [self loadAllConversation];
    }
}



#pragma mark GroupChat

-(BOOL)addGroupConversation:(NSArray *)group groupInfo:(NSDictionary *)infoDic{
    id conversation = [[SHHttpManager sharedManager] createGroupConversationWithBuddys:group groupInfo:infoDic];
    if (conversation) {
        [self loadAllConversation];
        return 1;
    }
    else{
        return 0;
    }
}



@end
