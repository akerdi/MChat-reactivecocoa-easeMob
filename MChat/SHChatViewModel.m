//
//  SHChatViewModel.m
//  MChat
//
//  Created by 小帅，，， on 15/11/5.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHChatViewModel.h"






#define TOTAL_EARLIER_MESSAGES 15



@interface SHChatViewModel ()

@property (nonatomic, strong) NSDate *earlierDate;
@property (nonatomic, strong) NSDate *laterDate;

@end

@implementation SHChatViewModel

-(instancetype)initWithBuddyID:(EMConversation *)conversation{
    if (self = [super init]) {
        self.conversation = conversation;
        
        self.fetchEarlierSignal = [RACSubject subject];
        self.fetchLaterSignal = [RACSubject subject];
        self.totalResultsArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.earlierResultsArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
        [self fetchEarlierMessages];
        
    }
    return self;
}


-(void)fetchEarlierMessages{
    if (!self.earlierDate) {
        self.earlierDate = [NSDate date];
    }
    NSArray *conversationMessages = [self.conversation loadNumbersOfMessages:TOTAL_EARLIER_MESSAGES before:[self.earlierDate timeIntervalSince1970]*1000];
    /*
     po [[[[conversationMessages firstObject] messageBodies] firstObject] class]
     EMTextMessageBody
     */
    [conversationMessages enumerateObjectsUsingBlock:^(EMMessage *message, NSUInteger idx, BOOL *stop) {
        if (idx==0) {
            self.earlierDate = [NSDate dateWithTimeIntervalSince1970:message.timestamp];
        }
    }];
    [self.earlierResultsArray addObjectsFromArray:conversationMessages];
    
    [self mergeTotleMessages];
    
    
    if (conversationMessages.count) {
        [(RACSubject *)self.fetchEarlierSignal sendNext:nil];
    }
    
    
}


-(void)mergeTotleMessages{
    if (self.earlierResultsArray.count) {
        NSMutableArray *arrray = [self changeIntoJSQMessageType];
        [self.totalResultsArray addObjectsFromArray:arrray];
        [self.earlierResultsArray removeAllObjects];
    }
}


-(NSMutableArray *)changeIntoJSQMessageType{
    NSMutableArray *arrray = [NSMutableArray array];
    for (EMMessage *message in self.earlierResultsArray) {
        NSLog(@"%@  %@  %@",message.messageBodies,message.from,message.to);
        JSQMessage *jsqMessage = [SHChatViewModel emMessageChangeIntoJSQ:message senderID:[SHChatViewModel chatterJIDWithChatter:message.from] senderDisplayName:message.messageType==eMessageTypeChat?message.from:message.groupSenderName];
        [arrray addObject:jsqMessage];
    }
    return arrray;
}

+(NSString *)chatterJIDWithChatter:(NSString *)chatter{
    return [NSString stringWithFormat:@"%@_%@@%@",AppKey,chatter,SDK_NAME];
}


+(JSQMessage *)emMessageChangeIntoJSQ:(EMMessage *)message senderID:(NSString *)senderID senderDisplayName:(NSString *)senderDisplayName{
    NSArray *array = message.messageBodies;
    EMTextMessageBody *textBody = [array firstObject];
    JSQMessage *jsqMessage = [[JSQMessage alloc]initWithSenderId:senderID senderDisplayName:senderDisplayName date:[NSDate dateWithTimeIntervalSince1970:message.timestamp*1000] text:textBody.text];
    return jsqMessage;
}

+(EMMessage *)messageWith:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)displayName receiver:(NSString *)receiver messageType:(EMMessageType)type{
    EMChatText *chatText = [[EMChatText alloc]initWithText:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithChatObject:chatText];
    EMMessage *retureMsg = [[EMMessage alloc]initWithReceiver:receiver bodies:@[body]];
    retureMsg.requireEncryption = NO;
    retureMsg.messageType = type;//eMessageTypeChat;
    retureMsg.ext = nil;
    
    return retureMsg;
}


+(void)nowChatterMarkOnUSERDEFAULT:(NSString *)chatter{
    [USERD setObject:chatter forKey:NOW_CHATTER];
    [USERD synchronize];
}


-(void)sendMessageWithText:(NSString *)text{
    
}
-(void)sendMessageWithImage:(UIImage *)image{
    
}
-(void)sendMessageWithLocation:(CLLocation *)clLocation{
    
}





@end
