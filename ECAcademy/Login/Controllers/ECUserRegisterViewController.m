//
//  ECUserRegisterViewController.m
//  ECDoctorBalefire
//
//  Created by linsen on 15/12/17.
//  Copyright (c) 2015年 Sophist. All rights reserved.
//

#import "ECUserRegisterViewController.h"
//#import "ECUser.h"
//#import "ECNetworkRequestManager+User.h"
//#import "ECNewUseagreementViewController.h"
//#import "ECServerRequestFuncCode.h"
#import "ECBindUserMobileViewController.h"
#import "ECSetPasswordViewController.h"


@interface ECUserRegisterViewController ()<UITextFieldDelegate>
{
    NSInteger _currentTime;
    BOOL _isSending;
    NSTimer *_myTimer;
    CGPoint touchPoint;
}
@property (strong, nonatomic) IBOutlet UIView *navBgView;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *getCode;
//@property (nonatomic, strong) ECUser *m_user;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *showPasswordBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (strong, nonatomic) IBOutlet UILabel *navTitleLab;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *registerViews;
@end

@implementation ECUserRegisterViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.registerBtn.layer.cornerRadius = 4;
    [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"bg_blue_color1"] forState:UIControlStateDisabled];
    [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"bg_blue_color2"] forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"bg_blue_color3"] forState:UIControlStateHighlighted];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerBtn.enabled = NO;
    
    [self.agreeBtn setImage:[UIImage imageNamed:@"agreement_icon"] forState:UIControlStateSelected];
    [self.agreeBtn setImage:[UIImage imageNamed:@"unagreement_icon"] forState:UIControlStateNormal];
    self.agreeBtn.selected = YES;
    
    [self.showPasswordBtn setImage:[UIImage imageNamed:@"see_password_selected"] forState:UIControlStateSelected];
    [self.showPasswordBtn setImage:[UIImage imageNamed:@"see_password"] forState:UIControlStateNormal];
    
    [self.getCode setBackgroundImage:[UIImage imageNamed:@"login_getcode_able"] forState:UIControlStateNormal];
    [self.getCode setBackgroundImage:[UIImage imageNamed:@"login_getcode_unable"] forState:UIControlStateDisabled];
    self.getCode.enabled = NO;
    
    [self.getCode setTitleColor:kECGreenColor2 forState:UIControlStateNormal];
    [self.getCode setTitleColor:kECBlackColor4 forState:UIControlStateDisabled];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.m_type == ECUserRegisterViewControllerTypeOfReSetPassword)
    {
        for (UIView *view in self.registerViews)
        {
            view.hidden = YES;
        }
        self.navTitleLab.text = @"重置密码";
        [self.registerBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBgView.backgroundColor = kECGreenColor2;
    //self.view.frame = CGRectMake(0, 0, kECScreenWidth, kECScreenHeight);
    self.bgScrollView.contentSize = CGSizeMake(kECScreenWidth, kECScreenHeight);
    [self setBGScrollViewHeight:kECScreenHeight];
    [self.bgScrollView setUserInteractionEnabled:YES];
    //[self.bgScrollView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    //[self.navigationController setNavigationBarHidden:YES];
    //[self hideNavgationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    touchPoint = [touch locationInView:self.view];
    //[touches anyObject]
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (fabs(point.y - touchPoint.y) > 20)
    {
        [self hideKeyBoard];
    }
}

#if Re
- (void)userLogin
{
    if (self.m_user)
    {
        [self keyboardHidden];
        [self showWatingWithInfo:@"用户登录中"];
        ECBlockSet
        [ECNetworkRequestManager loginWithUser:self.m_user callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
            ECBlockGet(strongSelf)
            if (code == 1)
            {
                ECUser *user = [ECUser standardUser];
                if (user)
                {
                    [strongSelf showSimpleInfo:@"注册成功"];
                    [strongSelf compeletLogin];
                    /* [ECNetworkRequestManager alertUserPasswordAndUserNameWith:[ECUser standardUser] password:user.loginUserPassword username:user.loginUserName callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
                     ECBlockGet(strongSelf2)
                     [strongSelf2 dissmissHub];
                     if (code == 1 && strongSelf2)
                     {
                     [strongSelf2 showSimpleInfo:@"注册成功"];
                     [strongSelf2 compeletLogin];
                     }
                     else
                     {
                     [strongSelf2 showSimpleAlertViewWithMessage:@"注册失败" title:@"提示"];
                     }
                     }];*/
                }
                else
                {
                    [strongSelf dissmissHub];
                    [strongSelf showSimpleAlertViewWithMessage:@"注册失败" title:@"提示"];
                }
                
            }
            else
            {
                [strongSelf dissmissHub];
                [strongSelf showSimpleAlertViewWithMessage:msg title:@"提示"];
            }
        }];
    }
}


