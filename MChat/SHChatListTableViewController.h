//
//  SHChatTableViewController.h
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHChatListViewModel.h"


@interface SHChatListTableViewController : UITableViewController
@property (nonatomic, strong) SHChatListViewModel *viewModel;

+(id)sharedInstance;

@end
