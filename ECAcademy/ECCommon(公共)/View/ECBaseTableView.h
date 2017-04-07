//
//  ECBaseTableView.h
//  ECAcademy
//
//  Created by Sophist on 2017/3/28.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECBaseObject.h"
@class ECTableConfigModel;
@interface ECBaseTableView : UITableView

//初始化赋值
@property(nonatomic,strong)ECTableConfigModel *tableConfig;

@end

typedef CGFloat(^CellHeightBlock)(UITableView *tableView,id cellModel);
typedef CGFloat(^TableSectionHeaderHeightBlock)(UITableView *tableView,NSInteger section);
typedef CGFloat(^TableSectionFooterHeightBlock)(UITableView *tableView,NSInteger section);

typedef UIView *(^ConfigureTableSectionHeaderBlock)(UITableView *tableView,id cellModel);
typedef UIView *(^ConfigureTableSectionFooterBlock)(UITableView *tableView,id cellModel);

typedef UITableViewCell *(^ConfigCellBlock)(UITableView *tableView,id cellModel,NSIndexPath *indexPath);
typedef void(^ClickTableCellBlock)(UITableView *tableView,id cellModel,UITableViewCell *cell,NSIndexPath *indexPath);

typedef void(^RefreshTable)();

@interface ECTableConfigModel : ECBaseObject

@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,readonly)BOOL isMutiSection;
// ---可选
@property (nonatomic,copy)NSString *cellid;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,assign)CGFloat sectionHeight;
@property (nonatomic,copy)CellHeightBlock cellHeightBlock;
@property (nonatomic,copy)RefreshTable refreshTable;
//header 和 footer 的 高度 和 View
@property (nonatomic,copy)TableSectionHeaderHeightBlock sectionHeaderHeight;
@property (nonatomic,copy)TableSectionFooterHeightBlock sectionFooterHeight;
@property (nonatomic,copy)ConfigureTableSectionHeaderBlock sectionHeaderConfig;
@property (nonatomic,copy)ConfigureTableSectionFooterBlock sectionFooterConfig;
//配置cell
@property(nonatomic,copy)ConfigCellBlock cellConfig;
//cell点击
@property (nonatomic,copy)ClickTableCellBlock cellClick;


@end
