//
//  AppDelegate.h
//  ECAcademy
//
//  Created by Sophist on 2017/3/23.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy)void(^Appdelegateblock)(id data);

+ (BOOL)sendAuthRequest;//微信登录

@end

