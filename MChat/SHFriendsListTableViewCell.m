//
//  SHFriendsListTableViewCell.m
//  MChat
//
//  Created by 小帅，，， on 15/11/5.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHFriendsListTableViewCell.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "EaseMob.h"
#import "UIViewAdditions.h"
#import "SHFriendsListCellModel.h"

#define NAME_FONT_SIZE [UIFont boldSystemFontOfSize:18.f]

#define HEAD_IAMGE_HEIGHT 35


@interface SHFriendsListTableViewCell ()
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) EMBuddy *model;

@property (nonatomic, strong) SHFriendsListCellModel *friendsListModel;

@end

@implementation SHFriendsListTableViewCell




-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT, HEAD_IAMGE_HEIGHT)];
        self.headView.image = [UIImage imageNamed:HEAD_IMAGE_DEFAULT_NAME];
        [self.contentView addSubview:self.headView];
        self.headView.layer.cornerRadius = 4.0f;
        self.headView.layer.masksToBounds = YES;
        
        self.textLabel.font = NAME_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        self.friendsListModel = [[SHFriendsListCellModel alloc]init];
        
        RAC(self,textLabel.text) = RACObserve(self.friendsListModel, title);
        
        
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}


-(void)prepareForReuse{
    [super prepareForReuse];
    self.headView.image = [UIImage imageNamed:HEAD_IMAGE_DEFAULT_NAME];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat contentViewMargin = CELL_PADDING_10;
    CGFloat padding = CELL_PADDING_8;
    
    self.contentView.frame = CGRectMake(contentViewMargin, contentViewMargin, self.width-contentViewMargin*2, self.height-contentViewMargin*2);
    self.headView.left = 0.f;
    self.headView.top = 0.f;
    
    CGFloat textMaxWidth = self.contentView.width-self.headView.width-padding;
    
    self.textLabel.frame = CGRectMake(self.headView.right+padding, self.headView.top, textMaxWidth, self.textLabel.font.lineHeight);
    self.textLabel.centerY = self.headView.centerY;
}

- (BOOL)shouldUpdateCellWithObject:(id)object{
    if ([object isKindOfClass:[EMBuddy class]]) {
        EMBuddy *buddy = object;
        self.friendsListModel.title = buddy.username;
    }
    else if ([object isKindOfClass:[NSString class]]){
        self.friendsListModel.title = object;
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
