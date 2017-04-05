//
//  ECLoginRootController.h
//  ECCustomer
//
//  Created by yellowei on 16/8/24.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "ECBaseViewController.h"

@interface ECLoginRootController : ECBaseViewController

@property (nonatomic, copy)void(^loginSuccess)();

@property (nonatomic, copy)void(^finishLogin)(BOOL isSuccess);

@property(nonatomic, assign) NSUInteger tabSelectedIndex;

@property (nonatomic, strong) ECBaseViewController * shieldController;

@end
