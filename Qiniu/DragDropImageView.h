

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


@protocol DragDropImageViewDelegate <NSObject>
@optional
-(void)finishDropImage:(NSImage *)image;
@end

@interface DragDropImageView : NSImageView <NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider>
{
    //highlight the drop zone
    BOOL highlight;
}
@property (weak, nonatomic)id<DragDropImageViewDelegate> delegate;
- (id)initWithCoder:(NSCoder *)coder;



@end
