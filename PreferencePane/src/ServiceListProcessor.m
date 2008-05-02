/*
 This file is part of Firewall.
 
 Firewall is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 2 of the License..
 
 Firewall is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Firewall.  If not, see <http://www.gnu.org/licenses/>. 
 */
#import "ServiceListProcessor.h"
#import "Port.h"

@implementation ServiceListProcessor
@synthesize defaultRules;
@synthesize blockUdpRules;
@synthesize builtinServices;
@synthesize ports;
@synthesize authorization;

- (id)initWithBundle:(NSBundle*)bundle {
	NSLog(@"Hello from init");
	NSString *path = [bundle pathForResource:@"defaultServices" ofType:@"plist"];
	id me = [self initWithFile:path];
	[self loadPreferences];
	return me;
}

- (id)initWithFile:(NSString*)path {
	id ret = [super init];
	
	NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile: path];
	defaultRules = [defaults objectForKey: @"defaultRules"];
    [defaultRules retain];
	blockUdpRules = [defaults objectForKey: @"blockUdpRules"];
    [blockUdpRules retain];
    
    NSArray* temp = [defaults objectForKey: @"services"];
	NSMutableArray* bServices = [NSMutableArray arrayWithCapacity: [temp count]];
	for (NSDictionary *service in temp ) {
		FirewallEntry *entry = [[FirewallEntry alloc] initWithDictionary: service withProcessor: ret];
		[bServices addObject: entry];
        [entry release];
	}
	builtinServices = [[NSArray alloc] initWithArray: bServices];
	
    temp = [defaults objectForKey: @"ports"];
	NSMutableArray* p = [NSMutableArray arrayWithCapacity: [temp count]];
	for (NSDictionary *service in temp) {
		PortsEntry *entry = [[PortsEntry alloc] initWithDictionary: service];
		[p addObject: entry];
        [entry release];
	}
	ports = [[NSArray alloc] initWithArray: p];
	
	extraServices = [[NSMutableArray alloc] initWithCapacity:0];
	enabledServices = [[NSMutableDictionary alloc] initWithCapacity: [builtinServices count]];
	loggingEnabled = NO;
	stealthEnabled = NO;
	udpBlock = NO;
	active = NO;
	return ret;
}

- (void)dealloc {
    [defaultRules release];
    [blockUdpRules release];
    [builtinServices release];
    [ports release];
    [extraServices release];
    [enabledServices release];
    [super dealloc];
}


- (void)loadPreferences {
	CFStringRef userName = kCFPreferencesAnyUser;
	CFStringRef appID = CFSTR("com.apple.alf");
	CFStringRef loggingEnabledKey = CFSTR("loggingenabled");
	CFStringRef stealthEnabledKey = CFSTR("stealthenabled");
	CFStringRef activeKey = CFSTR("active");
	CFStringRef udpblockKey = CFSTR("udpblock");
	CFStringRef servicesKey = CFSTR("services");
	CFStringRef builtinservicesKey = CFSTR("builtinservices");
	
	NSLog(@"Loading preferences...");
	CFBooleanRef loggingEnabledRef = CFPreferencesCopyValue(loggingEnabledKey, appID, userName, kCFPreferencesCurrentHost);
	if( loggingEnabledRef ) {
		loggingEnabled = CFBooleanGetValue(loggingEnabledRef);
		CFRelease(loggingEnabledRef);
	}
	
	CFBooleanRef stealthEnabledRef = CFPreferencesCopyValue(stealthEnabledKey, appID, userName, kCFPreferencesCurrentHost);
	if( stealthEnabledRef ) {
		stealthEnabled = CFBooleanGetValue(stealthEnabledRef);
		CFRelease(stealthEnabledRef);
	}
	
	CFBooleanRef activeRef = CFPreferencesCopyValue(activeKey, kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost);
	if( activeRef ) {
		active = CFBooleanGetValue(activeRef);
		CFRelease(activeRef);
	}
	
	CFBooleanRef udpblockRef = CFPreferencesCopyValue(udpblockKey, kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost);
	if( udpblockRef ) {
		udpBlock = CFBooleanGetValue(udpblockRef);
		CFRelease(udpblockRef);
	}
	
	[extraServices removeAllObjects];
	CFDictionaryRef servicesRef = CFPreferencesCopyValue(servicesKey, kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost);
	if( servicesRef ) {
		NSDictionary* services = (NSDictionary*)servicesRef;
		for (NSDictionary *service in services) {
			CustomFirewallEntry *entry = [[CustomFirewallEntry alloc] initWithDictionary: service withProcessor: self];
			[extraServices addObject: entry];
            [entry release];
		}
		CFRelease(servicesRef);
	}

	CFDictionaryRef builtinservicesRef = CFPreferencesCopyValue(builtinservicesKey, kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost);
	if( builtinservicesRef ) {
		NSDictionary* services = (NSDictionary*)builtinservicesRef;
		[enabledServices addEntriesFromDictionary:services];
		CFRelease(builtinservicesRef);
	}
}

