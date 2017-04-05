//
//  ECSetPasswordViewController.h
//  ECDoctor
//
//  Created by 涂捷 on 16/1/13.
//  Copyright © 2016年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBaseViewController.h"
typedef enum ECSetPasswordViewControllerType
{
  ECSetPasswordViewControllerTypeOfSet = 0,
  ECSetPasswordViewControllerTypeOfAlert
}ECSetPasswordViewControllerType;
@interface ECSetPasswordViewController : ECBaseViewController
@property (nonatomic, strong)void(^complete)(ECSetPasswordViewController *vc);
@property (nonatomic)BOOL isHiddenBackBtn;
@property (nonatomic, copy)NSString *rightNavBtnTitle;
@end
