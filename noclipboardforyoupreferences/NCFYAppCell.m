#import "NCFYAppCell.h"

@implementation NCFYAppCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

        self.accessoryView = switchView;
    }

    return self;
}

-(void)switchChanged:(UISwitch *)sender {
    if (self.delegate) {
        [self.delegate switchValueDidChange:sender.isOn cell:self];
    }
}

@end