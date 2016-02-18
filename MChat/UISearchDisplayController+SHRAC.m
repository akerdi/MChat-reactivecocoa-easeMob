//
//  UISearchDisplayController+SHRAC.m
//  MChat
//
//  Created by 小帅，，， on 15/11/4.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "UISearchDisplayController+SHRAC.h"
#import <objc/runtime.h>

@implementation UISearchDisplayController (SHRAC)

-(RACSignal *)rac_isActive{
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal) {
        return signal;
    }
    RACSignal *activeSignal = [[self rac_signalForSelector:@selector(searchDisplayControllerDidBeginSearch:) fromProtocol:@protocol(UISearchDisplayDelegate)] mapReplace:@(1)];
    RACSignal *inActive = [[self rac_signalForSelector:@selector(searchDisplayControllerDidEndSearch:) fromProtocol:@protocol(UISearchDisplayDelegate)]mapReplace:@(0)];
    signal = [RACSignal merge:@[activeSignal,inActive]];
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
    
}

@end
