#include "NCFYRootListController.h"
#import "NCFYApp.h"
#import "NCFYAppCell.h"

#include <spawn.h>

@interface LSApplicationProxy: NSObject

@property (nonatomic,readonly) NSString * bundleIdentifier;
-(id)localizedName;
@property (nonatomic,readonly) NSString * primaryIconName;
@property (setter=_setInfoDictionary:,nonatomic,copy) id _infoDictionary;
@property (nonatomic,readonly) NSString * applicationType;
@property (nonatomic,readonly) NSArray * appTags;

@end

@interface LSApplicationWorkspace : NSObject

+(id)defaultWorkspace;
-(id)allInstalledApplications;
-(id)allApplications;

@end

@interface UIImage ()

+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3;

@end

@interface NCFYRootListController () <UITableViewDelegate, UITableViewDataSource, NCFYAppCellDelegate>

@property (nonatomic, strong) NSMutableArray<NCFYApp *> *apps;
@property (nonatomic, strong) NSMutableSet<NSString *> *enabledApps;

@end

@implementation NCFYRootListController

-(id)init {
    if (self = [super init]) {
        self.navigationItem.title = @"NoClipboardForYou";
    }

    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    self.enabledApps = [NSMutableSet set];

    NSURL *plistURL = [NSURL fileURLWithPath:@"/Library/MobileSubstrate/DynamicLibraries/NoClipboardForYou.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:plistURL];

    id filter = dict[@"Filter"];
    if (filter && [filter isKindOfClass:[NSDictionary class]]) {
        NSDictionary *filterDict = (NSDictionary *)filter;

        id bundles = filterDict[@"Bundles"];

        if (bundles && [bundles isKindOfClass:[NSArray class]]) {
            self.enabledApps = [NSMutableSet setWithArray:(NSArray *)bundles];
        }
    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[NCFYAppCell class] forCellReuseIdentifier:@"AppCell"];

    self.navigationItem.title = @"NoClipboardForYou";

    self.apps = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray<LSApplicationProxy *> *apps = [[%c(LSApplicationWorkspace) defaultWorkspace] allInstalledApplications];

        NSMutableDictionary<NSString *, NSString *> *theAppsDict = [NSMutableDictionary dictionary];

        for (LSApplicationProxy *app in apps) {
            NSArray<NSString *> *tags = [app appTags];
            if (!tags || ![tags containsObject:@"hidden"]) {
                theAppsDict[app.bundleIdentifier] = [app localizedName];
            }
        }

        NSMutableArray<NCFYApp *> *appEntries = [NSMutableArray array];

        for (NSString *key in theAppsDict) {
            NSString *name;

            if (theAppsDict[key].length > 0) {
                name = theAppsDict[key];
            } else if ([key isEqual:@"com.apple.springboard"]) {
                name = @"SpringBoard";
            } else {
                name = key;
            }

            NCFYApp *app = [[NCFYApp alloc] initWithBundleID:key name:name];

            [appEntries addObject:app];
        }

        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSMutableArray *tempApps = [NSMutableArray arrayWithArray:[appEntries sortedArrayUsingDescriptors:@[sort]]];

        NSMutableArray *indexPaths = [NSMutableArray array];

        for (int i = 0; i < tempApps.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.apps = tempApps;

            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    });
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.tableView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NCFYAppCell *cell = (NCFYAppCell *)[tableView dequeueReusableCellWithIdentifier:@"AppCell" forIndexPath:indexPath];

    NCFYApp *app = [self.apps objectAtIndex:indexPath.row];

    UIImage *icon = [UIImage _applicationIconImageForBundleIdentifier:app.bundleID format:0 scale:[UIScreen mainScreen].scale];

    cell.imageView.image = icon;
    cell.textLabel.text = app.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ((UISwitch *)cell.accessoryView).on = [self.enabledApps containsObject:app.bundleID];

    cell.delegate = self;

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Clipboard blacklist";
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"Apps must be restarted for the changes to take effect.";
    }
    
    return nil;
}

-(void)switchValueDidChange:(BOOL)on cell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath) {
        pid_t pid;
        int status;

        const char *args[] = {"chfilter", on ? "-a" : "-r", [[self.apps objectAtIndex:indexPath.row].bundleID UTF8String], NULL};
        posix_spawn(&pid, "/usr/bin/chfilter", NULL, NULL, (char* const*)args, NULL);
    
        waitpid(pid, &status, WEXITED);

        if (on) {
            [self.enabledApps addObject:[self.apps objectAtIndex:indexPath.row].bundleID];
        } else {
            [self.enabledApps removeObject:[self.apps objectAtIndex:indexPath.row].bundleID];
        }
    }
}

@end
