//
//  AppDelegate.m
//  Qiniu
//
//  Created by 廉鑫博 on 2017/9/6.
//  Copyright © 2017年 zeroskylian. All rights reserved.
//

#import "AppDelegate.h"
#import "PopoverViewController.h"

@interface AppDelegate ()<NSPopoverDelegate>
@property (strong, nonatomic)NSStatusItem  *barItem;


@end
AppDelegate *share = nil;
@implementation AppDelegate

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [NSApplication sharedApplication].delegate;
    });
    return share;
        
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.barItem = [[NSStatusBar     systemStatusBar]statusItemWithLength:NSVariableStatusItemLength];
    NSImage *image = [NSImage imageNamed:@"userCenter_driver"];
    self.barItem.image = image;
    
    self.barItem.action = @selector(buttonClick:);
    _popOver = [[NSPopover alloc]init];
    _popOver.behavior = NSPopoverBehaviorTransient;
    _popOver.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _popOver.contentSize = NSSizeToCGSize(CGSizeMake(200, 270));
    _popOver.contentViewController = [[PopoverViewController alloc]initWithNibName:@"PopoverViewController" bundle:nil];
//    __weak typeof(self) weakSelf = self;
//    [NSEvent addGlobalMonitorForEventsMatchingMask:(NSEventMaskLeftMouseDown) handler:^(NSEvent * _Nonnull event) {
//        if (weakSelf.popOver.isShown) {
//            [weakSelf.popOver close];
//        }
//    }];
}

-(void)buttonClick:(NSButton *)sender
{
    [_popOver showRelativeToRect:sender.bounds ofView:sender preferredEdge:(NSRectEdgeMaxY)];
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
