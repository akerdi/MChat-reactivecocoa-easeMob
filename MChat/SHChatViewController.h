//
//  SHChatViewController.h
//  MChat
//
//  Created by 小帅，，， on 15/11/5.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "EaseMob.h"



@interface SHChatViewController : JSQMessagesViewController

-(instancetype)initWithConversation:(EMConversation *)conversation;
@property (nonatomic, assign) EMConversationType type;

@end
