//
//  SHAddGroupViewController.m
//  MChat
//
//  Created by 小帅，，， on 15/11/14.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHAddGroupViewController.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "NSStringAdditions.h"
#import "SHAddGroupTableViewC.h"

@interface SHAddGroupViewController ()

@end

@implementation SHAddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"群组·群信息";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 36, 36);
    [button setTitle:@"创建" forState:UIControlStateNormal];
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self);
        SHAddGroupTableViewC *addGroupTableVC = [SHAddGroupTableViewC new];
        addGroupTableVC.infoDic = @{
                                    @"subject":self.subjectTextField.text,
                                    @"description":self.descriptionTextView.text
                                    };
        [self.navigationController pushViewController:addGroupTableVC animated:YES];
    }];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    
    RAC(self,descriptionTextView.backgroundColor) = [self.descriptionTextView.rac_textSignal map:^id(id value) {
        if ([value length]>1) {
            return [UIColor clearColor];
        }else{
            return [UIColor yellowColor];
        }
    }];
    
}


-(RACSignal *)signalForEnableButton_Command{
    return [RACSignal combineLatest:@[self.subjectTextField.rac_textSignal,self.descriptionTextView.rac_textSignal] reduce:^id(NSString *subjectStr,NSString *descriptionStr){
        return @(![subjectStr isWhitespaceAndNewlines]&&![descriptionStr isWhitespaceAndNewlines]);
    }];
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
