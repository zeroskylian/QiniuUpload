//
//  PopoverViewController.m
//  Qiniu
//
//  Created by 廉鑫博 on 2017/9/6.
//  Copyright © 2017年 zeroskylian. All rights reserved.
//

#import "PopoverViewController.h"
#import "DragDropImageView.h"
#import <AFNetworking/AFNetworking.h>
#import <Qiniu/QiniuSDK.h>
#import "AppDelegate.h"

@interface PopoverViewController ()<DragDropImageViewDelegate>
@property (copy)NSString *defaultImageName ;
@property (strong, nonatomic)NSImage *image;
@property (weak) IBOutlet DragDropImageView *imageView;
@property (strong, nonatomic)QNUploadManager *manager;
@property (strong, nonatomic)NSDateFormatter *formatter;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTextField *errorLabel;

@end


@implementation PopoverViewController
-(QNUploadManager *)manager
{
    if (!_manager) {
        _manager = [[QNUploadManager alloc] init];
    }
    return _manager;
    
}
-(NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _formatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _defaultImageName =  @"caibeijing1";
    _imageView.delegate = self;
    self.image = [NSImage imageNamed:_defaultImageName];
}
-(void)finishDropImage:(NSImage *)image
{
    self.image = image;
}
- (IBAction)getMarkDown:(id)sender {
    if ([self.image.name isEqualToString: _defaultImageName]) {
        return;
    }
    NSString *token = @"PXqOVyw83ispxuiqS8URvLGNN1cnE5VAveZplkBs:jxURl07upJL7ZukVGubgNW5uEi4=:eyJzY29wZSI6Im1hcnJ5bG92ZSIsImRlYWRsaW5lIjoxNTA2NjcwODE3fQ==";
    NSData *imageData = [self.image TIFFRepresentation];
    NSString *string;
    if (self.textField.stringValue.length != 0) {
        string = self.textField.stringValue;
    }else
    {
        NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
        string = [NSString stringWithFormat:@"%.0f",timeInterval * 1000];
    }
    [self.manager putData:imageData key:string token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
     {
         if (info.error) {
             NSLog(@"%@", info.error.userInfo[@"error"]);
             _errorLabel.stringValue = info.error.userInfo[@"error"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 _errorLabel.stringValue = @"";
             });
         }else
         {
             NSPasteboard  *paste = [NSPasteboard generalPasteboard];
             NSString *pasteString = [NSString stringWithFormat:@"![](http://oo6vy0uhq.bkt.clouddn.com/%@)",resp[@"key"]];
             NSLog(@"%@", pasteString);
             [paste declareTypes:[NSArray arrayWithObject:NSStringPboardType]
                           owner:self];
             [paste setString:pasteString forType:NSStringPboardType];
             [AppDelegate shareInstance].popOver.contentSize = NSSizeToCGSize(CGSizeMake(200, 270));
             
             _errorLabel.stringValue = @"success";
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 _errorLabel.stringValue = @"";
             });
         }
     } option:nil];
}


@end
