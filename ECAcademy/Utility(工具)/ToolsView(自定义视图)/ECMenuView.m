//
//  ECMenuView.m
//  ECDoctor
//
//  Created by linsen on 15/9/24.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECMenuView.h"
#import "UIView+Extension.h"
#define kMenuBackGroundColor   [UIColor whiteColor]
#define kMenuTitleColor [UIColor blackColor]
#define kImageTinColor   [UIColor blackColor]
#define kSeporateLineColor     kECBlackColor5
#define kBottomViewWidth 120
#define kBottomViewWidthNoIcon 100
@interface ECMenuView()
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,strong)UITableView *memuView;
@end

@implementation ECMenuView

static ECMenuView *instance;
//单例
+(ECMenuView *)defaultMenuView
{

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
//    ECMenuView *instance;
    instance = [[ECMenuView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, kECScreenHeight)];
  });
  return instance;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.selectedIndex = @"99999999";//初始化为一个不可能的值,默认不选中
        [self _initSubViews];
    }
    return self;
}

#pragma mark - OverWrite Methods
-(void)setMemuItems:(NSMutableArray *)memuItems
{
    _memuItems = memuItems;
    CGFloat height = [memuItems count]*44 + 7;
    CGFloat width = 0.f;
    if ([self isShowIcon])
    {
        width = kBottomViewWidth;
    }
    else
    {
        width = kBottomViewWidthNoIcon;
    }
    
    if (height < 50)
    {
        height = 50;
    }
    if (height > kECScreenHeight - 120)
    {
        height = kECScreenHeight - 120;
        self.memuView.scrollEnabled = YES;
    }
    else
    {
         self.memuView.scrollEnabled = NO;
    }
    self.bottomView.height = height;
    self.memuView.height = height - 7;
    self.bottomView.width = width;
    self.bottomView.left = kECScreenWidth - width - 5;
    self.memuView.width = width;
    
    [self.memuView reloadData];
}

#pragma mark - Private Methods
- (BOOL)isShowIcon
{
    BOOL result = NO;
    for (ECMenuItem * item in _memuItems)
    {
        if (item.icon)
        {
            result = YES;
            break;
        }
    }
    return result;
}

-(void)_initSubViews
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheShade)];
    _shadeView = [[UIView alloc] initWithFrame:self.bounds];
    //_shadeView.alpha = 1.0;
    _shadeView.backgroundColor = [UIColor clearColor];
    [self addSubview:_shadeView];
    [_shadeView addGestureRecognizer:tap];
    
    UITableView *itemsTalbeView = nil;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(kECScreenWidth - kBottomViewWidth - 5, 60, kBottomViewWidth , 50)];
    itemsTalbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 2, kBottomViewWidth, CGRectGetHeight(_bottomView.frame) - 2) style:UITableViewStylePlain];
    
    [self addSubview:_bottomView];
//    UIImageView *triangleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(125, 2, 18, 5)];
//    triangleImageView.image = [UIImage imageNamed:@"bg_submenu_tri"];
//    [_bottomView addSubview:triangleImageView];
  
    itemsTalbeView.backgroundColor = kMenuBackGroundColor;
    self.memuView = itemsTalbeView;
    itemsTalbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    itemsTalbeView.delegate = self;
    itemsTalbeView.dataSource = self;
    itemsTalbeView.layer.cornerRadius = 4;
    [_bottomView addSubview:itemsTalbeView];
//阴影
  _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
  _bottomView.layer.shadowOpacity = 0.8;
  _bottomView.layer.shadowRadius = 5.0;
  _bottomView.layer.shadowOffset = CGSizeMake(3, 3);
  _bottomView.clipsToBounds = NO;
  
}

#pragma mark - Public Methods
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

-(void)clickTheShade
{
    if (_clickShade) {
        _clickShade();
    }
    [self hide];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.memuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier1 = @"icon_cell";
    static NSString *identifier2 = @"cell";
    
    UITableViewCell * cell = nil;
   
    if ([self isShowIcon])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.backgroundColor = [UIColor clearColor];
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
            iconView.tag = 1001;
            [cell.contentView addSubview:iconView];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, CGRectGetWidth(tableView.frame) - 40, 43)];
            valueLabel.font = [UIFont systemFontOfSize:15.0];
            valueLabel.textColor = kMenuTitleColor;
            valueLabel.textAlignment = NSTextAlignmentLeft;
            valueLabel.tag = 1002;
            valueLabel.backgroundColor = kECClearColor;
            [cell.contentView addSubview:valueLabel];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 43, kBottomViewWidth - 20, 0.5)];
            view.backgroundColor = kSeporateLineColor;
            view.tag = 1003;
            [cell.contentView addSubview:view];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 43)];
            valueLabel.font = [UIFont systemFontOfSize:15.0];
            valueLabel.textColor = kMenuTitleColor;
            valueLabel.textAlignment = NSTextAlignmentCenter;
            valueLabel.tag = 1002;
            valueLabel.backgroundColor = kECClearColor;
            [cell.contentView addSubview:valueLabel];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 43, kBottomViewWidthNoIcon - 20, 0.5)];
            view.backgroundColor = kSeporateLineColor;
            view.tag = 1003;
            [cell.contentView addSubview:view];
        }
    }
    //选中哪个
    if ([self.selectedIndex integerValue] == indexPath.row)
    {
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:1002];
        valueLabel.textColor = kECGreenColor2;
    }
    else
    {
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:1002];
        valueLabel.textColor = kMenuTitleColor;
    }
    
    if (indexPath.row < [self.memuItems count])
    {
        ECMenuItem *item = self.memuItems[indexPath.row];
        UIImageView *iconView = (UIImageView *)[cell.contentView viewWithTag:1001];
        iconView.tintColor = kImageTinColor;
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:1002];
        UIView *lineView = (UIView *)[cell.contentView viewWithTag:1003];
        iconView.image = item.icon;
        valueLabel.text = item.title;
        lineView.backgroundColor = kSeporateLineColor;
        lineView.hidden = (indexPath.row == [self.memuItems count] -1);
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        cell.selected = NO;
    }
    if (self.clickItem)
    {
        if ([self.memuItems count] > indexPath.row)
        {
            self.clickItem(self.memuItems[indexPath.row]);
        }
    }
}

@end

@implementation ECMenuItem

+ (ECMenuItem *)menuItemWithTitle:(NSString *)title icon:(UIImage *)icon
{
    ECMenuItem *item = [[ECMenuItem alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}
@end

