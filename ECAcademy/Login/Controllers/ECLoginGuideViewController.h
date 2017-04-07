//
//  ECLoginGuideViewController.h
//  ECDoctorBalefire
//
//  Created by linsen on 15/12/17.
//  Copyright (c) 2015年 Sophist. All rights reserved.
//

#import "ECBaseViewController.h"

@interface ECLoginGuideViewController : ECBaseViewController

@property (nonatomic, copy)void(^loginSuccess)();
@property (nonatomic, copy)void(^finishLogin)(BOOL isSuccess);

@end
