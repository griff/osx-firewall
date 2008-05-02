/*!
 @header CustomFirewallEntry.h
 @copyright Anders Borch, Brian Olsen
 @abstract Class holding information about a single custom service which the firewall should allow of deny and that the user can edit and delete.
 @discussion
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
#import <Cocoa/Cocoa.h>
@class CustomFirewallEntry;
#import "FirewallEntry.h"

@interface CustomFirewallEntry : FirewallEntry {
	BOOL enabled;
    NSInteger selectedPort;
}
@property(readwrite) NSInteger selectedPort;

- (id)initWithProcessor:(ServiceListProcessor*)aProcessor;
- (id)initWithDictionary:(NSDictionary*)dict withProcessor:(ServiceListProcessor*)aProcessor;

- (NSDictionary*)dictionaryValue;

- (BOOL)custom;

- (void)setName:(NSString*)aName;
- (void)setTcp:(NSArray*)value;
- (void)setUdp:(NSArray*)value;

@end
