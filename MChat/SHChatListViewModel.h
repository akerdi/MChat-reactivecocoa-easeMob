//
//  SHChatViewModel.h
//  MChat
//
//  Created by 小帅，，， on 15/11/4.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "RVMViewModel.h"
#import <RACSignal.h>

@interface SHChatListViewModel : RVMViewModel

@property (nonatomic, strong) NSNumber *unreadTotalMessages;
@property (nonatomic, strong) RACSignal *updatedContentSignal;
@property (nonatomic, strong) NSMutableArray *chatListArray;


+(instancetype)sharedInstance;
-(void)decreaseTotalUnreadMessagesWithCount:(NSUInteger)readCount;
-(void)deleteRecentContactWithChatter:(NSDictionary *)diction;
- (BOOL)resetUnreadMessagesCountWithChatter:(NSDictionary *)diction;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;

-(void)loadAllConversation;
-(void)loadAllUnreadMesssageCount;



-(BOOL)addGroupConversation:(NSArray *)group groupInfo:(NSDictionary *)infoDic;



@end
