//
//  ECDataBaseManager+Write.m
//  ECDoctor
//
//  Created by linsen on 15/8/18.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECDataBaseManager+Write.h"
#import "ECDataBaseManager+Read.h"

#import "FMDatabase.h"
#import "ECUser.h"

@implementation ECDataBaseManager (Write)

+ (BOOL)saveClinicItemsWithUser:(ECUser *)user clinicItems:(NSArray *)items
{
    return [ECDataBaseManager writeData:items intoTable:@"t_scheduleitem" byPrimaryKey:@"scheduleitemidentity&clinicid"];
    return YES;
}

+ (BOOL)saveCustomerClassWithUser:(ECUser *)user customers:(NSArray *)classArr
{
    return [ECDataBaseManager writeData:classArr intoTable:@"t_dictionary" byPrimaryKey:@"clinicuniqueid&dictionaryidentity"];
    return YES;

}

+ (BOOL)saveCustomerWithUser:(ECUser *)user customers:(NSArray *)customers
{
    return [ECDataBaseManager writeData:customers intoTable:@"t_customer" byPrimaryKey:@"customerid&clinicid"];
    return YES;
}

+ (BOOL)saveGroupCustomerWithUser:(ECUser *)user customers:(NSArray *)customers
{
    return [ECDataBaseManager writeData:customers intoTable:@"t_customer" byPrimaryKey:@"patgroup&clinicid"];
    return YES;
}

+ (BOOL)saveSchedulesWithUser:(ECUser *)user schedules:(NSArray *)schedules
{
    return [ECDataBaseManager writeData:schedules intoTable:@"t_schedule" byPrimaryKey:@"scheduleidentity&clinicid"];
    return YES;
}

+ (BOOL)saveVisitsWithUser:(ECUser *)user visits:(NSArray *)visits
{
    return [ECDataBaseManager writeData:visits intoTable:@"t_visit" byPrimaryKey:@"visitidentity&clinicid"];
    return YES;
}

+ (BOOL)saveDoctorsWithUser:(ECUser *)user doctors:(NSArray *)doctors
{
    return [ECDataBaseManager writeData:doctors intoTable:@"t_doctor" byPrimaryKey:@"clinicid"];
    return YES;
}

+ (BOOL)saveBillsWithUser:(ECUser *)user Bills:(NSArray *)Bills
{
    return [ECDataBaseManager writeData:Bills intoTable:@"t_bill" byPrimaryKey:@"billidentity&clinicid"];
    return YES;
}

+ (BOOL)saveHanldesWithUser:(ECUser *)user hanldes:(NSArray *)hanldes
{
    return [ECDataBaseManager writeData:hanldes intoTable:@"t_handle" byPrimaryKey:@"handleidentity&clinicid"];
    return YES;
}

+ (BOOL)saveMediarecordsWithUser:(ECUser *)user mediarecord:(NSArray *)mediarecords
{
    return [ECDataBaseManager writeData:mediarecords intoTable:@"t_mediarecord" byPrimaryKey:@"mediarecordidentity&clinicid"];
    return YES;
}

+ (BOOL)savePatientImagesWithUser:(ECUser *)user patientImages:(NSArray *)patientImages
{
    return [ECDataBaseManager writeData:patientImages intoTable:@"t_image" byPrimaryKey:@"sopinstanceuid&seriesuid&studyuid"];
    return YES;
}

+ (BOOL)saveStudysWithUser:(ECUser *)user studys:(NSArray *)studys
{
    return [ECDataBaseManager writeData:studys intoTable:@"t_study" byPrimaryKey:@"studyidentity&clinicid"];
    return YES;
}

+ (BOOL)saveHospitalWithHospitalList:(NSArray *)hospitals
{
  return [ECDataBaseManager writeData:hospitals intoTable:@"t_hospital" inDataBase:[ECDataBaseManager getCommonDatabase]];
}

+ (BOOL)saveUniversityWithUniversityList:(NSArray *)universitys
{
  return [ECDataBaseManager writeData:universitys intoTable:@"t_university" inDataBase:[ECDataBaseManager getCommonDatabase]];
}


@end
