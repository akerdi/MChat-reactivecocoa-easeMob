//
//  SHChatViewModel.h
//  MChat
//
//  Created by 小帅，，， on 15/11/5.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "RVMViewModel.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "EaseMob.h"
#import "JSQMessagesBubbleImage.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "UIColor+JSQMessages.h"
#import "JSQMessage.h"

@interface SHChatViewModel : RVMViewModel

@property (nonatomic, strong) RACSignal *fetchLaterSignal;
@property (nonatomic, strong) RACSignal *fetchEarlierSignal;
@property (nonatomic, strong) NSString *buddyID;
@property (nonatomic, strong) NSMutableArray *earlierResultsArray;
@property (nonatomic, strong) NSMutableArray *totalResultsArray;
@property (nonatomic, strong) EMConversation *conversation;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

//将emMessage转换为JSQMessage
+(JSQMessage *)emMessageChangeIntoJSQ:(EMMessage *)message senderID:(NSString *)senderID senderDisplayName:(NSString *)senderDisplayName;
+(EMMessage *)messageWith:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)displayName receiver:(NSString *)receiver messageType:(EMMessageType)type;
//将chatter 改为如：shaohung#chatwe_akerdii@easemob.com
+(NSString *)chatterJIDWithChatter:(NSString *)chatter;
//TODO 由于没有找到如何辨别当前聊天对象，所以这里在UserDefault加载一个标示，为conversation.chatter
+(void)nowChatterMarkOnUSERDEFAULT:(NSString *)chatter;

-(instancetype)initWithBuddyID:(EMConversation *)conversation;


-(void)sendMessageWithText:(NSString *)text;
-(void)sendMessageWithImage:(UIImage *)image;
-(void)sendMessageWithLocation:(CLLocation *)clLocation;


@end