- (void)compeletLogin
{
    [self keyboardHidden];
    [self restSmgBtn];
    ECUser *user = [ECUser standardUser];
    NSString *mobile = [user bindmobile];
    NSString *password = @"暂不做密码限制";//[user password];
    // NSArray *array = [user getUserClinics];
    BOOL needToAddClinic = [user needToAddClinic];
    NSArray *controllers = self.navigationController.viewControllers;
    UIViewController *vc = nil;
    if ([controllers count] > 0)
    {
        vc = [controllers lastObject];
    }
    ECBlockSet
    if (mobile.length == 0)
    {
        ECBindUserMobileViewController *vc = [[ECBindUserMobileViewController alloc] initWithNibName:@"ECBindUserMobileViewController" bundle:nil];
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
        vc.complete = ^(ECSetPasswordViewController *controller){
            ECBlockGet(strongSelf)
            [strongSelf compeletLogin];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        [self showSimpleInfo:@"您还没有设置密码,请去设置"];
    }
    else if (needToAddClinic)
    {
        if (![vc isKindOfClass:[ECAddClinicViewController class]])
        {
            ECAddClinicViewController *vc = [[ECAddClinicViewController alloc] initWithNibName:@"ECAddClinicViewControllerNew" bundle:nil];
            vc.isHiddenBackBtn = YES;
            vc.complete = ^(BOOL isSuccess){
                ECBlockGet(strongSelf)
                if (isSuccess)
                {
                    [strongSelf compeletLogin];
                }
                else
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        ECBlockGet(strongSelf2);
                        if (strongSelf2)
                        {
                            [strongSelf2.navigationController popViewControllerAnimated:YES];
                        }
                    });
                }
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        [self showSimpleInfo:@"您还没有关联诊所,请去关联"];
    }
    else
    {
        if (self.loginSuccess)
        {
            self.loginSuccess();
        }
        ECBlockSet
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            ECBlockGet(strongSelf)
            strongSelf.navigationController.view.top = kECScreenHeight;
        } completion:^(BOOL finished) {
            ECBlockGet(strongSelf)
            [strongSelf.navigationController.view removeFromSuperview];
            if (strongSelf.finishLogin)
            {
                strongSelf.finishLogin(YES);
            }
        }];
    }
}
- (IBAction)toSeeAgument:(id)sender {
    
    ECNewUseagreementViewController * agreeVc=[[ECNewUseagreementViewController alloc] init];
    agreeVc.isHideNavbar = YES;
    [self.navigationController pushViewController:agreeVc animated:YES];
}

#endif

