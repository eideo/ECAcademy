//
//  ECCustomerFilterView.m
//  ECDoctor
//
//  Created by linsen on 15/11/6.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBaseFilterView.h"
#import "NSString+CalculateSize.h"
#define kRightTableWidth (kECScreenWidth*2/3.f)
#define kSelCellBgColor [UIColor whiteColor]
#define kNorCellBgColor kECBackgroundColor
@interface ECBaseFilterView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UIScrollView *pageView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableView *rightTableView;
@property (nonatomic, strong)NSMutableArray *modelViewArray;
@property (nonatomic, strong)ECCustomerFilterModel *selectedModel;
@property (nonatomic, strong)UIImageView *singleView;
@property (nonatomic, strong)UIView *backGroudView;
@property(nonatomic,assign)BOOL isBottom;

@end
#define selfViewTagBase     1000
@implementation ECBaseFilterView

- (instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *)data
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kECClearColor;
        _isBottom = NO;
        if (frame.origin.y == kECScreenHeight - 44.0f) {
            _isBottom = YES;
        }
        self.backGroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, kECScreenHeight)];
        self.backGroudView.backgroundColor = ECColorWithRGB(0, 0, 0, 0.6);
        self.backGroudView.userInteractionEnabled = YES;
        self.backGroudView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadeView:)];
        [self.backGroudView addGestureRecognizer:tap];
        if (_isBottom) {
            self.backGroudView.height = kECScreenHeight - 44.0f;
            [[UIApplication sharedApplication].keyWindow addSubview:self.backGroudView];
        }else{
            [self addSubview:self.backGroudView];
        }
        
        
        self.dataSource = data;
        self.modelViewArray = [NSMutableArray arrayWithCapacity:0];
        self.pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 44)];
        self.pageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pageView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kECScreenWidth, 0.5)];
        if (_isBottom) {
            lineView.top = 0.0f;
        }
        lineView.backgroundColor = kECBlackColor5;
        [self.pageView addSubview:lineView];
        
        CGFloat viewWidth = CGRectGetWidth(self.frame);
        for (NSInteger i = 0; i < [self.dataSource count]; i++)
        {
            ECCustomerFilterModel *model = self.dataSource[i];
            if ([model isKindOfClass:[ECCustomerFilterModel class]])
            {
                ECFilterButton *btn = [[ECFilterButton alloc] initWithFrame:CGRectMake(i * viewWidth/self.dataSource.count, 0, viewWidth/self.dataSource.count, 44)];
                btn.isBottom = _isBottom;
                btn.backgroundColor = kECClearColor;
                btn.selected = NO;
            
                btn.strTitle = model.title;
                if (model.dataSource.count > 0) {
                    btn.m_imageView.hidden = NO;
                    btn.userInteractionEnabled = YES;
                }
                else
                {
                    btn.m_imageView.hidden = YES;
                    btn.userInteractionEnabled = NO;
                }
                
                [btn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
                
                btn.tag = selfViewTagBase+i;
                
                if (i != self.dataSource.count - 1)
                {
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/self.dataSource.count - 0.5, 10, 0.5, 22)];
                    line.backgroundColor = kECBlackColor5;
                    [btn addSubview:line];
                }
                [self.modelViewArray addObject:btn];
                [self.pageView addSubview:btn];
            }
        }
        
        UIImageView *singleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32, 12.1, 12.1)];
        singleView.image = [UIImage imageNamed:@"icon_customer_filter_sth"];
        self.singleView = singleView;
        self.singleView.hidden = YES;
        [self.pageView addSubview:singleView];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kECScreenWidth, 0)];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableView = tableView;
        
        UITableView *tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kECScreenWidth, 0)];
        
        tableView2.delegate = self;
        tableView2.dataSource = self;
        
        tableView2.backgroundColor = [UIColor whiteColor];
        tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rightTableView = tableView2;
        [self addSubview:tableView2];
        
        if (_isBottom) {
            self.tableView.bottom = kECScreenHeight - 44.0f;
            [[UIApplication sharedApplication].keyWindow addSubview:tableView];
        }else{
            [self addSubview:tableView];
        }
        
    }
    return self;
}

