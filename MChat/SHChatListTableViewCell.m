//
//  SHChatListTableViewCell.m
//  MChat
//
//  Created by 小帅，，， on 15/11/5.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHChatListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NIBadgeView.h"
#import "UIViewAdditions.h"
#import "NSDateAdditions.h"
#import "EaseMob.h"

#define HEAD_IMAGE_HEIGHT 48
#define NAME_FONT_SIZE [UIFont boldSystemFontOfSize:18.f]
#define MESSAGE_FONT_SIZE [UIFont systemFontOfSize:15.f]
#define DATE_FONT_SIZE [UIFont systemFontOfSize:14.f]

@interface SHChatListTableViewCell ()

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NIBadgeView *badgeView;
@property (nonatomic, strong) EMConversation *model;//Entity

@end

@implementation SHChatListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        self.headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HEAD_IMAGE_HEIGHT, HEAD_IMAGE_HEIGHT)];
        self.headView.image = [UIImage imageNamed:HEAD_IMAGE_DEFAULT_NAME];
        self.headView.layer.cornerRadius = 4.0f;
        self.headView.clipsToBounds = YES;
        [self.contentView addSubview:self.headView];
        
        self.badgeView = [[NIBadgeView alloc]initWithFrame:CGRectZero];
        self.badgeView.tintColor = [UIColor redColor];
        self.badgeView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.badgeView];
        
        self.textLabel.font = NAME_FONT_SIZE;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        self.detailTextLabel.font = MESSAGE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.dateLabel.font = DATE_FONT_SIZE;
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.highlightedTextColor = self.dateLabel.textColor;
        [self.contentView addSubview:self.dateLabel];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        
        
        
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.headView.image = [UIImage imageNamed:HEAD_IMAGE_DEFAULT_NAME];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat cellMargin = CELL_PADDING_10;
    CGFloat padding = CELL_PADDING_10;
    
    self.headView.left = cellMargin;
    self.headView.top = cellMargin;
    
    [self.badgeView sizeToFit];
    self.badgeView.centerX = self.headView.right;
    self.badgeView.top = 0.f;
    
    CGFloat textMaxWidth = self.contentView.width-self.headView.width-cellMargin*2-padding;
    CGFloat nameWidth = (textMaxWidth *2)/3;
    CGFloat dateWidth = textMaxWidth/3;
    
    self.textLabel.frame = CGRectMake(self.headView.right+padding, self.headView.top, nameWidth, self.textLabel.font.lineHeight);
    
    self.dateLabel.frame = CGRectMake(self.textLabel.right, self.textLabel.top, dateWidth, self.dateLabel.font.lineHeight);
    
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom+padding, textMaxWidth, self.detailTextLabel.font.lineHeight);
    
    
    
}

-(BOOL)shouldUpdateCellWithObject:(id)object{
    if ([object isKindOfClass:[EMConversation class]]) {
        EMConversation *o = (EMConversation *)object;
        
        self.model = o;
        if (o.conversationType==eConversationTypeChat) {
            self.textLabel.text = o.chatter;
        }else if (o.conversationType==eConversationTypeGroupChat){
            EMGroup *group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:o.chatter error:nil];
            self.textLabel.text = group.groupSubject;
        }
        
        EMTextMessageBody *body = [o.latestMessage.messageBodies lastObject];
        self.detailTextLabel.text = body.text;
        
        if (o.latestMessage) {
            NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:o.latestMessage.timestamp/1000];
            self.dateLabel.text = [timestamp formatRelativeTime];
        }
       
        
        if (o.unreadMessagesCount>0) {
            self.badgeView.hidden = NO;
            self.badgeView.text = [NSString stringWithFormat:@"%ld",o.unreadMessagesCount];
        }
        else{
            self.badgeView.hidden = YES;
        }
        
    }
    return 1;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
