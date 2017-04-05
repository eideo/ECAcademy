//
//  ECCourseListViewController.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/29.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECCourseListViewController.h"
#import "ECBaseTableView.h"
#import "ECMainCourseCell.h"

@interface ECCourseListViewController ()
@property(nonatomic,strong)ECBaseTableView *m_tableView;
@end

@implementation ECCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.m_tableView];
}

-(ECBaseTableView *)m_tableView
{
    if (!_m_tableView) {
        _m_tableView = [[ECBaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        //@"one",@"two",@"three"
        NSMutableArray *arr = [@[@"wating",@"toast"] mutableCopy];
        ECTableConfigModel *tableConfig = _m_tableView.tableConfig;
        ECBlockSet
        tableConfig.cellConfig = ^UITableViewCell *(UITableView *tableView,id cellModel,NSIndexPath *indexPath){
            
            ECMainCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (!cell) {
                cell = [kLoadNibName(@"ECMainCourseCell") firstObject];
            }
            
            cell.titleLab.text = arr[indexPath.row];
            return cell;
        };
        tableConfig.dataSource = arr;
        tableConfig.cellClick = ^(UITableView *tableView,id cellModel,UITableViewCell *cell,NSIndexPath *indexPath){
            ECBlockGet(this)
            NSLog(@"%@",indexPath);
            switch (indexPath.row) {
                case 0:
                    [this showHub];
                    [this performSelector:@selector(dissmissHub) withObject:nil afterDelay:.25f];
                    break;
                case 1:
                    [this showSimpleInfo:@"哈哈哈😀"];
                    [this performSelector:@selector(dissmissHub) withObject:nil afterDelay:.25f];
                    break;
                case 2:
                    
                    break;
                default:
                    break;
            }
        };

    }
    return _m_tableView;
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
