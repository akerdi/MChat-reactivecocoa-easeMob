//
//  SHFriendsListManager.m
//  MChat
//
//  Created by 小帅，，， on 15/11/3.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHFriendsListViewModel.h"
#import "SHInfoManager.h"
#import <RACEXTScope.h>

@interface SHFriendsListViewModel ()

@property (nonatomic, strong) NSArray *section1Array;
@property (nonatomic, strong) NSString *indexRow0;

@end

@implementation SHFriendsListViewModel


SingletonCreate(FriendsListViewModel);


-(id)init{
    if (self = [super init]) {
        
        self.friendListArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.section1Array = @[@"",@"群聊",@"公众号"];
        
        @weakify(self);
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            //去拿朋友list
            @strongify(self);
            
            
            [self getFriendsList];
            
            
        }];
        SHInfoManager *infoManager = [SHInfoManager sharedInfoInstance];
        RAC(self,active) = [RACObserve(infoManager, token) map:^id(id value) {
            if (value) {
                return @(YES);
            }
            return @(NO);
        }];
        
        
        
        
        self.updatedContentSignal = [[RACSubject subject]setNameWithFormat:@"%@updatedContentSignal",NSStringFromClass([SHFriendsListViewModel class])];
        
        
    }
    return self;
}

-(void)getFriendsList{
    @weakify(self);
    [[SHHttpManager sharedManager] getFriendsListWithDiction:nil success:^(NSArray *list, NSError *error) {
        @strongify(self);
        if (self.friendListArray.count) {
            [self.friendListArray removeAllObjects];
        }
        
        [self.friendListArray addObject:self.section1Array];
        [self.friendListArray addObject:list];
        [self.updatedContentSignal sendNext:nil];
    } fail:^(NSError *error) {
        Log(error);
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - DataSource
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.friendListArray[section] count];
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.friendListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}







@end
