#import "AppDelegator.h"

@implementation AppDelegator

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self
                            selector:@selector(willCloseOrTerminate:)
                            name:NSWindowWillCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                            selector:@selector(willCloseOrTerminate:)
                            name:NSApplicationWillTerminateNotification object:nil];


    NSString* pathToPrefPaneBundle = [[NSBundle mainBundle]
            pathForResource: @"Firewall" ofType: @"prefPane"
            inDirectory: @"PreferencePanes"];
    
    NSBundle *prefBundle = [NSBundle bundleWithPath: pathToPrefPaneBundle];
                Class prefPaneClass = [prefBundle principalClass];
    prefPaneObject = [[prefPaneClass alloc]
            initWithBundle:prefBundle];

    NSView *prefView;
    if ( [prefPaneObject loadMainView] ) {
        [prefPaneObject willSelect];
        prefView = [prefPaneObject mainView];
        
        [mainWindow setContentView: prefView];
        /* Add view to window */
        [prefPaneObject didSelect];
    } else {
        /* loadMainView failed -- handle error */
        NSLog(@"Auch! We failed");
    }
}

- (BOOL)windowShouldClose:(id)window {
    NSPreferencePaneUnselectReply reply = [prefPaneObject shouldUnselect];

    if( reply == NSUnselectLater ) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                            selector:@selector(doCloseUnselect:)
                            name:NSPreferencePaneDoUnselectNotification object:nil];    
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                            selector:@selector(cancelUnselect:)
//                            name:NSPreferencePaneCancelUnselectNotification object:nil];    
    } else if(reply == NSUnselectNow) {
        [prefPaneObject willUnselect];
        [mainWindow setContentView:nil];
    }
    return reply == NSUnselectNow ? YES : NO;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    BOOL sel = [prefPaneObject isSelected];
    if( !sel ) return NSTerminateNow;
    
    app = sender;
    NSPreferencePaneUnselectReply reply = [prefPaneObject shouldUnselect];

    if( reply == NSUnselectLater ) {
        [app retain];
        [[NSNotificationCenter defaultCenter] addObserver:self
                            selector:@selector(doTerminateUnselect:)
                            name:NSPreferencePaneDoUnselectNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                            selector:@selector(cancelTerminateUnselect:)
                            name:NSPreferencePaneCancelUnselectNotification object:nil];    
        return NSTerminateLater;
    } else if(reply == NSUnselectNow) {
        [prefPaneObject willUnselect];
        return NSTerminateNow;
    } else
        return NSTerminateCancel;
}

- (void)doTerminateUnselect:(NSNotification *)notification {
    [prefPaneObject willUnselect];
    [app replyToApplicationShouldTerminate: YES];
    [app release];
    app = nil;
}

- (void)cancelTerminateUnselect:(NSNotification *)notification {
    [app replyToApplicationShouldTerminate: NO];
    [app release];
    app = nil;
}


- (void)doCloseUnselect:(NSNotification *)notification {
    [prefPaneObject willUnselect];
    [mainWindow setContentView:nil];
    [mainWindow close];
}

- (void)willCloseOrTerminate:(NSNotification *)notification {
    BOOL sel = [prefPaneObject isSelected];
    if( !sel ) [prefPaneObject didUnselect];
}

@end
