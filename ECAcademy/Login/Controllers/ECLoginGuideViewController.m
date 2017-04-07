//
//  ECLoginGuideViewController.m
//  ECDoctorBalefire
//
//  Created by linsen on 15/12/17.
//  Copyright (c) 2015年 Sophist. All rights reserved.
//

//Models
#import "ECUser.h"

//Views
#import "ECBottomPopView.h"

//Controllers
#import "ECLoginGuideViewController.h"
#import "ECUserRegisterViewController.h"
#import "ECSetPasswordViewController.h"
#import "ECLoginBindPhoneController.h"
#import "ECLoginKQ88ViewController.h"
#import "ECForgetPasswordViewController.h"

//Tools
#import "ECNetworkRequestManager+User.h"
#import "AppDelegate.h"
#import "UIButton+Extension.h"
#import <MJRefresh.h>
#import "NSObject+AOP.h"

@interface ECLoginGuideViewController ()

/*↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓IBOutlet↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
@property (strong, nonatomic) IBOutlet UILabel * weChatBtnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weChatBtnImgView;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;

//
@property (weak, nonatomic) IBOutlet UIImageView *kq88BtnImgView;
@property (weak, nonatomic) IBOutlet UILabel *kq88BtnLabel;
@property (weak, nonatomic) IBOutlet UIButton *kq88Btn;
//
@property (weak, nonatomic) IBOutlet UIView *line_3;
@property (weak, nonatomic) IBOutlet UIView *line_2;
@property (weak, nonatomic) IBOutlet UIView *line_1;
//
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//
@property (weak, nonatomic) IBOutlet UIButton *forgotPswBtn;
//
@property (weak, nonatomic) IBOutlet UITextField *pswTextF;
@property (weak, nonatomic) IBOutlet UIImageView *pswIconView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIconView;
//
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
/*↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑IBOutlet↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑*/

@property (nonatomic, strong)ECUser * m_user;
@property (nonatomic, strong)UITextField *m_serverAddressField;


@end

@implementation ECLoginGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"登录";
    [self addRightBtn];
    [self addLeftBtn];
    [self resetViews];
}

- (void)dealloc
{
    DLog(@"%@ Release!!", NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Private methods
- (void)addRightBtn
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    [rightBtn setTitleColor:ECColorWithHEX(0x5c87d4) forState:UIControlStateNormal];
    [rightBtn setTitleColor:ECColorWithHEX(0x888888) forState:UIControlStateHighlighted];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [rightBtn addTarget:self action:@selector(onRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self customNavRightViews:@[rightBtn]];
}

- (void)addLeftBtn
{
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 9.5, 20, 20)];
    [leftBtn setImage:[UIImage imageNamed:@"btn_navi_close_nor"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"btn_navi_close_sel"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(onLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self customleftViews:@[leftBtn]];
}

- (void)resetViews
{
    ECBlockSet
    dispatch_async(dispatch_get_main_queue(), ^{
        //重置线高度
        [weakSelf.line_1 setHeight:0.5f];
        [weakSelf.line_2 setHeight:0.5f];
        [weakSelf.line_3 setHeight:0.5f];
        //登录按钮切圆角和高亮颜色
        weakSelf.loginBtn.layer.cornerRadius = 2.0f;
        weakSelf.loginBtn.clipsToBounds = YES;
        [weakSelf.loginBtn setBackgroundColor:ECColorWithHEX(0x888888) forState:UIControlStateHighlighted];
        [weakSelf.loginBtn addTarget:self action:@selector(toLoginByPhone:) forControlEvents:UIControlEventTouchUpInside];
        
    });
}

# pragma mark - Events
- (void)onLeftBtnClick:(UIButton *)btn
{
    ECBlockSet
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.finishLogin)
        {
            weakSelf.finishLogin(NO);
        }
    }];
}

- (void)onRightBtnClick:(UIButton *)btn
{
    ECUserRegisterViewController * regVc = [[ECUserRegisterViewController alloc] initWithNibName:@"ECUserRegisterViewController" bundle:[NSBundle mainBundle]];
    regVc.title = @"快速注册";
    [self.navigationController pushViewController:regVc animated:YES];
}

- (IBAction)onKQ88BtnClick:(UIButton *)sender
{
    ECLoginKQ88ViewController * kq88LoginVc = [[ECLoginKQ88ViewController alloc] initWithNibName:@"ECLoginKQ88ViewController" bundle:[NSBundle mainBundle]];
    kq88LoginVc.title = @"授权登录";
    [self.navigationController pushViewController:kq88LoginVc animated:YES];
}

- (IBAction)onWeChatBtnClick:(UIButton *)sender
{
    
}

- (IBAction)onForgetPswBtnClick:(UIButton *)sender
{
    ECForgetPasswordViewController * forgotVC = [[ECForgetPasswordViewController alloc] initWithNibName:@"ECForgetPasswordViewController" bundle:[NSBundle mainBundle]];
    forgotVC.title = @"找回密码";
    [self.navigationController pushViewController:forgotVC animated:YES];
}


