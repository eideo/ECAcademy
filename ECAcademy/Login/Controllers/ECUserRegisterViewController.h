//
//  ECUserRegisterViewController.h
//  ECDoctorBalefire
//
//  Created by linsen on 15/12/17.
//  Copyright (c) 2015年 Sophist. All rights reserved.
//

#import "ECBaseViewController.h"
typedef enum ECUserRegisterViewControllerType
{
  ECUserRegisterViewControllerTypeOfRegister = 0,
  ECUserRegisterViewControllerTypeOfReSetPassword = 1
}ECUserRegisterViewControllerType;
@interface ECUserRegisterViewController : ECBaseViewController
@property (nonatomic, copy)void(^loginSuccess)();
@property (nonatomic, copy)void(^finishLogin)(BOOL isSuccess);
@property (nonatomic)ECUserRegisterViewControllerType m_type;
@end
