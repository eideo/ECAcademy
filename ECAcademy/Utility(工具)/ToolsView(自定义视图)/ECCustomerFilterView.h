//
//  ECCustomerFilterView.h
//  ECDoctor
//
//  Created by linsen on 15/11/6.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECBaseFilterView.h"
@class ECCustomerFilterItem, ECCustomerFilterModel;
@interface ECCustomerFilterView : UIView
/**
 *	@brief	数据（@[ECCustomerFilterModel]）
 *
 *	Created by mac on 2015-11-06 17:55
 */
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)void(^selectedItem)(ECCustomerFilterItem *item, ECCustomerFilterModel *model, ECCustomerFilterView *filter);
- (instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *)data;
- (void)reloadData;

@end



