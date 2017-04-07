//
//  ECMainTrainViewController.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/24.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECMainTrainViewController.h"
#import "ECMenuView.h"
#import "ECBaseFilterView.h"
#import "ECBaseTableView.h"
#import "ECTrainListCell.h"
@interface ECMainTrainViewController ()
@property(nonatomic,strong)ECBaseFilterView *filterView;
@property(nonatomic,strong)ECBaseTableView *tableView;
@end

@implementation ECMainTrainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"培训";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.filterView];
    [self initNavView];
    
    
}

-(ECBaseFilterView *)filterView
{
    if (!_filterView) {
        
        NSMutableArray *items = [@[[ECCustomerFilterItem itemWithTitle:@"初级课程" value:nil icon:[UIImage imageNamed:@"icon_course_lv1"] checkedImage:[UIImage imageNamed:@"icon_tmp"]],
                                   [ECCustomerFilterItem itemWithTitle:@"中级课程" value:nil icon:[UIImage imageNamed:@"icon_course_lv2"] checkedImage:nil],
                                   [ECCustomerFilterItem itemWithTitle:@"年度大课" value:nil icon:[UIImage imageNamed:@"icon_course_lv3"] checkedImage:nil]] mutableCopy];
        NSMutableArray *rightItems = [@[[ECCustomerFilterItem itemWithTitle:@"json" value:nil icon:nil checkedImage:nil],
                                   [ECCustomerFilterItem itemWithTitle:@"web" value:nil icon:nil checkedImage:nil]]mutableCopy];
        ECCustomerFilterModel *model1 = [[ECCustomerFilterModel alloc] init];
        model1.title = @"全部课程";
        model1.dataSource = items;
        model1.rightDataSource = rightItems;
        model1.selectedItem = [items firstObject];
        ECCustomerFilterModel *model2 = [[ECCustomerFilterModel alloc] init];
        model2.title = @"地区";
        model2.textAligment = NSTextAlignmentCenter;
        model2.dataSource = items;
        ECCustomerFilterModel *model3 = [[ECCustomerFilterModel alloc] init];
        model3.textAligment = NSTextAlignmentRight;
        model3.title = @"价格";
        model3.dataSource = items;
        
        _filterView = [[ECBaseFilterView alloc] initWithFrame:CGRectMake(0, kNavHeight , kECScreenWidth, 44.0f) data:[@[model1,model2,model3]mutableCopy]];
        
    }
    return _filterView;
}

-(ECBaseTableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[ECBaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight + 44.0f, kECScreenWidth, kECScreenHeight -kNavHeight -44.0f - kTabbarHeight) style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kECBackgroundColor;
       ECTableConfigModel *tableConfig  = _tableView.tableConfig;
        tableConfig.cellHeight = 80 + kECScreenWidth /2.f;
        tableConfig.sectionHeight = 10.f;
        tableConfig.dataSource = [@[@[@""],@[@""],@[@""]] mutableCopy];
       tableConfig.cellConfig = ^UITableViewCell *(UITableView *tableView, id cellModel, NSIndexPath *indexPath) {
           
           static NSString *cellid = @"cellID";
           ECTrainListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
           if (!cell) {
               cell = [kLoadNibName(@"ECTrainListCell") lastObject];
           }
            return cell;
        };
        
        tableConfig.cellClick = ^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *indexPath) {
            
        };
//        tableConfig.sectionFooterConfig = ^UIView *(UITableView *tableView, id cellModel) {
//            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, 10.f)];
//            footerView.backgroundColor = kECBackgroundColor;
//            return footerView;
//        };
        ECBlockSet
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           ECBlockGet(this)
            [this.tableView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.f];
            
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ECBlockGet(this)
            [this.tableView.mj_footer performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.f];
        }];
        
        
    }
    return _tableView;
}

-(void)initNavView
{
    UIButton *rightBtn = [UIButton imageTitleButtonWithFrame:CGRectMake(0, 0, 40, 40) image:[UIImage imageNamed:@"icon_associate_no"] showImageSize:CGSizeMake(14, 18) title:nil titleFont:nil imagePosition:UIImageOrientationRight buttonType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(navClick:) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.tintColor = kECBlackColor3;
    [self customNavRightViews:@[rightBtn]];
}

#pragma mark - Action Methods
-(void)navClick:(UIButton *)sender
{

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
