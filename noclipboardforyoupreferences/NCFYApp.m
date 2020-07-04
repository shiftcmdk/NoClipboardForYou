#import "NCFYApp.h"

@implementation NCFYApp

-(id)initWithBundleID:(NSString *)bundleID name:(NSString *)name {
    if (self = [super init]) {
        self.bundleID = bundleID;
        self.name = name;
    }

    return self;
}

@end