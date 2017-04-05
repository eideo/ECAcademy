//
//  ECMenuView.h
//  ECDoctor
//
//  Created by linsen on 15/9/24.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECMenuItem;
typedef void (^clickShade)();
typedef void (^clickItem)(ECMenuItem *item);
@interface ECMenuView : UIView<UITableViewDataSource, UITableViewDelegate>
+(ECMenuView *)defaultMenuView;

@property (nonatomic, strong)NSArray *memuItems;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,copy)clickShade clickShade;
@property (nonatomic, copy)clickItem clickItem;
@property (nonatomic, copy) NSString * selectedIndex;

-(void)show;
-(void)hide;

@end

@interface ECMenuItem : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)UIImage *icon;
@property (nonatomic, strong)id originaData;

+ (ECMenuItem *)menuItemWithTitle:(NSString *)title icon:(UIImage *)icon;

@end
