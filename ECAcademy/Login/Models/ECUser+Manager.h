//
//  ECUser+Manager.h
//  ECDoctor
//
//  Created by linsen on 15/8/17.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECUser.h"
@interface ECUser (Manager)
+ (ECUser *)getStandardUser;
+ (ECUser *)getLastLoginUser;
+ (BOOL)saveUser:(ECUser *)user setStandardUser:(BOOL)isAllow;
@end
