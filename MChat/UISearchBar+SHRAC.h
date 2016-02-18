//
//  UISearchBar+SHRAC.h
//  MChat
//
//  Created by 小帅，，， on 15/11/4.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>

@interface UISearchBar (SHRAC)

-(RACSignal *)rac_textDidChange;

@end
