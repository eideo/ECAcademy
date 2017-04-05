//
//  ECLoginRootController.m
//  ECCustomer
//
//  Created by yellowei on 16/8/24.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "ECLoginRootController.h"
#import "ECBaseTabbarViewController.h"
#import "ECLoginGuideViewController.h"

#import "ECUser.h"
#import "ECBottomPopView.h"
#import "ECMenuView.h"
#import "ECUser.h"

@interface ECLoginRootController ()

@property (nonatomic, strong) ECLoginGuideViewController * loginGuideController;

@property (nonatomic, strong) ECBaseNavController * loginGuideNaviController;

@end

@implementation ECLoginRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLoginViewController];
    
    
    //添加点击手势, 取消登录
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLoginViewClick:)];
    
    [self.loginGuideController.view addGestureRecognizer:tap];
    
    
}

- (void)dealloc
{
    DLog(@"%@ Release!!", NSStringFromClass([self class]));
}

# pragma mark - 初始化UI

- (void)initLoginViewController
{
    [[ECBottomPopView sharedECBottomPopView] hide];
    [[ECMenuView defaultMenuView] hide];
    
    ECLoginGuideViewController * logVc = [[ECLoginGuideViewController alloc] initWithNibName:@"ECLoginGuideViewController" bundle:nil];
    
    ECBlockSet
    logVc.loginSuccess = ^(){
        ECBlockGet(strongSelf1)
        
    };
    
    logVc.finishLogin = ^(BOOL isSuccess){
        ECBlockGet(strongSelf2)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        if (strongSelf2.finishLogin)
        {
            strongSelf2.finishLogin(isSuccess);
        }
        
        /**
         *  释放登录界面控制器
         */
        [strongSelf2 removeFromParentViewController];
        [strongSelf2.loginGuideNaviController removeFromParentViewController];
        [strongSelf2.loginGuideController removeFromParentViewController];
    };
    
    ECBaseNavController * nav = [[ECBaseNavController alloc] initWithRootViewController:logVc];
    
    //全局化nav,logvc
    self.loginGuideNaviController = nav;
    
    self.loginGuideController = logVc;
    
    [self presentViewController:nav animated:YES completion:nil];
}


# pragma mark - 点击事件
- (void)onLoginViewClick:(UITapGestureRecognizer *)tap
{
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
