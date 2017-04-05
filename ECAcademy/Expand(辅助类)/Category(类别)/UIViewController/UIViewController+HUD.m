//
//  UIViewController+HUD.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/24.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"

@implementation UIViewController (HUD)

- (void)showHub
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)showWatingWithInfo:(NSString *)string
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *showStr = [string isValid]?string:@"加载中...";
    hud.label.text = showStr;
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)showSimpleInfo:(NSString *)string
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    NSString *showStr = [string isValid]?string:@"加载中...";
    hud.label.text = showStr;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, kECScreenHeight/3.0f);
    [hud hideAnimated:YES afterDelay:3.f];
}

- (void)dissmissHub
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(UIAlertView *)showSimpleAlertViewWithMessage:(NSString *)message title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
    return alert;
}


@end
