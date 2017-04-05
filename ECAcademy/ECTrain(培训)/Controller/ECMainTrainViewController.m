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

@interface ECMainTrainViewController ()
@property(nonatomic,strong)ECBaseFilterView *filterView;
@property(nonatomic,strong)ECBaseTableView *tableView;
@end

@implementation ECMainTrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"培训";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.filterView];
    
}


-(ECBaseFilterView *)filterView
{
    if (!_filterView) {
        NSMutableArray *items = [@[[ECCustomerFilterItem itemWithTitle:@"初级课程" value:nil icon:nil checkedImage:nil],
                                   [ECCustomerFilterItem itemWithTitle:@"中级课程" value:nil icon:nil checkedImage:nil],
                                   [ECCustomerFilterItem itemWithTitle:@"年度大课" value:nil icon:nil checkedImage:nil]] mutableCopy];
        NSMutableArray *rightItems = [@[[ECCustomerFilterItem itemWithTitle:@"json" value:nil icon:nil checkedImage:nil],
                                   [ECCustomerFilterItem itemWithTitle:@"web" value:nil icon:nil checkedImage:nil]]mutableCopy];
        ECCustomerFilterModel *model1 = [[ECCustomerFilterModel alloc] init];
        model1.title = @"全部课程";
        model1.dataSource = items;
        model1.rightDataSource = rightItems;
        model1.selectedItem = [items firstObject];
        ECCustomerFilterModel *model2 = [[ECCustomerFilterModel alloc] init];
        model2.title = @"地区";
        model2.dataSource = items;
        ECCustomerFilterModel *model3 = [[ECCustomerFilterModel alloc] init];
        model3.title = @"价格";
        model3.dataSource = items;
        
        _filterView = [[ECBaseFilterView alloc] initWithFrame:CGRectMake(0, kNavHeight , kECScreenWidth, 44.0f) data:[@[model1,model2,model3]mutableCopy]];
        
    }
    return _filterView;
}

-(ECBaseTableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[ECBaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight + 44.0f, kECScreenWidth, kECScreenHeight -kNavHeight -44.0f)];
       ECTableConfigModel *tableConfig  = _tableView.tableConfig;
        tableConfig.dataSource = [@[@"",@"",@""] mutableCopy];
       tableConfig.cellConfig = ^UITableViewCell *(UITableView *tableView, id cellModel, NSIndexPath *indexPath) {
           
           static NSString *cellid = @"cellid";
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
           if (!cell) {
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
           }
            return cell;
        };
        
        tableConfig.cellClick = ^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *indexPath) {
            
        } ;
        
        
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
