//
//  main.m
//  Qiniu
//
//  Created by 廉鑫博 on 2017/9/6.
//  Copyright © 2017年 zeroskylian. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    id delegate = [[AppDelegate alloc]init];
    [NSApplication sharedApplication].delegate = delegate;
    return NSApplicationMain(argc, argv);
}


