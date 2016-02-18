//
//  SHAddGroupViewModel.h
//  MChat
//
//  Created by 小帅，，， on 15/11/14.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "RVMViewModel.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>

@interface SHAddGroupViewModel : RVMViewModel

@property (nonatomic, strong) RACCommand *command;

@end
