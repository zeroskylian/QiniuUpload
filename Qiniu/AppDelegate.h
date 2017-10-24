//
//  AppDelegate.h
//  Qiniu
//
//  Created by 廉鑫博 on 2017/9/6.
//  Copyright © 2017年 zeroskylian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong, nonatomic)NSPopover *popOver;
+(instancetype)shareInstance;
@end

