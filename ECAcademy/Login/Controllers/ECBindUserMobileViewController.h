//
//  ECBindUserMobileViewController.h
//  ECDoctor
//
//  Created by 涂捷 on 16/1/14.
//  Copyright © 2016年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBaseViewController.h"

@interface ECBindUserMobileViewController : ECBaseViewController
@property(nonatomic, copy)void(^compliteBind)(ECBindUserMobileViewController *vc);
@property(nonatomic, copy)void(^cancelBind)(ECBindUserMobileViewController *vc);
@property (nonatomic, weak)ECBaseViewController *preViewController;
@property (nonatomic)BOOL isHiddenBackBtn;
@end
