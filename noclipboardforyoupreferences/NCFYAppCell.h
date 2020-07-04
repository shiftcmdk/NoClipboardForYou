@protocol NCFYAppCellDelegate <NSObject>

-(void)switchValueDidChange:(BOOL)on cell:(UITableViewCell *)cell;

@end

@interface NCFYAppCell: UITableViewCell

@property (nonatomic, weak) id<NCFYAppCellDelegate> delegate;

@end