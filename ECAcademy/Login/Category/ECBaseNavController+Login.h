//
//  ECBaseNavController+Login.h
//  ECCustomer
//
//  Created by yellowei on 16/8/17.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECBaseNavController.h"

@interface ECBaseNavController (Login)

- (void)aop_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)userNeedLoginWithController:(UIViewController *)viewController;
@end
