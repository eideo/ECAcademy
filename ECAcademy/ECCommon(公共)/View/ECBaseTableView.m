//
//  ECBaseTableView.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/28.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECBaseTableView.h"
#import "CYLTableViewPlaceHolder.h"
#import "AFNetworking.h"
#import "UIView+CommonMethods.h"
#import "NSString+ECExtensions.h"


@interface ECBaseTableView ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate>
{
    UITableViewCell *cell;
}
@end

@implementation ECBaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    if (!self.tableConfig) {
        self.tableConfig = [[ECTableConfigModel alloc] init];
        ECBlockSet
        self.tableConfig.refreshTable = ^(){
        ECBlockGet(stongSelf)
            [stongSelf cyl_reloadData];
        };
    }
    self.dataSource = self;
    self.delegate = self;
    self.tableFooterView = [[UIView alloc] init];
}

-(void)ec_reload
{
    [self cyl_reloadData];
}

//动态展示 placeholderView
- (UIView *)makePlaceHolderView
{
    //无网络
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
      return [UIView getTableViewHeaderNoNetworkView];
    }else{
        if (self.tableConfig.dataSource.count == 0) {
            return [UIView getTableViewHeaderNoDataView];
        }
    }
    return nil;
}


#pragma mark - Data source deledate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableConfig.isMutiSection) {
        NSArray *arr = self.tableConfig.dataSource[section];
        if ([arr isKindOfClass:[NSArray class]]) {
            return arr.count;
        }
    }else{
        return self.tableConfig.dataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.tableConfig.dataSource[indexPath.row];
    if (self.tableConfig.cellConfig) {
        cell = self.tableConfig.cellConfig(tableView,model,indexPath);
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringEmptyTransform:self.tableConfig.cellid]];
    }
    
    return cell;
}

#pragma mark - delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableConfig.isMutiSection) {
        return self.tableConfig.dataSource.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = nil;
    if (self.tableConfig.isMutiSection) {
        model = self.tableConfig.dataSource[indexPath.section][indexPath.row];
    }else{
        model = self.tableConfig.dataSource[indexPath.row];
    }
    if (self.tableConfig.cellHeightBlock) {
        return self.tableConfig.cellHeightBlock(tableView,model);
    }else if (self.tableConfig.cellHeight > 0){
        return self.tableConfig.cellHeight;
    }
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tableConfig.sectionHeaderHeight) {
        return self.tableConfig.sectionHeaderHeight(tableView,section);
    }
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (self.tableConfig.sectionFooterHeight) {
        return self.tableConfig.sectionFooterHeight(tableView,section);
    }else if (self.tableConfig.sectionHeight > 0){
        return self.tableConfig.sectionHeight;
    }
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tableConfig.sectionHeaderConfig) {
       return  self.tableConfig.sectionHeaderConfig(tableView,nil);
    };
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.tableConfig.sectionFooterConfig) {
       return self.tableConfig.sectionFooterConfig(tableView,nil);
    };
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self getRowModelWithIndexPath:indexPath];
    UITableViewCell *rowCell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.tableConfig.cellClick) {
        self.tableConfig.cellClick(tableView,model,rowCell,indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Tools
-(id)getRowModelWithIndexPath:(NSIndexPath *)indexPath
{
    id model = nil;
    if (self.tableConfig.dataSource > 0) {
        if (self.tableConfig.isMutiSection) {
            model = self.tableConfig.dataSource[indexPath.section][indexPath.row];
        }else{
            model = self.tableConfig.dataSource[indexPath.row];
        }
    }
    return model;
}

@end

@implementation ECTableConfigModel
-(instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray arrayWithCapacity:1];
        _cellHeight = 44.0f;
        _cellid = @"";
    }
    return self;
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    if (_dataSource.count > 0) {
        id object = [_dataSource firstObject];
        if ([object isKindOfClass:[NSArray class]]) {
            _isMutiSection = YES;
        }else{
            _isMutiSection = NO;
        }
    }
    
    if (self.refreshTable) {
        self.refreshTable();
    }
}



@end
