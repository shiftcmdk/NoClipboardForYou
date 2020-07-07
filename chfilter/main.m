#include <dlfcn.h>
#include <unistd.h>

#define FLAG_PLATFORMIZE (1 << 1)

void patch_setuidandplatformize() {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle) return;
    
    // Reset errors
    dlerror();
    
    typedef void (*fix_setuid_prt_t)(pid_t pid);
    fix_setuid_prt_t setuidptr = (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");
    
    typedef void (*fix_entitle_prt_t)(pid_t pid, uint32_t what);
    fix_entitle_prt_t entitleptr = (fix_entitle_prt_t)dlsym(handle, "jb_oneshot_entitle_now");
    
    setuidptr(getpid());
    
    setuid(0);
    
    const char *dlsym_error = dlerror();
    
    if (dlsym_error) {
        return;
    }
    
    entitleptr(getpid(), FLAG_PLATFORMIZE);
}

int main(int argc, char **argv, char **envp) {
    patch_setuidandplatformize();

    if (setuid(0) != 0 || setgid(0) != 0) {
        return 1;
    }

    if (argc < 3) {
        return 1;
    }

    NSString *mode = [NSString stringWithUTF8String:argv[1]];
    NSString *bundleID = [NSString stringWithUTF8String:argv[2]];

    NSURL *plistURL = [NSURL fileURLWithPath:@"/Library/MobileSubstrate/DynamicLibraries/NoClipboardForYou.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:plistURL];

    if (!dict) {
        dict = [NSDictionary dictionary];
    }

    NSMutableArray *bundlesArray;

    id filter = dict[@"Filter"];

    if (filter && [filter isKindOfClass:[NSDictionary class]]) {
        NSDictionary *filterDict = (NSDictionary *)filter;

        NSLog(@"filter: %@", filterDict);

        id bundles = filterDict[@"Bundles"];

        if (bundles && [bundles isKindOfClass:[NSArray class]]) {
            bundlesArray = [NSMutableArray arrayWithArray:(NSArray *)bundles];
            NSLog(@"bundles: %@", bundlesArray);
        }
    }

    NSDictionary *newFilterDict;

    if ([mode isEqual:@"-r"]) {
        NSLog(@"removing object: %@", bundleID);
        [bundlesArray removeObject:bundleID];
    } else if ([mode isEqual:@"-a"]) {
        NSLog(@"adding object: %@", bundleID);
        [bundlesArray addObject:bundleID];
    } else {
        return 1;
    }

    newFilterDict = @{
        @"Filter": @{
            @"Bundles": [[NSSet setWithArray:bundlesArray] allObjects]
        }
    };

    NSLog(@"newFilterDict: %@", newFilterDict);

    NSError *error;

    NSLog(@"written: %i", [newFilterDict writeToURL:plistURL error:&error]);
    NSLog(@"err: %@", error);

    if (error) {
        return 1;
    }

    return 0;
}
