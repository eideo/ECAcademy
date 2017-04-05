//
//  ECNetworkRequestManager+Common.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/29.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECNetworkRequestManager+Common.h"
#import "NSString+ECExtensions.h"
@implementation ECNetworkRequestManager (Common)

+(void)requestNetDataWithFuncId:(NSString *)funcid param:(NSMutableDictionary *)param callback:(NetworkRequestCallback)callback
{
    if ([funcid isValid]) {
        [[ECNetworkRequestManager sharedECNetworkRequestManager] POST:nil requestUrlType:RequestUrlWithTypeNormal parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            NSInteger code = 0;
            NSString *msg = nil;
            NSArray *records = nil;
            NSDictionary *userDic = nil;
            [[ECNetworkRequestManager sharedECNetworkRequestManager] responseDataHandleWithData:responseObject code:&code msg:&msg records:&records];
            if (code == 1)
            {
                if (records && [records isKindOfClass:[NSArray class]] && [records count] > 0)
                {
                    userDic = [records objectAtIndex:0];
                }
            }
            callback(code, msg, nil, userDic);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            callback(RequestErrorCodeNetworkError, [error localizedDescription], error, nil);
        }];
    }else{
        callback(RequestErrorCodeParametersError, @"参数有误", nil, nil);
    }    
}

@end
