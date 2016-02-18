//
//  SHUnreadBuddyRequestCell.m
//  MChat
//
//  Created by 小帅，，， on 15/11/7.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHUnreadBuddyRequestCell.h"
#import "SHHttpManager.h"
#import "SHUIHelper.h"
#import "UIViewAdditions.h"
#import "SHFriendsListViewModel.h"



@implementation SHUnreadBuddyRequestCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        for (int i=0; i<2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 40, 36);
            button.tag = 2000+i;
            [button setTitle:@[@"接受",@"拒绝"][i]  forState:UIControlStateNormal];
            button.backgroundColor = [UIColor blueColor];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            
        }
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.textLabel.text = @"";
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.text = self.chatterModel.userName;
    CGFloat padding = CELL_PADDING_10;
    for (int i=0; i<2; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:2000+i];
        button.frame = CGRectMake(self.width-(2-i)*40-(2-i)*padding, CELL_PADDING_4, 40, 36);
        [button bringSubviewToFront:self.contentView];
    }
    
}

-(void)buttonClick:(UIButton *)sender{
    NSDictionary *diction = [[NSDictionary alloc]initWithObjects:@[self.chatterModel.userName,@"reason"] forKeys:@[@"buddy",@"reason"]];
    BOOL isSuccess;
    if (sender.tag==2000) {
         isSuccess =[[SHHttpManager sharedManager] acceptBuddyRequestWithDiction:diction];
    }else{
        isSuccess = [[SHHttpManager sharedManager]rejectBuddyRequestWithDiction:diction];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [SHUIHelper showTextMessage:isSuccess?@"发送成功":@"发送失败" inView:window];
    SHFriendsListViewModel *fiendsViewModel = [SHFriendsListViewModel FriendsListViewModel];
    isSuccess?[fiendsViewModel getFriendsList]:nil;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
