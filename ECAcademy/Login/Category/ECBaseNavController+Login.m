
//
//  UINavigationController+Login.m
//  ECCustomer
//
//  Created by yellowei on 16/8/17.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "ECBaseNavController+Login.h"
#import "NSObject+AOP.h"
#import "ECLoginRootController.h"
#import "ECUser.h"


@implementation ECBaseNavController (Login)

+(void)load
{
    [ECBaseNavController swizzleClassMethod:@selector(pushViewController:animated:) withMethod:@selector(aop_pushViewController:animated:)];

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
            if (![ECUser standardUser])
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
    ECLoginRootController * logVc = [[ECLoginRootController alloc] init];
    [self aop_pushViewController:logVc animated:YES];
}


@end
