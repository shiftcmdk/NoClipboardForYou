@interface _UIConcretePasteboard : UIPasteboard
@end

%hook _UIConcretePasteboard

-(NSInteger)changeCount {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return 0;
    }
    return %orig;
}

-(NSArray<NSString *> *)pasteboardTypes {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

-(BOOL)containsPasteboardTypes:(NSArray<NSString *> *)pasteboardTypes {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return NO;
    }
    return %orig;
}

-(NSData *)dataForPasteboardType:(NSString *)pasteboardType {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return nil;
    }
    return %orig;
}

-(id)valueForPasteboardType:(NSString *)pasteboardType {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return nil;
    }
    return %orig;
}

-(NSInteger)numberOfItems {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return 0;
    }
    return %orig;
}

-(NSArray<NSArray<NSString *> *> *)pasteboardTypesForItemSet:(NSIndexSet *)itemSet {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

-(NSIndexSet *)itemSetWithPasteboardTypes:(NSArray<NSString *> *)pasteboardTypes {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSIndexSet indexSet];
    }
    return %orig;
}

- (BOOL)containsPasteboardTypes:(NSArray<NSString *> *)pasteboardTypes inItemSet:(NSIndexSet *)itemSet {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return NO;
    }
    return %orig;
}

-(NSArray<NSDictionary<NSString *,id> *> *)items {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

- (NSArray<NSData *> *)dataForPasteboardType:(NSString *)pasteboardType inItemSet:(NSIndexSet *)itemSet {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

- (NSArray *)valuesForPasteboardType:(NSString *)pasteboardType inItemSet:(NSIndexSet *)itemSet {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

-(NSString *)string {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return @"";
    }
    return %orig;
}

-(NSArray<NSString *> *)strings {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

-(UIImage *)image {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [[UIImage alloc] init];
    }
    return %orig;
}

-(NSArray<UIImage *> *)images {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

-(NSURL *)URL {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [[NSURL alloc] init];
    }
    return %orig;
}

-(NSArray<NSURL *> *)URLs {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

-(UIColor *)color {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [UIColor blackColor];
    }
    return %orig;
}

-(NSArray<UIColor *> *)colors {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return [NSArray array];
    }
    return %orig;
}

-(BOOL)hasColors {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return NO;
    }
    return %orig;
}

-(BOOL)hasImages {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return NO;
    }
    return %orig;
}

-(BOOL)hasStrings {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return NO;
    }
    return %orig;
}

-(BOOL)hasURLs {
    if ([self.name isEqual: UIPasteboardNameGeneral]) {
        return NO;
    }
    return %orig;
}

%end

%hook NSNotificationCenter

- (id<NSObject>)addObserverForName:(NSNotificationName)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block {
    BOOL isPbNotification = [name isEqual:UIPasteboardChangedNotification] || [name isEqual:UIPasteboardRemovedNotification];

    if (isPbNotification) {
        void (^newBlock)(NSNotification *) = ^void(NSNotification *notification) {};

        return %orig(name, obj, queue, newBlock);
    } else {
        return %orig;
    }
}

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    BOOL isPbNotification = [aName isEqual:UIPasteboardChangedNotification] || [aName isEqual:UIPasteboardRemovedNotification];

    if (!isPbNotification) {
        %orig;
    }
}

%end
