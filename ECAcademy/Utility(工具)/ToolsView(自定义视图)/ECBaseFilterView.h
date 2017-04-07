//
//  ECBaseFilterView.h
//  ECAcademy
//
//  Created by Sophist on 2017/4/1.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECCustomerFilterItem, ECCustomerFilterModel;
@interface ECBaseFilterView : UIView
/**
 *	@brief	数据（@[ECCustomerFilterModel]）
 *
 *	Created by mac on 2015-11-06 17:55
 */
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)void(^selectedItem)(ECCustomerFilterItem *item, ECCustomerFilterModel *model, ECBaseFilterView *filter);
- (instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *)data;
- (void)reloadData;

@end

@interface ECCustomerFilterModel : NSObject
/**
 *	@brief	描述
 *
 *	Created by mac on 2015-11-06 17:55
 */
@property (nonatomic, copy)NSString *title;

/**
 *	@brief	value值
 *
 *	Created by mac on 2015-11-06 17:55
 */
@property (nonatomic, copy)NSString *value;

/**
 选中数据
 */
@property (nonatomic, strong)ECCustomerFilterItem *selectedItem;

/**
 *	@brief	显示数据（@[ECCustomerFilterItem]）
 *
 *	Created by mac on 2015-11-06 17:55
 */
@property (nonatomic, strong)NSMutableArray *dataSource;

/**
 右侧table数据源 （@[ECCustomerFilterItem]）
 */
@property (nonatomic, strong)NSMutableArray *rightDataSource;

@property (nonatomic, assign)NSTextAlignment textAligment;

@end

@interface ECCustomerFilterItem : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *value;
@property (nonatomic, strong)UIImage *icon;
@property (nonatomic, strong)UIImage *checkedImage;


+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value icon:(UIImage *)icon checkedImage:(UIImage *)checkedImage;

@end

@interface ECCustomerFilterTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *m_title;
@property (nonatomic, strong)UIView *m_selectLineView;
@property (nonatomic, strong)UIImageView *m_icon;
@property (nonatomic, strong)UIImageView *m_checkIcon;
@property (nonatomic, strong)UIView *m_lineView;
@end

@interface ECFilterButton : UIButton

@property(nonatomic,assign)BOOL isBottom;
@property (nonatomic, copy)NSString *strTitle;
@property (nonatomic, strong)UILabel *m_titleLab;
@property (nonatomic, strong)UIImageView *m_imageView;
@end
