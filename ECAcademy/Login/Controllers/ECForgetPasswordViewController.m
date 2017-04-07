//
//  ECForgetPasswordViewController.m
//  ECDoctorBalefire
//
//  Created by linsen on 15/12/21.
//  Copyright (c) 2015年 Sophist. All rights reserved.
//

#import "ECForgetPasswordViewController.h"
//#import "ECUser.h"
//#import "ECNetworkRequestManager+User.h"
//#import "ECServerRequestFuncCode.h"

@interface ECForgetPasswordViewController ()<UITextFieldDelegate>
{
    NSInteger _currentTime;
    BOOL _isSending;
    NSTimer *_myTimer;
}
@property (strong, nonatomic) IBOutlet UIView *navBgView;
@property (strong, nonatomic) IBOutlet UIButton *showPasswordBtn;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *getCode;
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (strong, nonatomic) IBOutlet UIButton *complite;
@end

@implementation ECForgetPasswordViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.showPasswordBtn setImage:[UIImage imageNamed:@"see_password_selected"] forState:UIControlStateSelected];
    [self.showPasswordBtn setImage:[UIImage imageNamed:@"see_password"] forState:UIControlStateNormal];
    
    [self.getCode setBackgroundImage:[UIImage imageNamed:@"login_getcode_able"] forState:UIControlStateNormal];
    [self.getCode setBackgroundImage:[UIImage imageNamed:@"login_getcode_unable"] forState:UIControlStateDisabled];
    
    [self.getCode setTitleColor:kECGreenColor2 forState:UIControlStateNormal];
    [self.getCode setTitleColor:kECBlackColor4 forState:UIControlStateDisabled];
    
    self.getCode.enabled = NO;
    self.complite.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#if Re

- (void)userLogin
{
    if (self.m_user)
    {
        //self.m_user.loginUserPassword = @"werwer";
        ECBlockSet
        [ECNetworkRequestManager loginWithUser:self.m_user callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
            ECBlockGet(strongSelf)
            if (code == 1)
            {
                ECUser *user = [ECUser standardUser];
                if (user)
                {
                    //[strongSelf showSimpleInfo:@"密码重置成功"];
                    [strongSelf compeletLogin];
                }
                else
                {
                    //[strongSelf showSimpleAlertViewWithMessage:@"密码重置失败" title:@"提示"];
                    [strongSelf compeletAlert];
                }
                
            }
            else
            {
                [strongSelf compeletAlert];
                //[strongSelf dissmissHub];
                //[strongSelf showSimpleAlertViewWithMessage:msg title:@"提示"];
            }
        }];
    }
    else
    {
        [self compeletAlert];
    }
}

#endif

- (void)compeletAlert
{
    [self keyboardHidden];
    [self restSmgBtn];
    [self dissmissHub];
    [self showSimpleInfo:@"重置密码成功"];
    ECBlockSet
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ECBlockGet(strongSelf)
        [strongSelf.navigationController popViewControllerAnimated:YES];
    });
    
}

- (void)compeletLogin
{
    [self keyboardHidden];
    [self restSmgBtn];
    [self dissmissHub];
    [self showSimpleInfo:@"密码重置成功"];
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
    self.getCode.selected = NO;
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
        [self hideKeyBoard];
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
                //        [strongSelf userLogin];
#pragma mark - Alert by WY
                [strongSelf.navigationController popViewControllerAnimated:YES];
                [strongSelf showSimpleInfo:@"重置密码成功"];
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
}




- (IBAction)getPhoneCode:(UIButton *)sender {
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
            [ECNetworkRequestManager requestPhoneLoginCodeWithMobileNO:mobile useForFunc:[NSString stringWithFormat:@"%@", FUNC_ID_DOC_FORGET_PASSWORD] callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
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
    if ([phone isValidMoblieNum] && code.length >= 4 && password.length > 0)
    {
        self.complite.enabled = YES;
    }
    else
    {
        self.complite.enabled = NO;
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
