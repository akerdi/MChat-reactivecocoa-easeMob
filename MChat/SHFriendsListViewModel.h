//
//  SHFriendsListManager.h
//  MChat
//
//  Created by 小帅，，， on 15/11/3.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "RVMViewModel.h"
#import "SHHttpManager.h"
#import <ReactiveCocoa.h>

@interface SHFriendsListViewModel : RVMViewModel

@property (nonatomic, strong) RACSubject *updatedContentSignal;

@property (nonatomic, strong) NSMutableArray *friendListArray;

@property (nonatomic, strong)   NSNumber *unsubscribedCountNum;


+(id)FriendsListViewModel;

-(void)getFriendsList;

-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
