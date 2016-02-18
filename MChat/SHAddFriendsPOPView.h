//
//  SHAddFriendsPOPView.h
//  MChat
//
//  Created by 小帅，，， on 15/11/13.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Add_FriendPOPBlock)(NSIndexPath *indexPath);

@interface SHAddFriendsPOPView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) Add_FriendPOPBlock block;

@end
