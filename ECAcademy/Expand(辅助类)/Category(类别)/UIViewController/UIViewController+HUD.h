//
//  UIViewController+HUD.h
//  ECAcademy
//
//  Created by Sophist on 2017/3/24.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

/**
 简单hub
 */
- (void)showHub;

/**
 网络加载

 @param string info
 */
- (void)showWatingWithInfo:(NSString *)string;

/**
 吐丝

 @param string info
 */
- (void)showSimpleInfo:(NSString *)string;

/**
 消失
 */
- (void)dissmissHub;

/**
 *  提示语(弹窗)
 *
 *  @param message 详情
 *  @param title   标题
 */
-(UIAlertView *)showSimpleAlertViewWithMessage:(NSString *)message title:(NSString *)title;


@end
