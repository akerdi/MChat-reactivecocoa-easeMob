//
//  SHHttpManager.m
//  MChat
//
//  Created by 小帅，，， on 15/11/3.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHHttpManager.h"
#import "SHChatListViewModel.h"
#import "SHFriendsListViewModel.h"
#import "SHInfoManager.h"
#import "SHUnreadBuddyRequestModel.h"



@interface SHHttpManager ()<IChatManagerDelegate,EMCallManagerDelegate>



@end

@implementation SHHttpManager
@synthesize unreadBuddyRequest;

+(SHHttpManager *)sharedManager{
    static SHHttpManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[SHHttpManager alloc]init];
    });
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        [self registerNotifications];
        self.unreadBuddyRequest = [[NSMutableArray alloc]initWithCapacity:0];
        SHInfoManager *infoM = [SHInfoManager sharedInfoInstance];
        RAC(self,active) = [RACObserve(infoM, token) map:^id(NSString *value) {
            return @(value.length>0);
        }];
        
        [RACObserve(self, didBecomeActiveSignal) subscribeNext:^(id x) {
            
        }];
        
    }
    return self;
}

-(void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - private

-(void)registerNotifications
{
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}


#pragma mark ----Conversation

//http://docs.easemob.com/doku.php?id=start:300iosclientintegration:50emconv

-(void)conversationForChatter:(NSDictionary *)diction success:(HTTPSuccessBlock)successBlock fail:(HTTPFailBlock)failBlock{
    NSString *buddy = diction[@"buddy"];
    NSInteger emConversationType = [diction[@"(MConversationType"] integerValue];
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:buddy conversationType:emConversationType];
    successBlock(conversation,nil);
}
-(BOOL)removeConversationByChatter:(NSDictionary *)diction{
    NSString *buddy = diction[@"buddy"];
    BOOL deleteMessages = [diction[@"deleteMessages"] boolValue];
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeConversationByChatter:buddy deleteMessages:deleteMessages append2Chat:YES];
    return isSuccess;
    
}
-(BOOL)removeAllRecentConversation{
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeAllConversationsWithDeleteMessages:YES append2Chat:YES];
    return isSuccess;
    
}


-(NSArray *)getConversations{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    return conversations;
}
-(NSArray *)loadAllConversationsFromDatabase{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    return conversations;
}

-(NSUInteger)getUnreadMessagesCountWithDiction:(NSDictionary *)diction{
    NSString *buddy = diction[@"buddy"];
    NSUInteger unReadMessages = [[EaseMob sharedInstance].chatManager unreadMessagesCountForConversation:buddy];
    return unReadMessages;
}
//这条我觉的一般都用不上
-(void)loadTotleUnreadMessagesFromDataBaseWithSuccess:(HTTPSuccessBlock)successBlock fail:(HTTPFailBlock)failBlock{
    NSUInteger unReadMessages = [[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];
    successBlock(@(unReadMessages),nil);
    
}


-(id)createGroupConversationWithBuddys:(NSArray *)group groupInfo:(NSDictionary *)infoDic{
    
    
    EMError *error = nil;
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc]init];
    groupStyleSetting.groupMaxUsersCount = 500;
    //    eGroupStyle_PrivateMemberCanInvite
    //    eGroupStyle_PublicOpenJoin
    
    
//    @[@"767838865",@"13764516851",@"18101616875"]
    groupStyleSetting.groupStyle = eGroupStyle_PublicOpenJoin;
    EMGroup *groupp = [[EaseMob sharedInstance].chatManager createGroupWithSubject:infoDic[@"subject"] description:infoDic[@"description"] invitees:group initialWelcomeMessage:@"邀请您加入群组" styleSetting:groupStyleSetting error:&error];
    if (!error) {
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:groupp.groupId conversationType:eConversationTypeGroupChat];
        return conversation;
    }
    else{
        return nil;
    }
}






#pragma mark ----FriendsList && accept reject request

//http://docs.easemob.com/doku.php?id=start:300iosclientintegration:90buddymgmt



-(void)getFriendsListWithDiction:(NSDictionary *)infoDiction success:(HTTPSuccessBlock)successBlock fail:(HTTPFailBlock)failBlock{
//    回调用分线程，UI用主线程处理
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (error) {
            failBlock(error);
        }else{
            successBlock(buddyList,error);
        }
    } onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

