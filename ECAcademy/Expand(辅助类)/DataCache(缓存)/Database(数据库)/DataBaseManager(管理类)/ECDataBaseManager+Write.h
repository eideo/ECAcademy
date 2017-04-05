//
//  ECDataBaseManager+Write.h
//  ECDoctor
//
//  Created by linsen on 15/8/18.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDataBaseManager.h"
@class ECUser;
@interface ECDataBaseManager (Write)
/**
 *	@brief	保存诊所项目
 *
 *	@param 	user 	用户
 *	@param 	items 	项目列表
 *
 *
 *	Created by mac on 2015-08-21 15:25
 */
+ (BOOL)saveClinicItemsWithUser:(ECUser *)user clinicItems:(NSArray *)items;


#pragma mark - 针对公共数据库
/**
 *	@brief	保存医院信息
 *
 *	@param 	hospitals 	医院信息列表
 *
 */
+ (BOOL)saveHospitalWithHospitalList:(NSArray *)hospitals;

+ (BOOL)saveUniversityWithUniversityList:(NSArray *)universitys;

@end
