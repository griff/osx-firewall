//
//  TestPreferencePref.m
//  TestPreference
//
//  Created by Brian Olsen on 17/12/07.
//  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
//

#import "FirewallPref.h"


@implementation FirewallPref
@synthesize authorized;

+ (void)initialize { 
    [FirewallPref setKeys: 
        [NSArray arrayWithObjects:@"authorized", @"active", nil] 
        triggerChangeNotificationsForDependentKey:@"enableservices"];
} 

// -------------------------------------------------------------------------------
//	initWithBundle:bundle
//
//	The preference pane is being initialized, remember our bundle ID for later.
// -------------------------------------------------------------------------------
-(id)initWithBundle:(NSBundle*)bundle
{
	if ((self = [super initWithBundle:bundle]) != nil)
	{
		processor = [[ServiceListProcessor alloc] initWithBundle:bundle];
	}
	
	return self;
}

- (void)dealloc {
    [processor release];
    [super dealloc];
}

- (BOOL)active {
    return [processor active];
}

- (void)setActive:(BOOL)value {
    [processor setActive:value];
}

- (BOOL) enableservices {
    return [processor active] && [self authorized];
}

- (ServiceListProcessor*) processor {
    return processor;
}

/*- (NSView *)loadMainView {
    NSMutableArray* topObjects = [NSMutableArray arrayWithCapacity: 0];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: topObjects, NSNibTopLevelObjects, self, NSNibOwner, nil];
    [[self bundle] loadNibFile: [self mainNibName] externalNameTable:dict withZone:nil];
    NSLog(@"Writting top objects");
    for(id elem in topObjects )
        NSLog([elem description]);
    NSLog(@"Done writting top objects");
    [self assignMainView];
    [self mainViewDidLoad];
    return [self mainView];
}*/

// -------------------------------------------------------------------------------
//	mainViewDidLoad
//
//  mainViewDidLoad is invoked by the default implementation of loadMainView
//  after the main nib file has been loaded and the main view of the preference
//  pane has been set.  The default implementation does nothing.  Override
//  this method to perform any setup that must be performed after the main
//  nib file has been loaded and the main view has been set.
// -------------------------------------------------------------------------------
- (void)mainViewDidLoad
{
}

@end