-(BOOL)addBuddyWithDiction:(NSDictionary *)diction {
    NSString *buddy = diction[@"buddy"];
    NSString *message = diction[@"message"];
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:buddy message:message error:nil];
    return isSuccess;
}
-(BOOL)acceptBuddyRequestWithDiction:(NSDictionary *)diction{
    NSString *buddy = diction[@"buddy"];
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:buddy error:nil];
    return isSuccess;
}
-(BOOL)rejectBuddyRequestWithDiction:(NSDictionary *)diction{
    NSString *buddy = diction[@"buddy"];
    NSString *reason = diction[@"reason"];
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:buddy reason:reason error:nil];
    return isSuccess;
}



- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    SHUnreadBuddyRequestModel *object = [SHUnreadBuddyRequestModel new];
    object.userName = username;
    object.message = message;
    [self.unreadBuddyRequest addObject:object];
    NSLog(@"%s:::::::::%@:::::::%@",__func__,username,message);
}

#pragma mark Chat Manager



-(BOOL)sendMessageWitMessasge:(EMMessage *)message{
    EMMessage *msg = [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
    if (msg) {
        return 1;
    }
    return 0;
    
}

- (void)setProgress:(float)progress
         forMessage:(EMMessage *)message{
    NSLog(@"%f========%@",progress,message);
}

- (void)didUnreadMessagesCountChanged{
    [[SHChatListViewModel sharedInstance]loadAllUnreadMesssageCount];
}
// 已经同意并且加入群组后的回调
- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error
{
//    由于微信没有增加这个提示特性，这里先这样TODO
    NSLog(@"%s---%@---%@",__func__,group,error);
}

-(void)didReceiveMessage:(EMMessage *)message{
    
    NSString *chatter = [USERD objectForKey:NOW_CHATTER];
    if (chatter) {
        if ([chatter isEqualToString:message.from]) {
            [[[EaseMob sharedInstance].chatManager conversationForChatter:message.from conversationType:message.messageType] markMessageWithId:message.messageId asRead:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NEW_MESSAGE_COME object:message userInfo:nil];
        }
    }
    [[SHChatListViewModel sharedInstance]loadAllConversation];
    
    
    
    
    
    
    
//    id<IEMMessageBody> msgBody = [message.messageBodies firstObject];
//    [[SHChatListViewModel sharedInstance]loadAllConversation];
//    switch ([msgBody messageBodyType]) {
//        case eMessageBodyType_Text:
//        {
//            // 收到的文字消息
//            NSString *txt = ((EMTextMessageBody *)msgBody).text;
//            NSLog(@"收到的文字是 txt -- %@",txt);
//        }
//            break;
//        case eMessageBodyType_Image:
//        {
//            // 得到一个图片消息body
//            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
//            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
//            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
//            NSLog(@"大图的secret -- %@"    ,body.secretKey);
//            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
//            NSLog(@"大图的下载状态 -- %lu",body.attachmentDownloadStatus);
//            
//            
//            // 缩略图sdk会自动下载
//            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
//            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
//            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
//            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
//            NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
//        }
//            break;
//        case eMessageBodyType_Location:
//        {
//            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
//            NSLog(@"纬度-- %f",body.latitude);
//            NSLog(@"经度-- %f",body.longitude);
//            NSLog(@"地址-- %@",body.address);
//        }
//            break;
//        case eMessageBodyType_Voice:
//        {
//            // 音频sdk会自动下载
//            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
//            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
//            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
//            NSLog(@"音频的secret -- %@"        ,body.secretKey);
//            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
//            NSLog(@"音频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
//            NSLog(@"音频的时间长度 -- %lu"      ,body.duration);
//        }
//            break;
//        case eMessageBodyType_Video:
//        {
//            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
//            
//            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
//            NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
//            NSLog(@"视频的secret -- %@"        ,body.secretKey);
//            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
//            NSLog(@"视频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
//            NSLog(@"视频的时间长度 -- %lu"      ,body.duration);
//            NSLog(@"视频的W -- %f ,视频的H -- %f", body.size.width, body.size.height);
//            
//            // 缩略图sdk会自动下载
//            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
//            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailRemotePath);
//            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
//            NSLog(@"缩略图的下载状态 -- %lu"      ,body.thumbnailDownloadStatus);
//        }
//            break;
//        case eMessageBodyType_File:
//        {
//            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
//            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
//            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
//            NSLog(@"文件的secret -- %@"        ,body.secretKey);
//            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
//            NSLog(@"文件文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
//        }
//            break;
//            
//        default:
//            break;
//    }
    
}




@end
