//
//  ECPhoneLoginController.m
//  ECCustomer
//
//  Created by yellowei on 16/8/25.
//  Copyright © 2016年 yellowei. All rights reserved.
//

#import "ECPhoneLoginController.h"
#import "ECBindUserMobileViewController.h"
#import "ECSetPasswordViewController.h"

#import "ECNetworkRequestManager+User.h"
#import "ECUser.h"

@interface ECPhoneLoginController ()
{
    NSInteger _currentTime;
    BOOL _isSending;
    NSTimer *_myTimer;
}


@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UIButton *getCode;
@property (nonatomic, strong)ECUser *m_user;
@property (strong, nonatomic) IBOutlet UIButton *sumbit;


@end

@implementation ECPhoneLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.getCode setTitleColor:kECWhiteColor forState:UIControlStateHighlighted];
    [self.sumbit setTitleColor:kECWhiteColor forState:UIControlStateHighlighted];
    
}

- (void)dealloc
{
    DLog(@"%@ Release!!", NSStringFromClass([self class]));
}

# pragma mark - 点击事件
//getCodeBtn
- (IBAction)getCodeTouchDown:(UIButton *)sender {
    
    [sender setBackgroundColor:kECGreenColor4];
    
}

- (IBAction)getCodeTouchDragExit:(UIButton *)sender {
    [sender setBackgroundColor:ECColorWithHEX(0xCCF0D7)];
}


- (IBAction)getPhoneCode:(UIButton *)sender
{
    [sender setBackgroundColor:ECColorWithHEX(0xCCF0D7)];
    NSString *mobile = [NSString stringEmptyTransform:self.phoneNum.text];
    if ([mobile isValidMoblieNum])
    {
        if (!_isSending)
        {
            [self hideKeyBoard];
            _isSending = YES;
            _currentTime = 60;
            if (!_myTimer)
            {
                _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
            }
            else
            {
                [_myTimer setFireDate:[NSDate distantPast]];
            }
            self.getCode.titleLabel.text = [NSString stringWithFormat:@"等待%zd秒", _currentTime];
            self.getCode.enabled = NO;
            ECBlockSet
            [ECNetworkRequestManager requestPhoneLoginCodeWithMobileNO:mobile callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
                
                if (code == 0)
                {
                    ECBlockGet(strongSelf)
                    if (strongSelf)
                    {
                        [strongSelf restSmgBtn];
                        if (msg.length == 0)
                        {
                            msg = @"获取验证码失败";
                        }
                        [strongSelf showSimpleAlertViewWithMessage:msg title:@"提示"];
                    }
                    
                }
                
            }];
        }
    }
    else
    {
        [self showSimpleAlertViewWithMessage:@"手机号码不符合要求" title:@"提示"];
    }
}


/*
 *SubmitBtn
 */
- (IBAction)submitTouchDown:(UIButton *)sender {
    
    [sender setBackgroundColor:kECGreenColor4];

    
}

- (IBAction)submitTouchDragExit:(UIButton *)sender {
    
    [sender setBackgroundColor:ECColorWithHEX(0x56CC79)];

}


- (IBAction)sumbitClick:(id)sender {
    [sender setBackgroundColor:ECColorWithHEX(0x56CC79)];
    
    NSString *mobile = [NSString stringEmptyTransform:self.phoneNum.text];
    self.m_user= [[ECUser alloc] init];
    self.m_user.loginMobilePhone = mobile;
    self.m_user.loginMobilePhoneCode = self.code.text;
    self.m_user.loginType = UserLoginTypeOfMobileVerification;
//  self.m_user.loginType = UserLoginTypeOfCommon;
  self.m_user.loginUserName = mobile;
    self.m_user.loginUserPassword = self.code.text;//@"qweqwe";//self.code.text;
    [self userLogin];
}

# pragma mark - 私有方法

- (void)restSmgBtn
{
    [_myTimer setFireDate:[NSDate distantFuture]];
    [_myTimer invalidate];
    _myTimer = nil;
    _isSending = NO;
    _currentTime = 60;
    self.getCode.titleLabel.text = @"重新发送";
    [self.getCode setTitle:@"重新发送" forState:UIControlStateNormal];
    self.getCode.enabled = YES;
    self.getCode.backgroundColor = ECColorWithHEX(0xCCF0D7);
    self.getCode.selected = NO;
}


