//
//  ECBaseViewController.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/24.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECBaseViewController.h"
#import "UIViewController+HUD.h"
#import "UIViewController+ECCommonMethods.h"
#import "UIView+CommonMethods.h"
#import "UIImage+ECExtensions.h"
@interface ECBaseViewController ()

@end

@implementation ECBaseViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initCommonProperty];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initCommonProperty];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //自定义返回按钮手势会消失
    [self enablePopGesture];
}
-(void)initCommonProperty
{
    // 设置导航条的色调 理解为"混合色"
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // 导航栏默认是半透明状态
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    // 导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kECBlackColor2}];

    UIImage *colorImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kECBlackColor5]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.navigationController) {
        [self initNavBackItem];
        self.hidesBottomBarWhenPushed = YES;
    }
    
}

-(void)initNavBackItem
{
    [self customBackImage:nil title:nil];
}

@end