- (void)keyboardHidden
{
    [self.phoneNum resignFirstResponder];
    [self.code resignFirstResponder];
    [self.password resignFirstResponder];
}

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
    self.getCode.backgroundColor = kECClearColor;
}

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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#if Re
- (IBAction)complete:(id)sender {
    NSString *userName = [NSString stringEmptyTransform:self.phoneNum.text];
    NSString *code = [NSString stringEmptyTransform:self.code.text];
    NSString *password = [NSString stringEmptyTransform:self.password.text];
    if (![userName  isValidMoblieNum])
    {
        [self showSimpleAlertViewWithMessage:@"手机号码不符合规范" title:@"提示"];
    }
    else if (code.length < 4 || code.length > 6)
    {
        [self showSimpleAlertViewWithMessage:@"验证码不符合规范" title:@"提示"];
    }
    else if (password.length < 6 || password.length > 16)
    {
        [self showSimpleAlertViewWithMessage:@"请保证设置密码长度为6-16位" title:@"提示"];
    }
    else
    {
        if (self.m_user == nil)
        {
            self.m_user = [[ECUser alloc] init];
        }
        if (self.m_type == ECUserRegisterViewControllerTypeOfReSetPassword)
        {
            self.m_user.loginUserName = userName;
            self.m_user.loginMobilePhone  = userName;
            self.m_user.loginUserPassword = password;
            self.m_user.loginType = UserLoginTypeOfCommon;
            [self showWatingWithInfo:@"数据提交中"];
            ECBlockSet
            [ECNetworkRequestManager forgetUserPasswordWithMobile:userName password:password code:code callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
                ECBlockGet(strongSelf)
                if (code == 1)
                {
                    [strongSelf userLogin];
                }
                else
                {
                    [strongSelf dissmissHub];
                    if (msg.length == 0)
                    {
                        msg = @"重置密码失败";
                    }
                    [strongSelf showSimpleAlertViewWithMessage:msg title:@"提示"];
                }
            }];
        }
        else
        {
            self.m_user.loginUserName = userName;
            self.m_user.loginMobilePhone  = userName;
            self.m_user.loginUserPassword = password;
            self.m_user.loginType = UserLoginTypeOfCommon;
            [self showWatingWithInfo:@"正在注册"];
            ECBlockSet
            [ECNetworkRequestManager registerUserAndLoginWithMobile:userName password:password code:code callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
                ECBlockGet(strongSelf)
                if (strongSelf)
                {
                    [strongSelf dissmissHub];
                    if (code == 1)
                    {
                        ECUser *user = [ECUser standardUser];
                        if (user)
                        {
                            [strongSelf showSimpleInfo:@"注册成功"];
                            [strongSelf compeletLogin];
                        }
                    }
                    else
                    {
                        NSString *string = [NSString stringEmptyTransform:msg];
                        if (string.length == 0)
                        {
                            string = @"注册失败";
                        }
                        [strongSelf showSimpleInfo:string];
                    }
                }
                
            }];
        }
        //    [ECNetworkRequestManager registerUserWithMobile:userName password:password code:code callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
        //      if (code == 1)
        //      {
        //        ECBlockGet(strongSelf)
        //        [strongSelf userLogin];
        //      }
        //    }];
        
    }
}
- (IBAction)getPhoneCode:(id)sender {
    NSString *mobile = [NSString stringEmptyTransform:self.phoneNum.text];
    if ([mobile isValidMoblieNum])
    {
        if (!_isSending)
        {
            [self keyboardHidden];
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
            [ECNetworkRequestManager requestPhoneLoginCodeWithMobileNO:mobile useForFunc:[NSString stringWithFormat:@"%@", FUNC_ID_USER_REGISTER_LOGIN] callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
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
                        [strongSelf showSimpleInfo:msg];
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

#endif

- (IBAction)showPasswordClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.password.secureTextEntry = !sender.selected;
}

- (IBAction)agreeBtn:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
    self.registerBtn.enabled = self.agreeBtn.selected;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y < -0.2)
    {
        [self hideKeyBoard];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldChanged:(NSNotification *)notification
{
    NSString *phone = [NSString stringEmptyTransform:self.phoneNum.text];
    NSString *code = [NSString stringEmptyTransform:self.code.text];
    NSString *password = [NSString stringEmptyTransform:self.password.text];
    if ([phone isValidMoblieNum] && !_isSending)
    {
        self.getCode.enabled = YES;
    }
    else
    {
        self.getCode.enabled = NO;
    }
    if ([phone isValidMoblieNum] && code.length >= 4 && password.length > 0 && self.agreeBtn.selected)
    {
        self.registerBtn.enabled = YES;
    }
    else
    {
        self.registerBtn.enabled = NO;
    }
}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self setBGScrollViewHeight:kECScreenHeight - keyboardSize.height];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    [self setBGScrollViewHeight:kECScreenHeight];
}

- (void)setBGScrollViewHeight:(CGFloat )height
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.bgScrollView.height = height;
                         if (height >= 460)
                         {
                             self.bgScrollView.contentOffset = CGPointMake(0, 0);
                         }
                         else
                         {
                             self.bgScrollView.contentOffset = CGPointMake(0, 460-height);
                         }
                     }
                     completion:^(BOOL finished){
                         if (self.bgScrollView.contentSize.height > self.bgScrollView.height)
                         {
                             self.bgScrollView.scrollEnabled = YES;
                         }
                         else
                         {
                             self.bgScrollView.scrollEnabled = NO;
                         }
                     }
     ];
}

@end