//刷新标题
- (void)reloadData
{
    for (NSInteger i = 0; i < [self.dataSource count]; i++)
    {
        ECCustomerFilterModel *model = self.dataSource[i];
        if ([model isKindOfClass:[ECCustomerFilterModel class]])
        {
            if (i < self.modelViewArray.count)
            {
                ECFilterButton *btn = self.modelViewArray[i];
                btn.backgroundColor = kECClearColor;
                if (model.dataSource.count > 0)
                {
                    btn.m_imageView.hidden = NO;
                    btn.userInteractionEnabled = YES;
                }
                else
                {
                    btn.m_imageView.hidden = YES;
                    btn.userInteractionEnabled = NO;
                }
                btn.strTitle = model.title;
            }
        }
        
        
    }
    self.tableView.height = 0;
    self.backGroudView.alpha = 0;
    self.height = 44;
}


-(void)tapShadeView:(UITapGestureRecognizer *)tap
{
    NSInteger index = [self.dataSource indexOfObject:self.selectedModel];
    if (index < self.modelViewArray.count)
    {
        UIButton *btn = [self.modelViewArray objectAtIndex:index];
        [self sectionClick:btn];
    }
}

- (void)sectionClick:(UIButton *)sender
{
    for (NSInteger i = 0; i < [self.modelViewArray count]; i++)
    {
        UIButton *btn = self.modelViewArray[i];
        if (btn == sender)
        {
            UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
            CGRect rect = [self convertRect:self.bounds toView:window];
            btn.selected = !btn.selected;
            CGFloat height = 0;
            if (btn.selected)
            {
                if (self.dataSource.count > i)
                {
                    self.selectedModel = self.dataSource[i];
                }
                self.singleView.left = i*kECScreenWidth/self.dataSource.count + (kECScreenWidth/self.dataSource.count - 12)/2;
//                [self.tableView reloadData];
//                [self.rightTableView reloadData];
                [self refreshTables];
                self.singleView.hidden = YES;
                self.tableView.hidden = NO;
                height = self.selectedModel.dataSource.count * 44;
                if (_isBottom)
                {
                    CGFloat height2 = CGRectGetMinY(rect);
                    if(height > height2 - 20)
                    {
                        height = height2 - 20 ;
                    }
                }
                else
                {
                    CGFloat height2 = kECScreenHeight - CGRectGetMinY(rect) - 44;
                    if (height > height2)
                    {
                        height = height2;
                        self.tableView.scrollEnabled = YES;
                    }
                    else
                    {
                        self.tableView.scrollEnabled = NO;
                    }
                    if (height == 0)
                    {
                        height = 0.1;
                    }
                }
            }
            else
            {
                self.singleView.hidden = YES;
                height = 0;
            }
            
        
            if (self.selectedModel.dataSource.count > 0) {
                if (self.selectedModel.rightDataSource.count > 0) {
                    self.tableView.width = self.width - kRightTableWidth;
                    self.rightTableView.left = self.tableView.right;
                    self.rightTableView.width = kRightTableWidth;
                    self.rightTableView.hidden = NO;
                }else{
                    self.tableView.width = kECScreenWidth;
                    self.rightTableView.hidden = YES;
                }
                [UIView animateWithDuration:0.2 animations:^{
                    if (_isBottom) {
                        self.tableView.frame = CGRectMake(0, CGRectGetMinY(rect) - height, kECScreenWidth, height);
                    }else{
                        self.tableView.height = height;
                    }
                    if (height > 0)
                    {
                        self.backGroudView.alpha = 1;
                
                    }
                    else
                    {
                        self.backGroudView.alpha = 0;
                
                    }
                    if (self.selectedModel.rightDataSource.count > 0) {
                        self.rightTableView.height = height;
                    }
                } completion:^(BOOL finished) {
                    if (_isBottom) {
                        return ;
                    }
                    if (height > 0)
                    {
                        self.height = kECScreenHeight - CGRectGetMinY(self.frame);
                    }
                    else
                    {
                        self.height = 44;
                    }
                    
                }];
            }
            
        }
        else
        {
            btn.selected = NO;
        }
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableView == tableView) {
        if (self.selectedModel && [self.selectedModel isKindOfClass:[ECCustomerFilterModel class]])
        {
            return self.selectedModel.dataSource.count;
        }
    }else{
        if (self.selectedModel && [self.selectedModel isKindOfClass:[ECCustomerFilterModel class]])
        {
            return self.selectedModel.rightDataSource.count;
        }
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    BOOL rightTable = (tableView == self.rightTableView);
    NSMutableArray *dataArr = rightTable?self.selectedModel.rightDataSource:self.selectedModel.dataSource;
    ECCustomerFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[ECCustomerFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    UIView *selView = [[UIView alloc] initWithFrame:cell.bounds];
    selView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = selView;
    cell.backgroundColor = !rightTable&&self.selectedModel.rightDataSource.count > 0?kNorCellBgColor:[UIColor whiteColor];
    if (self.selectedModel && [self.selectedModel isKindOfClass:[ECCustomerFilterModel class]])
    {
        if (dataArr.count > indexPath.row)
        {
            ECCustomerFilterItem *item = dataArr[indexPath.row];
            NSString *title = item.title;
            CGSize tempSize = [title sizeWithAttributes:@{NSFontAttributeName:cell.m_title.font}];
            if (tempSize.width > 100)
            {
                tempSize.width = 100;
            }
            else if (tempSize.width < 40)
            {
                tempSize.width = 40;
            }
            cell.m_title.text = item.title;
            cell.m_title.width = tempSize.width + 5;
            if (self.tableView == tableView) {
                CGFloat right = cell.width;
                CGFloat columWidth = 0.f;
                NSUInteger index = [self.dataSource indexOfObject:self.selectedModel];
                 
                if (self.dataSource.count > 0) {
                    columWidth = kECScreenWidth / self.dataSource.count;
                    right = index * columWidth;
                }
                
                cell.m_title.left  = right + (columWidth - cell.m_title.width)/2.f;
            }else{
                cell.m_title.left  = (tableView.width - cell.m_title.width)/2.f;
            }
            
            
            
            if (item.icon)
            {
                cell.m_icon.image = item.icon;
                cell.m_icon.right = CGRectGetMinX(cell.m_title.frame) - 5;
                cell.m_icon.hidden = NO;
            }
            else
            {
                cell.m_icon.hidden = YES;
            }
            
            if (item == self.selectedModel.selectedItem)
            {
                if (item.checkedImage)
                {
                    cell.m_checkIcon.image = item.checkedImage;
                    cell.m_checkIcon.hidden = NO;
                    cell.m_lineView.hidden = (indexPath.row == [self.selectedModel.dataSource count] - 1);
                }
                else
                {
                    cell.m_checkIcon.hidden = YES;
                    cell.m_lineView.hidden = NO;
                }
                cell.m_selectLineView.hidden = NO;
                
            }
            else
            {
                cell.m_checkIcon.hidden = YES;
                cell.m_selectLineView.hidden = YES;
            }
        }
        cell.m_checkIcon.hidden = YES;
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
    
    BOOL rightTable = (tableView == self.rightTableView);
    NSMutableArray *dataArr = rightTable?self.selectedModel.rightDataSource:self.selectedModel.dataSource;
    if (dataArr.count > indexPath.row)
    {
        ECCustomerFilterItem *item = dataArr[indexPath.row];
        if (self.selectedItem)
        {
            if (self.selectedModel.selectedItem != item)
            {
                self.selectedModel.selectedItem = item;
                self.selectedItem(item, self.selectedModel, self);
            }
        }
        
        if (!rightTable&&self.selectedModel.rightDataSource.count > 0) {
            if (self.rightTableView) {
                [self.rightTableView reloadData];
            }
            return;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSInteger index = [self.dataSource indexOfObject:self.selectedModel];
        if (index < self.modelViewArray.count)
        {
            ECFilterButton *btn = [self.modelViewArray objectAtIndex:index];
            if (indexPath.row == 0 && item.value.length == 0)
            {
                //[btn setTitle:self.selectedModel.title forState:UIControlStateNormal];
                btn.strTitle = self.selectedModel.title;
            }
            else
            {
                //[btn setTitle:item.title forState:UIControlStateNormal];
                btn.strTitle = item.title;
            }
            [self sectionClick:btn];
        }
    }
}

#pragma mark - OverWrite Methods
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    
    if (v == nil&&self.backGroudView.alpha == 1&&self.tableView.height > 44.0f) {
        CGPoint tp = [self.tableView convertPoint:point fromView:self.tableView.superview];
        if (CGRectContainsPoint(self.tableView.bounds, tp)) {
            return self.tableView;
        }
        
        CGPoint tp2 = [self.backGroudView convertPoint:point fromView:self.backGroudView.superview];
        if (CGRectContainsPoint(self.backGroudView.bounds, tp2)) {
            return self.backGroudView;
        }
    }
    return v;
}

-(void)refreshTables
{
    if (self.tableView) {
        [self.tableView reloadData];
    }
    
    if (self.rightTableView) {
        [self.rightTableView reloadData];
    }
    NSInteger row = 0;
    NSMutableArray *selectDataArr = self.selectedModel.dataSource;
    if (selectDataArr.count > 0) {
        for (NSInteger i = 0; i< selectDataArr.count; i++) {
            ECCustomerFilterItem *model = selectDataArr[i];
            if(self.selectedModel.selectedItem == model){
                row = i;
            }
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

}

@end

@implementation ECCustomerFilterModel


@end


@implementation ECCustomerFilterItem
+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value icon:(UIImage *)icon checkedImage:(UIImage *)checkedImage
{
    ECCustomerFilterItem *item = [[ECCustomerFilterItem alloc] init];
    item.title = title;
    item.value = value;
    item.icon = icon;
    item.checkedImage = checkedImage;
    return item;
}

@end

@implementation ECCustomerFilterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 43)];
        label.backgroundColor = kECClearColor;
        label.textColor = kECBlackColor2;
        label.font = [UIFont systemFontOfSize:15];
        self.m_title = label;
        [self addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 14, 15.2, 15.2)];
        imageView.backgroundColor = kECClearColor;
        self.m_icon = imageView;
        [self addSubview:imageView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kECScreenWidth - 15 - 20, 11, 20.4, 20.4)];
        imageView.backgroundColor = kECClearColor;
        self.m_checkIcon = imageView;
        [self addSubview:imageView];
        
//        self.m_lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kECScreenWidth, 0.5)];
//        self.m_lineView.backgroundColor = kECBlackColor5;
//        [self addSubview:self.m_lineView];
        
        self.m_selectLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 43.5)];
        self.m_selectLineView.backgroundColor = [UIColor colorWithPatternImage:kECGreenImage2];
        self.m_selectLineView.hidden = YES;
        [self addSubview:self.m_selectLineView];
        
        self.backgroundColor = [UIColor whiteColor];
