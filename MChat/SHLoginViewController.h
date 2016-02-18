//
//  SHLoginViewController.h
//  MChat
//
//  Created by 小帅，，， on 15/11/2.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *logOffButton;

@end
