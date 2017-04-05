//
//  ECPhoneLoginController.h
//  ECCustomer
//
//  Created by yellowei on 16/8/25.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "ECBaseViewController.h"

@interface ECPhoneLoginController : ECBaseViewController

@property (nonatomic, copy)void(^loginSuccess)();
@property (nonatomic, copy)void(^finishLogin)(BOOL isSuccess);

@end
