//
//  ECForgetPasswordViewController.h
//  ECDoctorBalefire
//
//  Created by linsen on 15/12/21.
//  Copyright (c) 2015年 Sophist. All rights reserved.
//

#import "ECBaseViewController.h"

@interface ECForgetPasswordViewController : ECBaseViewController

@property (nonatomic, copy)void(^finishLogin)(BOOL isSuccess);

@end
