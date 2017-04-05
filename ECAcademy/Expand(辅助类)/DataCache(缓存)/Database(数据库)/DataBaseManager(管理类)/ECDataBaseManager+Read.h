//
//  ECDataBaseManager+Read.h
//  ECDoctor
//
//  Created by linsen on 15/8/18.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDataBaseManager.h"
@interface ECDataBaseManager (Read)

/**
 *	@brief	获取用户关联诊所
 *
 *	@param 	user 	用户
 *
 *	@return	诊所列表（ECClinic）
 *
 *	Created by mac on 2015-08-18 15:04
 */
+ (NSMutableArray *)getUserClinicsWithUser:(ECUser *)user;

#pragma mark - 针对公共数据库查询
+ (void)clearUniversityInfo;
+ (NSMutableDictionary *)getUniversityList;

@end