- (void)storePreferences {
	CFStringRef userName = kCFPreferencesAnyUser;
	CFStringRef appID = CFSTR("com.apple.alf");
	CFStringRef loggingEnabledKey = CFSTR("loggingenabled");
	CFStringRef stealthEnabledKey = CFSTR("stealthenabled");
	CFStringRef activeKey = CFSTR("active");
	CFStringRef udpblockKey = CFSTR("udpblock");
	CFStringRef servicesKey = CFSTR("services");
	CFStringRef builtinservicesKey = CFSTR("builtinservices");

	NSLog(@"Saving preferences...");
	CFPreferencesSetValue(loggingEnabledKey, [NSNumber numberWithInt:(loggingEnabled ? 1 : 0)], appID, userName, kCFPreferencesCurrentHost);
	CFPreferencesSetValue(stealthEnabledKey, [NSNumber numberWithInt:(stealthEnabled ? 1 : 0)], appID, userName, kCFPreferencesCurrentHost);
	if( CFPreferencesSynchronize(appID, userName, kCFPreferencesCurrentHost) )
		NSLog(@"com.apple.alf save succeded");
	else
		NSLog(@"com.apple.alf save failed");
	
	NSMutableArray* services = [NSMutableArray arrayWithCapacity: [extraServices count]];
	for( CustomFirewallEntry* entry in extraServices ) {
		[services addObject: [entry dictionaryValue]];
	}
	CFPreferencesSetValue(activeKey, (active ? kCFBooleanTrue : kCFBooleanFalse), kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost);
	CFPreferencesSetValue(udpblockKey, (udpBlock ? kCFBooleanTrue : kCFBooleanFalse), kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost);
	CFPreferencesSetValue(builtinservicesKey, enabledServices, kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost);
	CFPreferencesSetValue(servicesKey, services, kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost);
	
	if( CFPreferencesSynchronize(kCFPreferencesCurrentApplication, userName, kCFPreferencesCurrentHost) )
		NSLog(@"App save succeded");
	else
		NSLog(@"App save failed");
}

void executeRule(id item, bool add, bool isUdp) {
    if ([item isKindOfClass: [FirewallEntry class]]) {
        FirewallEntry *entry = item;
        NSString* rulestr = [entry ruleString: isUdp];
        if( rulestr != nil ) {
            NSMutableString *ruleCmd = [[NSMutableString alloc] initWithString: @"sudo ipfw "];
            [ruleCmd appendString: add ? @"add " : @"delete "];
            [ruleCmd appendString: rulestr];
            NSLog(@"%@",ruleCmd);
            // TODO: execute command
            [ruleCmd release];
        }
    } else {
        // assume NSString
        NSMutableString *ruleCmd = [[NSMutableString alloc] initWithString: @"sudo ipfw "];
        [ruleCmd appendString: add ? @"add " : @"delete "];
        [ruleCmd appendString: item];
        NSLog(@"%@",ruleCmd);
        // TODO: execute command
        [ruleCmd release];
    }
}

void executeRules(NSArray *items, bool add, bool isUdp) {
	for (id item in items) {
        executeRule(item, add, isUdp);
	}
}

