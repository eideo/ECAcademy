//
//  ECMainCourseViewController.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/24.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECMainCourseViewController.h"
#import "ECBaseTableView.h"
#import "ECMainCourseCell.h"
#import "ECCourseListViewController.h"
#import "ECBaseWebViewController.h"
#import "ECPlatformShareManager.h"
@interface ECMainCourseViewController ()

@property(nonatomic,strong)ECBaseTableView *m_tableView;

@end

@implementation ECMainCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _m_tableView = [[ECBaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kECScreenWidth, kECScreenHeight - kNavHeight - kTabbarHeight) style:UITableViewStylePlain];
    //@"one",@"two",@"three"
    NSMutableArray *arr = [@[@"wating",@"toast",@"push",@"web",@"share",@"Login"] mutableCopy];
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
            {
                ECCourseListViewController *vc = [[ECCourseListViewController alloc] init];
                vc.title  = @"课程";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                ECBaseWebViewController *vc = [[ECBaseWebViewController alloc] init];
                vc.m_strUrl = @"http://www.baidu.com";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                [[ECPlatformShareManager sharedECPlatformShareManager] showShareView];
            }
                break;
            default:
                break;
        }
        
        
    };
    
    [self.view addSubview:_m_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showHud:(UIButton *)sender {
    
    [self showSimpleInfo:nil];
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
