//
//  SHTools.m
//  MChat
//
//  Created by 小帅，，， on 15/11/4.
//  Copyright (c) 2015年 Hong. All rights reserved.
//

#import "SHTools.h"
#import "PinYin4Objc.h"

@implementation SHTools

+(NSString *)changeToPinyin:(NSString *)hanzi{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:hanzi withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
    return outputPinyin;
}

@end