OSStatus authorizeAction( AuthorizationRef ref, AuthorizationString name) {
    AuthorizationItem myItems[1];
    myItems[0].name = name;
    myItems[0].valueLength = 0;
    myItems[0].value = NULL;
    myItems[0].flags = 0;
    
    AuthorizationRights myRights;
    myRights.count = sizeof (myItems) / sizeof (myItems[0]);
    myRights.items = myItems;

    return AuthorizationCopyRights (ref, &myRights,
            kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults |
            kAuthorizationFlagInteractionAllowed |
            kAuthorizationFlagExtendRights |
            kAuthorizationFlagPartialRights,
            NULL);
}

- (void)executeList {
	char* args[] = {"-q", "delete", "33300", NULL};
	OSStatus status = AuthorizationExecuteWithPrivileges(
			authorization,
			"/sbin/ipfw",
			kAuthorizationFlagDefaults, 
			args, 
			NULL);
	if( status )
		NSLog(@"Execute ipfw failed %x %d", status, status);
	else
		NSLog(@"Execute ipfw success");
} 

NSArray* findEnabledServices(NSArray *allServices) {
	NSMutableArray *enabledServices = [[NSMutableArray alloc] init];
	for (FirewallEntry *entry in allServices) {
        NSLog([entry description]);
		if ([entry enabled]) [enabledServices addObject: entry];
	}
    [enabledServices autorelease];
	return enabledServices;
}

- (void)setStealthEnabled:(BOOL)enabled {
    if( stealthEnabled != enabled ) {
        OSStatus myStatus = authorizeAction(authorization, "dk.deck.firewall.stealth");
        if( myStatus == errAuthorizationSuccess ) {
            executeRule(@"33300 deny icmp from any to me in icmptypes 8", enabled, false);
            stealthEnabled = enabled;
            [self storePreferences];
        } else {
            NSLog(@"Authorization to enable or disable stealth failed %d", myStatus);
        }
    }
}

- (BOOL)stealthEnabled {
	return stealthEnabled;
}

- (void)setLoggingEnabled:(BOOL)enabled {
    if( loggingEnabled != enabled ) {
        OSStatus myStatus = authorizeAction(authorization, "dk.deck.firewall.logging");
        if( myStatus == errAuthorizationSuccess ) {
            loggingEnabled = enabled;
            [self storePreferences];
        } else {
            NSLog(@"Authorization to enable or disable logging failed %d", myStatus);
        }
    }
}

- (BOOL)loggingEnabled {
	return loggingEnabled;
}

- (void)setUdpBlock:(BOOL)enabled {
    if( udpBlock != enabled ) {
        OSStatus myStatus = authorizeAction(authorization, "dk.deck.firewall.block.udp");
        if( myStatus == errAuthorizationSuccess ) {
            if( active ) {
                executeRules(findEnabledServices(builtinServices), enabled, true);
                executeRules(findEnabledServices(extraServices), enabled, true);
                executeRules(blockUdpRules, enabled, true);
            }
            udpBlock = enabled;
            [self storePreferences];
        } else {
            NSLog(@"Authorization to edit service rule failed %d", myStatus);
        }
    }
}

- (BOOL)udpBlock {
	return udpBlock;
}

- (void)setActive:(BOOL)enabled {
    if( enabled != active ) {
        OSStatus myStatus = authorizeAction(authorization, "dk.deck.firewall.restart");
        if( myStatus == errAuthorizationSuccess ) {
            executeRules(findEnabledServices(builtinServices), enabled, false);
            executeRules(findEnabledServices(extraServices), enabled, false);
            executeRules(defaultRules, enabled, false);
            if( udpBlock ) {
                executeRules(findEnabledServices(builtinServices), enabled, true);
                executeRules(findEnabledServices(extraServices), enabled, true);
                executeRules(blockUdpRules, enabled, true);
            }
            active = enabled;
            [self storePreferences];
        } else {
            NSLog(@"Authorization for start/stop failed %d", myStatus);
        }
    }
}

- (BOOL)active {
	return active;
}

- (BOOL)toggleSingleService:(FirewallEntry*)entry asEnabled:(bool)isEnabled {
    OSStatus myStatus = authorizeAction(authorization, "dk.deck.firewall.service.enable");
    if( myStatus == errAuthorizationSuccess ) {
        if( active ) {
            executeRule(entry, isEnabled, false);
            if(udpBlock) executeRule(entry, isEnabled, true);
        }
        return YES;
    } else {
        NSLog(@"Authorization to enable service failed %d", myStatus);
        return NO;
    }
}

