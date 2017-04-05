//
//  ECPlatformShareManager.h
//  ECAcademy
//
//  Created by Sophist on 2017/3/31.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPlatformShareManager : NSObject

singleton_interface(ECPlatformShareManager)

/**
 分享平台
 */
-(void)configUSharePlatforms;

-(void)showShareView;

@end