//        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

@end

@implementation ECFilterButton
- (UILabel *)m_titleLab
{
    if (_m_titleLab == nil)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = kECBlackColor2;
        label.textAlignment = NSTextAlignmentCenter;
        _m_titleLab = label;
        [self addSubview:label];
    }
    return _m_titleLab;
}

- (UIImageView *)m_imageView
{
    if (_m_imageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 19, 10, 6.5)];
        _m_imageView = imageView;
        [self addSubview:imageView];
    }
    return _m_imageView;
}

- (void)setStrTitle:(NSString *)strTitle
{
    _strTitle = strTitle;
    CGSize size = [NSString contentAutoSizeWithText:strTitle boundSize:CGSizeMake(MAXFLOAT, 20) font:self.m_titleLab.font];
    size.width = ceil(size.width);
    if (size.width > self.width - self.m_imageView.width-3)
    {
        size.width = self.width - self.m_imageView.width-3;
    }
    CGFloat imageWith = 0;
    if (self.m_imageView.hidden == NO)
    {
        imageWith = self.m_imageView.width + 3;
    }
    CGFloat x = (self.width - size.width - imageWith)/2.0;
    x = ceil(x);
    CGRect rect = self.m_titleLab.frame;
    rect.origin.x = x;
    rect.size.width = size.width;
    self.m_titleLab.frame = rect;
    self.m_imageView.left = CGRectGetMaxX(rect)+3;
    self.m_titleLab.text = strTitle;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        self.m_imageView.image = _isBottom? [UIImage imageNamed:@"icon_customer_filter_arrow_down_upsideDown"]:[UIImage imageNamed:@"icon_customer_filter_arrow"];
    }
    else
    {
        self.m_imageView.image =_isBottom? [UIImage imageNamed:@"icon_customer_filter_arrow_upsideDown"]:[UIImage imageNamed:@"icon_customer_filter_arrow-1"];
        
    }
}



@end
