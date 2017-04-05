//
//  ECCustomerFilterView.m
//  ECDoctor
//
//  Created by linsen on 15/11/6.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECCustomerFilterView.h"
@interface ECCustomerFilterView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UIScrollView *pageView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *modelViewArray;
@property (nonatomic, strong)ECCustomerFilterModel *selectedModel;
@property (nonatomic, strong)UIImageView *singleView;
@property (nonatomic, strong)UIView *backGroudView;
@property(nonatomic,assign)BOOL isBottom;

@end
#define selfViewTagBase     1000
@implementation ECCustomerFilterView

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
                //[btn setTitle:model.title forState:UIControlStateNormal];
              btn.strTitle = model.title;
              if (model.dataSource.count > 0) {
                //[btn setImage:[UIImage imageNamed:@"icon_customer_filter_arrow_down"] forState:UIControlStateNormal];
                //[btn setImage:[UIImage imageNamed:@"icon_customer_filter_arrow"] forState:UIControlStateSelected];
                //[btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 15)];
                btn.m_imageView.hidden = NO;
                btn.userInteractionEnabled = YES;
              }
              else
              {
                btn.m_imageView.hidden = YES;
                btn.userInteractionEnabled = NO;
              }

                [btn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
                //[btn setImageEdgeInsets:UIEdgeInsetsMake(18.9, viewWidth/self.dataSource.count - 10 - 6, 18.5, 5.9)];

                //[btn setTitleColor:kECBlackColor1 forState:UIControlStateNormal];
                //btn.titleLabel.font = [UIFont systemFontOfSize:13];
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
      
      if (_isBottom) {
        self.tableView.bottom = kECScreenHeight - 44.0f;
        [[UIApplication sharedApplication].keyWindow addSubview:tableView];
      }else{
        [self addSubview:tableView];
      }
    }
    return self;
}

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
//                [btn setTitle:model.title forState:UIControlStateNormal];
//                btn.selected = NO;
//              if (model.dataSource.count > 0) {
//                [btn setImage:[UIImage imageNamed:@"icon_customer_filter_arrow_down"] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"icon_customer_filter_arrow"] forState:UIControlStateSelected];
//                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 15)];
//              }else{
//                [btn setImage:nil forState:UIControlStateNormal];
//                [btn setImage:nil forState:UIControlStateSelected];
//                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//              }
            }
        }
      
      
    }
    self.tableView.height = 0;
    self.backGroudView.alpha = 0;
    self.height = 44;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSInteger index = [self.dataSource indexOfObject:self.selectedModel];
//    if (index < self.modelViewArray.count)
//    {
//        UIButton *btn = [self.modelViewArray objectAtIndex:index];
//        [self sectionClick:btn];
//    }
//}

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
               [self.tableView reloadData];
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
  //self.singleView.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedModel && [self.selectedModel isKindOfClass:[ECCustomerFilterModel class]])
    {
        return self.selectedModel.dataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    ECCustomerFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[ECCustomerFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (self.selectedModel && [self.selectedModel isKindOfClass:[ECCustomerFilterModel class]])
    {
        if (self.selectedModel.dataSource.count > indexPath.row)
        {
            ECCustomerFilterItem *item = self.selectedModel.dataSource[indexPath.row];
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
            
            if (item.icon)
            {
                cell.m_icon.image = item.icon;
                cell.m_icon.left = CGRectGetMaxX(cell.m_title.frame) + 15;
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
                    //cell.m_lineView.backgroundColor = kECBlackColor5;
                    cell.m_lineView.hidden = (indexPath.row == [self.selectedModel.dataSource count] - 1);
                }
                else
                {
                    //cell.m_lineView.backgroundColor = kECGreenColor2;
                    cell.m_checkIcon.hidden = YES;
                    cell.m_lineView.hidden = NO;
                }
                //cell.m_title.textColor = kECGreenColor2;
              cell.m_selectLineView.hidden = NO;
            }
            else
            {
                //cell.m_title.textColor = kECBlackColor2;
                cell.m_checkIcon.hidden = YES;
                //cell.m_lineView.backgroundColor = kECBlackColor5;
                //cell.m_lineView.hidden = (indexPath.row == [self.selectedModel.dataSource count] - 1);
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
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedModel.dataSource.count > indexPath.row)
    {
        ECCustomerFilterItem *item = self.selectedModel.dataSource[indexPath.row];
        if (self.selectedItem)
        {
            if (self.selectedModel.selectedItem != item)
            {
                self.selectedModel.selectedItem = item;
                self.selectedItem(item, self.selectedModel, self);
            }
        }
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



@end