- (void)updateSingleService:(CustomFirewallEntry*)entry 
                        tcp:(NSArray*)tcpPorts
                        udp:(NSArray*)udpPorts
                description:(NSString*)description
                selectedPort:(NSInteger)selectedPort
{
    OSStatus myStatus = authorizeAction(authorization, "dk.deck.firewall.rule.edit");
    if( myStatus == errAuthorizationSuccess ) {
        if( active && [entry enabled] ) {
            executeRule(entry, false, false);
            if(udpBlock) executeRule(entry, false, true);
        }
        [entry setTcp: tcpPorts];
        [entry setUdp: udpPorts];
        [entry setName: description];
        [entry setSelectedPort: selectedPort];
        if( active && [entry enabled] ) {
            executeRule(entry, true, false);
            if(udpBlock) executeRule(entry, true, true);
        }
        [self storePreferences];
    } else {
        NSLog(@"Authorization to edit service rule failed %d", myStatus);
    }
}

- (BOOL)serviceEnabled:(FirewallEntry*)entry {
	NSNumber* boolref = [enabledServices objectForKey: [entry idValue]];
	if( boolref == nil )
		return NO;
	return [boolref boolValue];
}

- (void)setServiceEnabled:(FirewallEntry*)entry withValue:(BOOL)value {
    BOOL oldValue = [self serviceEnabled:entry];
    if( oldValue != value ) {
        if([self toggleSingleService: entry asEnabled:value]) {
            [enabledServices setObject: [NSNumber numberWithBool:value] forKey: [entry idValue]];
            [self storePreferences];
        }
    }
}

- (NSInteger)nextPriority {
    NSInteger nextPriority = 3000;
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity: [extraServices count]]; 
    for(CustomFirewallEntry* entry in extraServices)
        [dict setObject:entry forKey:[NSNumber numberWithInteger: [entry priority]]];
    id obj = [dict objectForKey: [NSNumber numberWithInteger:nextPriority]];
    while( obj != nil ) {
        nextPriority += 2;
        obj = [dict objectForKey: [NSNumber numberWithInteger:nextPriority]]; 
    }
    return nextPriority;
}

- (unsigned int)countOfServices {
	return [builtinServices count] + [extraServices count];
}

- (FirewallEntry *)objectInServicesAtIndex:(unsigned int)objectIndex {
	unsigned int count = [builtinServices count];
	if( objectIndex < count ) 
		return [builtinServices objectAtIndex: objectIndex];
	else
		return [extraServices objectAtIndex: objectIndex-count];
}

- (void)addObjectToServices:(CustomFirewallEntry *)entry {
    [self insertObject:entry inServicesAtIndex: [self countOfServices]];
}

- (void)insertObject:(CustomFirewallEntry *)entry inServicesAtIndex:(unsigned int)idx {
    OSStatus myStatus = authorizeAction(authorization, "dk.deck.firewall.rule.new");
    if( myStatus == errAuthorizationSuccess ) {
        unsigned int count = [builtinServices count];
        if( idx < count )
            [builtinServices insertObject: entry atIndex:idx];
        else
            [extraServices insertObject: entry atIndex:idx-count];
        if( active && [entry enabled]) {
            executeRule(entry, true, false);
            if( udpBlock) executeRule(entry, true, true);
        }
        [self storePreferences];
    } else {
        NSLog(@"Authorization to add service rule failed %d", myStatus);
    }
}

- (void)removeObjectFromServicesAtIndex:(unsigned int)idx {
    OSStatus myStatus = authorizeAction(authorization, "dk.deck.firewall.rule.delete");
    if( myStatus == errAuthorizationSuccess ) {
        unsigned int count = [builtinServices count];
        if( idx < count )
            [builtinServices removeObjectAtIndex:idx];
        else {
            if( active) {
                CustomFirewallEntry* entry = [extraServices objectAtIndex:idx-count];
                if( [entry enabled] ) {
                    executeRule(entry, false, false);
                    if( udpBlock) executeRule(entry, false, true);
                }
            }
            [extraServices removeObjectAtIndex:idx-count];
        }
        [self storePreferences];
    } else {
        NSLog(@"Authorization to remove service rule failed %d", myStatus);
    }
}

@end