- (void)userLogin
{
    if (self.m_user)
    {
        [self hideKeyBoard];
        [self showWatingWithInfo:@"用户登录中"];
        ECBlockSet
//        ECBlockGet(strongSelf1)
        [ECNetworkRequestManager loginWithUser:self.m_user callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
            ECBlockGet(strongSelf2)
            [strongSelf2 dissmissHub];
            if (code == 1)
            {
                [strongSelf2 showSimpleInfo:@"登录成功"];
                //使用默认登录，开启定时器开始接收问诊数据
                [strongSelf2 compeletLogin];
                
                //          [self tcIMLoginWithCallback:^{
                //
                //          } fail:^(int code, NSString *msg) {
                //
                //          }];
            }
            else
            {
                [strongSelf2 showSimpleAlertViewWithMessage:msg title:@"提示"];
            }
        }];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//        });
        
    }
}


- (void)compeletLogin
{
    //    [self keyboardHidden];
    [self disablePopGesture];
    ECUser *user = [ECUser standardUser];
    NSString *mobile = @"18696405271"; //[user bindmobile];
    NSString *password = @"暂不做密码限制";//[user password];
    //NSArray *array = [user getUserClinics];
    NSArray *controllers = self.navigationController.viewControllers;
    UIViewController *vc1 = nil;
    if ([controllers count] > 0)
    {
        vc1 = [controllers lastObject];
    }
    ECBlockSet
    if (mobile.length == 0)
    {
        ECBindUserMobileViewController *vc = [[ECBindUserMobileViewController alloc] initWithNibName:@"ECBindUserMobileViewController" bundle:nil];
        //vc.isHiddenBackBtn = YES;
        //        if (password.length == 0 || needToAddClinic)
        //        {
        //            vc.rightNavBtnTitle = @"下一步";
        //        }
        vc.compliteBind = ^(ECBindUserMobileViewController *controller){
            ECBlockGet(strongSelf)
            [strongSelf compeletLogin];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [self showSimpleInfo:@"您还没有绑定手机号码,请去绑定"];
    }
    else if (password.length == 0)
    {
        ECSetPasswordViewController *vc = [[ECSetPasswordViewController alloc] init];
        vc.isHiddenBackBtn = YES;
        vc.complete = ^(ECSetPasswordViewController *controller){
            ECBlockGet(strongSelf)
            [strongSelf compeletLogin];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [self showSimpleInfo:@"您还没有设置密码,请去设置"];
    }
    //    else if (needToAddClinic)
    //    {
    //        if (![vc isKindOfClass:[ECAddClinicViewController class]])
    //        {
    //            ECAddClinicViewController *vc = [[ECAddClinicViewController alloc] initWithNibName:@"ECAddClinicViewControllerNew" bundle:nil];
    //            //vc.isHiddenBackBtn = YES;
    //            vc.complete = ^(BOOL isSuccess){
    //                ECBlockGet(strongSelf)
    //                if (strongSelf)
    //                {
    //                    if (isSuccess)
    //                    {
    //                        [strongSelf compeletLogin];
    //                        /*
    //                         [ECNetworkRequestManager getClinicsWithUser:[ECUser standardUser] callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
    //                         ECBlockGet(strongSelf)
    //                         if (strongSelf)
    //                         {
    //                         [strongSelf dissmissHub];
    //                         [strongSelf compeletLogin];
    //                         }
    //                         }];*/
    //                    }
    //                    else
    //                    {
    //                        [strongSelf dissmissHub];
    //                    }
    //                }
    //            };
    //            [self.navigationController pushViewController:vc animated:YES];
    //        }
    //        [self showSimpleInfo:@"您还没有关联诊所,请去关联"];
    //    }
    else
    {
        if (self.loginSuccess)
        {
            self.loginSuccess();
            [self removeFromParentViewController];
        }
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            ECBlockGet(strongSelf>
            self.navigationController.view.top = kECScreenHeight;
        } completion:^(BOOL finished) {
//            ECBlockGet(strongSelf)
            [self.navigationController.view removeFromSuperview];
            if (self.finishLogin)
            {
                self.finishLogin(YES);
                [self removeFromParentViewController];
            }
        }];
    }
}

//计时器
- (void)countDown
{
    _currentTime--;
    if (_currentTime > 0)
    {
        NSString *text = [NSString stringWithFormat:@"等待%zd秒",_currentTime];
        self.getCode.titleLabel.text = text;
        [self.getCode setTitle:text forState:UIControlStateNormal];
    }
    if (_currentTime == 0)
    {
        [self restSmgBtn];
    }
}



@end
