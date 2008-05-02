#import "ServiceListProcessorTest.h"

@implementation ServiceListProcessorTest

- (void)testLoadDefaults {
	NSMutableString *path = [[NSMutableString alloc] initWithString: [[NSBundle mainBundle] bundlePath]];
	[path appendString: @"/Contents/Resources/defaultServices.plist"];
	ServiceListProcessor *processor = [[ServiceListProcessor alloc] initWithFile: path];
	
	NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile: path];
	
	NSMutableArray *services = [[NSMutableArray alloc] init];
	for (NSDictionary *service in [defaults objectForKey: @"services"]) {
		FirewallEntry *entry = [[FirewallEntry alloc] initWithDictionary: service];
		[entry setCustom: false];
		[services addObject: entry];
	}
	
	for (int c = 0 ; c < [services count] ; c++) {
		FirewallEntry *defaultsFileEntry = [services objectAtIndex: c];
		FirewallEntry *processorEntry = [[processor services] objectAtIndex: c];
		STAssertEqualObjects(defaultsFileEntry, processorEntry, @"Service %@ not loaded from defaults", defaultsFileEntry);
	}
}

@end
