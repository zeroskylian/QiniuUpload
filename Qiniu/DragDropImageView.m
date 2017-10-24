

#import "DragDropImageView.h"

@implementation DragDropImageView

NSString *kPrivateDragUTI = @"com.yourcompany.cocoadraganddrop";

- (id)initWithCoder:(NSCoder *)coder
{
    self=[super initWithCoder:coder];
    if (self) {
        self.autoresizingMask = NSViewNotSizable;
        self.autoresizesSubviews = false;
        [self registerForDraggedTypes:[NSImage imagePasteboardTypes]];
    }
    return self;
}

#pragma mark - Destination Operations

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ( [NSImage canInitWithPasteboard:[sender draggingPasteboard]] &&
        [sender draggingSourceOperationMask] &
        NSDragOperationCopy ) {
        highlight=YES;
        [self setNeedsDisplay: YES];
        [sender enumerateDraggingItemsWithOptions:NSDraggingItemEnumerationConcurrent forView:self classes:[NSArray arrayWithObject:[NSPasteboardItem class]] searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop) {
            if ( ![[[draggingItem item] types] containsObject:kPrivateDragUTI] ) {
                *stop = YES;
            } else {
                [draggingItem setDraggingFrame:self.bounds contents:[[[draggingItem imageComponents] objectAtIndex:0] contents]];
            }
        }];
        
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    highlight=NO;
    [self setNeedsDisplay: YES];
}

-(void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    if ( highlight ) {
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: rect];
    }
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    highlight=NO;
    [self setNeedsDisplay: YES];
    return [NSImage canInitWithPasteboard: [sender draggingPasteboard]];
} 

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    if ( [sender draggingSource] != self ) {
        NSURL* fileURL;
        if([NSImage canInitWithPasteboard: [sender draggingPasteboard]]) {
            NSImage *newImage = [[NSImage alloc] initWithPasteboard: [sender draggingPasteboard]];
            [self setImage:newImage];
        }
        fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
        [[self window] setTitle: fileURL!=NULL ? [fileURL absoluteString] : @"(no name)"];
        NSLog(@"%@",fileURL!=NULL ? [fileURL absoluteString] : @"(no name)" );
        if ([self.delegate respondsToSelector:@selector(finishDropImage:)]) {
            [self.delegate finishDropImage:self.image];
        }
    }
    
    return YES;
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame;
{
    NSRect ContentRect=self.window.frame;
    ContentRect.size=[[self image] size];
    return [NSWindow frameRectForContentRect:ContentRect styleMask: [window styleMask]];
}

#pragma mark - Source Operations

- (void)mouseDown:(NSEvent*)event
{
    NSPasteboardItem *pbItem = [NSPasteboardItem new];
    [pbItem setDataProvider:self forTypes:[NSArray arrayWithObjects:NSPasteboardTypeTIFF, NSPasteboardTypePDF, kPrivateDragUTI, nil]];
    NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem];
    NSRect draggingRect = self.bounds;
    [dragItem setDraggingFrame:draggingRect contents:[self image]];
    NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:[NSArray arrayWithObject:dragItem] event:event source:self];
    draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
    draggingSession.draggingFormation = NSDraggingFormationNone;
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    switch (context) {
        case NSDraggingContextOutsideApplication:
            return NSDragOperationCopy;
        case NSDraggingContextWithinApplication:
        default:
            return NSDragOperationCopy;
            break;
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event 
{
    return YES;
}

- (void)pasteboard:(NSPasteboard *)sender item:(NSPasteboardItem *)item provideDataForType:(NSString *)type
{
    if ( [type compare: NSPasteboardTypeTIFF] == NSOrderedSame ) {
        [sender setData:[[self image] TIFFRepresentation] forType:NSPasteboardTypeTIFF];
        
    } else if ( [type compare: NSPasteboardTypePDF] == NSOrderedSame ) {
        [sender setData:[self dataWithPDFInsideRect:[self bounds]] forType:NSPasteboardTypePDF];
    }
}
@end
