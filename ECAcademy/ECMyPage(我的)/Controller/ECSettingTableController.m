//
//  ECSettingTableController.m
//  ECAcademy
//
//  Created by yellowei on 17/4/6.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECSettingTableController.h"

@interface ECSettingTableController ()<UITableViewDelegate>

@end

@implementation ECSettingTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f * kECScreenHeight / 568.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10.f;
    }
    return 0.01f;
}



@end
