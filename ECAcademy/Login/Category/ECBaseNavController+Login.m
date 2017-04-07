
//
//  UINavigationController+Login.m
//  ECCustomer
//
//  Created by yellowei on 16/8/17.
//  Copyright © 2016年 yellowei. All rights reserved.
//

//Controllers
#import "ECBaseNavController+Login.h"
#import "ECLoginGuideViewController.h"

//Tools
#import "NSObject+AOP.h"

//Models
#import "ECUser.h"

//Views



@implementation ECBaseNavController (Login)

+(void)load
{
    ECBaseNavController * navObj = [[ECBaseNavController alloc] init];
    [navObj swizzleInstanceMethod:@selector(pushViewController:animated:) withMethod:@selector(aop_pushViewController:animated:)];

}

- (void)aop_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Autority.plist" ofType:nil];
    NSArray * classNames = [NSArray arrayWithContentsOfFile:path];
    
    for(NSString * tmp in classNames)
    {
        
        if([tmp isEqualToString:NSStringFromClass([viewController class])])
        {
            DLog(@"%@ claaName",NSStringFromClass([viewController class]));
            //1.获取权限信息
            if (![ECUser getStandardUser])
            {
                [self userNeedLoginWithController:viewController];
                
                return;
            }
        }//end if
        
        

    }//end for
    
    
    
    //执行真正的原有的push方法
    [self aop_pushViewController:viewController animated:animated];
    

}//end method


- (void)userNeedLoginWithController:(UIViewController *)viewController
{
    ECLoginGuideViewController * logVc = [[ECLoginGuideViewController alloc] initWithNibName:@"ECLoginGuideViewController" bundle:nil];
    
    ECBlockSet
    logVc.loginSuccess = ^(){
        ECBlockGet(strongSelf1)
        
    };
    
    logVc.finishLogin = ^(BOOL isSuccess){

    };
    
    ECBaseNavController * nav = [[ECBaseNavController alloc] initWithRootViewController:logVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}


@end
