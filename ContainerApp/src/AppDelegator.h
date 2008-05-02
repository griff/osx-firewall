#import <Cocoa/Cocoa.h>
#import <PreferencePanes/PreferencePanes.h>
#import <PreferencePanes/NSPreferencePane.h>

@interface AppDelegator : NSObjectController {
    IBOutlet NSWindow *mainWindow;
    NSPreferencePane* prefPaneObject;
    NSApplication* app;
}

- (void)awakeFromNib;

@end
