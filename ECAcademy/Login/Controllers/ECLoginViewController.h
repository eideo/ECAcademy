//
//  ECLoginViewController.h
//  ECDoctor
//
//  Created by linsen on 15/9/21.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBaseViewController.h"

@interface ECLoginViewController : ECBaseViewController
@property (nonatomic, copy)void(^loginSuccess)();
@property (nonatomic, copy)void(^finishLogin)(BOOL isSuccess);
@end