# pragma mark - 手机验证码登录

- (void)toLoginByPhone:(UIButton *)btn
{
    [btn setBackgroundColor:kECWhiteColor];
    
    ECLoginBindPhoneController * logVc = [[ECLoginBindPhoneController alloc] initWithNibName:@"ECLoginBindPhoneController" bundle:nil];
    logVc.title = @"绑定手机号码";
    
    ECBlockSet
    logVc.loginSuccess = ^(){
        ECBlockGet(strongSelf1)
        if (strongSelf1->_loginSuccess)
        {
            strongSelf1->_loginSuccess();
        }
    };
    
    logVc.finishLogin = ^(BOOL isSuccess){
        ECBlockGet(strongSelf2)
        if (strongSelf2)
        {
            if (strongSelf2->_finishLogin)
            {
                strongSelf2->_finishLogin(isSuccess);
            }
        }
    };
    
    
    [self.navigationController pushViewController:logVc animated:YES];
}


- (void)toLoginByPhoneDragExit:(UIButton *)btn
{
    [btn setBackgroundColor:kECWhiteColor];
}

- (void)toLoginByPhoneTouchDown:(UIButton *)btn
{
    [btn setBackgroundColor:kECBlackColor5];
}

# pragma mark - 用户名登录

- (void)toLoginByUsername:(id)sender {
    
    
}


# pragma mark - 微信登录按钮

- (void)toWechatLogin:(id)sender
{
    [sender setBackgroundColor:ECColorWithHEX(0x56cc79)];
    
    if ([AppDelegate sendAuthRequest])
    {
        [self hideKeyBoard];
        AppDelegate * delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        ECBlockSet
        delegate.Appdelegateblock=^(NSDictionary * infoDic){
            ECBlockGet(strongSelf)
            //if (strongSelf.m_user == nil)
            {
                strongSelf.m_user = [[ECUser alloc] init];
            }
            strongSelf.m_user.loginType = UserLoginTypeOfWeCat;
            strongSelf.m_user.otherLoginData = infoDic;
            [strongSelf userLogin];
        };
    }
}

- (void)toWechatDragExit:(UIButton *)btn
{
    [btn setBackgroundColor:ECColorWithHEX(0x56cc79)];
}

- (void)toWechatTouchDown:(UIButton *)btn
{
    [btn setBackgroundColor:kECGreenColor4];
}

# pragma mark - 注册按钮

- (void)toRegister:(id)sender {
    
    ECUserRegisterViewController *vc = [[ECUserRegisterViewController alloc] initWithNibName:@"ECUserRegisterViewController" bundle:nil];
    ECBlockSet
    vc.loginSuccess = ^(){
        ECBlockGet(strongSelf)
        if (strongSelf.loginSuccess)
        {
            strongSelf.loginSuccess();
        }
    };
    vc.finishLogin = ^(BOOL finish){
        ECBlockGet(strongSelf)
        if (strongSelf && finish)
        {
            strongSelf.finishLogin(finish);
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

# pragma mark - 登录

- (void)userLogin
{
    if (self.m_user)
    {
        [self hideKeyBoard];
        [self showWatingWithInfo:@"用户登录中"];
        ECBlockSet
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ECBlockGet(strongSelf1)
            
            [ECNetworkRequestManager loginWithUser:strongSelf1.m_user callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
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
        });
        
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
    UIViewController *vc = nil;
    if ([controllers count] > 0)
    {
        vc = [controllers lastObject];
    }
    
    ECBlockSet
    if (mobile.length == 0)
    {
        ECLoginBindPhoneController *vc = [[ECLoginBindPhoneController alloc] initWithNibName:@"ECLoginBindPhoneController" bundle:nil];
        //vc.isHiddenBackBtn = YES;
        //        if (password.length == 0 || needToAddClinic)
        //        {
        //            vc.rightNavBtnTitle = @"下一步";
        //        }
        [self.navigationController pushViewController:vc animated:YES];
        [self showSimpleInfo:@"您还没有绑定手机号码,请去绑定"];
    }
    else if (password.length == 0)
    {
        ECSetPasswordViewController *vc = [[ECSetPasswordViewController alloc] init];
        vc.isHiddenBackBtn = YES;
        vc.complete = ^(ECSetPasswordViewController *controller){
            ECBlockGet(strongSelf1)
            [strongSelf1 compeletLogin];
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
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            ECBlockGet(strongSelf1)
            strongSelf1.navigationController.view.top = kECScreenHeight;
        } completion:^(BOOL finished) {
            ECBlockGet(strongSelf1)
            [strongSelf1.navigationController.view removeFromSuperview];
            if (strongSelf1.finishLogin)
            {
                strongSelf1.finishLogin(YES);
            }
        }];
    }
}



//隐藏状态栏
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}


@end
