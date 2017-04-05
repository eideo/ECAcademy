//
//  ECNetworkRequestManager+Common.h
//  ECAcademy
//
//  Created by Sophist on 2017/3/29.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECNetworkRequestManager.h"

@interface ECNetworkRequestManager (Common)

/**
 根据funcid请求网络

 @param funcid 命令号
 @param param 上传参数
 @param callback 回调
 */
+(void)requestNetDataWithFuncId:(NSString *)funcid param:(NSMutableDictionary *)param callback:(NetworkRequestCallback)callback;

@end
