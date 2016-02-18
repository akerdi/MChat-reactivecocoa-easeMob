//
//  SHLoginViewController.m
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHLoginViewController.h"
#import <RACEXTScope.h>
#import <ReactiveCocoa.h>
#import "SHSignManager.h"
#import "AppDelegate.h"
#import "SSKeychain.h"

@interface SHLoginViewController ()<IChatManagerDelegate>

@property (nonatomic, assign) BOOL available;
@property (nonatomic, strong) SHSignManager *signManager;

@end

@implementation SHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"登陆";
    
    _signManager = [[SHSignManager alloc]init];
    
    @weakify(self);
    
    RACSignal *nameAvaliableSigal = [self.nameTF.rac_textSignal map:^id(id value) {
        @strongify(self);
        return @([self availableText:value]);
    }];
    
    RACSignal *passAvaliableSignal = [self.passwordTF.rac_textSignal map:^id(id value) {
        @strongify(self);
        return @([self availableText:value]);
    }];
    
    RAC(self.nameTF,backgroundColor) = [nameAvaliableSigal map:^id(id value) {
        return [value boolValue]?[UIColor clearColor]:[UIColor yellowColor];
    }];
    
    RAC(self.passwordTF,backgroundColor) = [passAvaliableSignal map:^id(id value) {
        return [value boolValue]?[UIColor clearColor]:[UIColor yellowColor];
    }];
    
    
    RAC(self.registerButton,enabled) = [RACSignal combineLatest:@[nameAvaliableSigal,passAvaliableSignal] reduce:^id(NSNumber *nameN,NSNumber *passN){
        return @([nameN boolValue] && [passN boolValue]);
    }];
    
    RAC(self.loginButton,enabled) = RACObserve(self.registerButton, enabled);
    
    
    
    
    [[[[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]doNext:^(id x) {
        @strongify(self);
        self.registerButton.enabled = NO;
        self.loginButton.enabled = NO;
    }] flattenMap:^RACStream *(id value) {
        return [self signalForRegiste];
    }] subscribeNext:^(NSNumber *x) {
        BOOL success = [x boolValue];
        @strongify(self);
        if (success) {
            //走起，注册成功；
            [self rememberKeychian];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeTabBar];
            });
        }else{
            //失败，注册失败；
        }
    }];
    
    
    
    
    [[[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]doNext:^(id x) {
        @strongify(self);
        self.registerButton.enabled = NO;
        self.loginButton.enabled = NO;
    }] flattenMap:^RACStream *(id value) {
        return [self signalForLogin];
    }] subscribeNext:^(NSNumber *x) {
        BOOL success = [x boolValue];
        @strongify(self);
        if (success) {
            //走起，登陆成功；
            [self rememberKeychian];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeTabBar];
            });
        }else{
            //失败，登陆失败；
        }
    }];
    
    
    
    [[self.logOffButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [_signManager loginOutWithCompleteBlock:^(BOOL success) {
            if (success) {
                NSLog(@"登出成功");
            }
        }];
    }];
    
    
    //    NSArray *accountsArray = [SSKeychain accountsForService:NowUserName];
    NSString *accout = [USERD objectForKey:NowUserName];
    
    if (accout) {
        NSString *password = [SSKeychain passwordForService:NowUserName account:[USERD objectForKey:NowUserName]];
        [self.nameTF setText:accout];
        [self.passwordTF setText:password];
        self.nameTF.backgroundColor = [UIColor clearColor];
        self.passwordTF.backgroundColor = [UIColor clearColor];
        self.loginButton.enabled = YES;
    }
    
    
    
    
}

-(void)unRegistChatManagerDelegate{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
-(void)rememberKeychian{
    [USERD setObject:self.nameTF.text forKey:NowUserName];
    BOOL success = [USERD synchronize];
    if (success) {
        [SSKeychain setPassword:self.passwordTF.text forService:NowUserName account:self.nameTF.text];
    }else{//失败重写
        [self rememberKeychian];
    }
    NSLog(@"%d",success);
}
-(void)changeTabBar{
//    [self unRegistChatManagerDelegate];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app changeToTabbarC];
}

-(RACSignal *)signalForRegiste{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [_signManager registerWithName:self.nameTF.text pass:self.passwordTF.text completeBlock:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
}

-(RACSignal *)signalForLogin{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [_signManager loginWithName:self.nameTF.text pass:self.passwordTF.text completeBlock:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


-(BOOL)availableText:(NSString *)text{
    return text.length>=6;
}




- (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error{
    self.loginButton.enabled = NO;
    self.registerButton.enabled = NO;
    self.logOffButton.enabled = NO;
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        [self unRegistChatManagerDelegate];
        [self changeTabBar];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
