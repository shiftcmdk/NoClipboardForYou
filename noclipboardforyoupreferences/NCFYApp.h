@interface NCFYApp: NSObject

-(id)initWithBundleID:(NSString *)bundleID name:(NSString *)name;

@property (nonatomic, copy) NSString *bundleID;
@property (nonatomic, copy) NSString *name;

@end