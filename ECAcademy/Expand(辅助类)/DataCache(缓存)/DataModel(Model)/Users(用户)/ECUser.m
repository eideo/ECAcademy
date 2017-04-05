//
//  ECUser.m
//  ECDoctor
//
//  Created by linsen on 15/8/17.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECUser.h"
#import "ECUser+Manager.h"

@interface ECUser()

@end

static NSString *kECBossJurisdictionCodes = @"10001;10002;10003;10004;10005;10006;10007;10008;10009;10101;10102;10103;10201;10202;10301;10302;10303;10304;10401;10402;10403;10404;10405;10501;10502;10503;10601;10602;10603;10604;10605;10606;10607;10608;10609;10610;10701;10702;10703;10704;10705;10706;10707;10801;10802;10803;";
static NSString *kECDirectorJurisdictionCodes = @"10001;10002;10003;10004;10005;10006;10007;10008;10009;10101;10102;10103;10201;10202;10301;10302;10303;10304;10401;10402;10403;10404;10405;10501;10502;10503;10601;10602;10603;10604;10605;10606;10607;10608;10609;10610;10701;10702;10703;10704;10705;10706;10707;10801;10802;10803;";
static NSString *kECDoctorJurisdictionCodes = @"10001;10002;10003;10004;10009;10101;10102;10201;10301;10302;10303;10304;10401;10402;10403;10501;10502;10503;10601;10602;10603;10604;10608;10701;10702;10703;10704;10801;";
static NSString *kECTechnicianJurisdictionCodes = @"10006;10301;10401;";
static NSString *kECNurseJurisdictionCodes = @"10002;10003;10004;10009;10101;10102;10201;10301;10302;10303;10304;10401;10402;10403;10501;10502;10503;10602;10603;10604;10608;10702;10703;10704;10801;";
static NSString *kECReceptionistJurisdictionCodes = @"10002;10003;10004;10005;10006;10007;10008;10009;10101;10102;10103;10201;10202;10301;10302;10303;10304;10401;10402;10403;10404;10405;10501;10502;10503;10602;10603;10604;10605;10606;10607;10608;10609;10610;10702;10703;10704;10705;10706;10707;10801;";
static NSString *kECCashierJurisdictionCodes = @"10006;10201;10202";
static NSString *kECFinanceJurisdictionCodes = @"10801;10802;10803;10006;10201;10202";
static NSString *kECConsultantJurisdictionCodes = @"10001;10002;10003;10004;1000910301;10302;10303;10304;10601;10602;10603;10604;10608;10701;10702;10703;10704;10101;10201;10401;10501;10502;10503;";
static NSString *kECCustomerServiceJurisdictionCodes = @"10002;10003;10004;10005;10006;10007;10008;10009;10101;10201;10301;10401;10501;10602;10603;10604;10605;10606;10607;10608;10609;10610;10702;10703;10704;10705;10706;10707;";

@implementation ECUser
static ECUser *sharedUser = nil;

+ (instancetype)standardUser
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUser = [[ECUser alloc] init];
    });
    return sharedUser;
}

+ (void)setStandardUser:(ECUser *)user
{
    if (sharedUser != user)
    {
        sharedUser = user;
    }
    if (sharedUser != nil && [sharedUser isKindOfClass:[ECUser class]])
    {
        sharedUser.isLogin = YES;
    }
}

- (BOOL)saveUser:(BOOL)isStandardUser
{
    [ECUser saveUser:self setStandardUser:isStandardUser];
    return YES;
}

+ (instancetype)lastLoginUser
{
    return [ECUser getLastLoginUser];
}


@end
