/*!
 @header ServiceListProcessorTest.h
 @copyright Anders Borch
 @abstract Unit test of the ServiceListProcessor class.
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
#import <SenTestingKit/SenTestingKit.h>
#import "ServiceListProcessor.h"

@interface ServiceListProcessorTest : SenTestCase {

}

/*!
 @function testLoadDefaults:
 @abstract Initialize a ServiceListProcessor with default settings, and 
 ensure that it has all settings correctly loaded.
 */
- (void)testLoadDefaults;

@end
