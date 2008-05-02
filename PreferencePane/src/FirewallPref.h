//
//  TestPreferencePref.h
//  TestPreference
//
//  Created by Brian Olsen on 17/12/07.
//  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import "FirewallController.h"
#import "RuleController.h"
#import "ServiceListProcessor.h"
@class FirewallController;
@class RuleController;

@interface FirewallPref : NSPreferencePane 
{
    ServiceListProcessor* processor;
    BOOL authorized;
}
@property(readwrite) BOOL authorized;

- (BOOL)active;

- (void)setActive:(BOOL)value;

- (BOOL)enableservices;

- (ServiceListProcessor*) processor;

- (void) mainViewDidLoad;

@end
