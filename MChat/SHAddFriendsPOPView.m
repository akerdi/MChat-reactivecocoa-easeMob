//
//  SHAddFriendsPOPView.m
//  MChat
//
//  Created by 小帅，，， on 15/11/13.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHAddFriendsPOPView.h"

@interface SHAddFriendsPOPView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataSourceArray;
@end

@implementation SHAddFriendsPOPView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect rect = frame;
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        tableView.dataSource =self;
        tableView.delegate = self;
        [self addSubview:tableView];
        self.dataSourceArray = @[@"发起群聊",@"添加朋友",@"扫一扫"];
        
        self.backgroundColor = APP_MAIN_COLOR;
        self.alpha = 0;
        [UIView beginAnimations:@"newAnimation" context:nil];
        [UIView setAnimationDuration:0.5];
        self.alpha = 1;
        [UIView commitAnimations];
        
    }
    return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = APP_MAIN_COLOR;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.block(indexPath);
    self.block = nil;
    [UIView beginAnimations:@"newAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    self.alpha = 0;
    [UIView commitAnimations];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
