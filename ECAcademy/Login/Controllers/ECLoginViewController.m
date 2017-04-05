//
//  ECLoginViewController.m
//  ECDoctor
//
//  Created by linsen on 15/9/21.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECLoginViewController.h"
#import "ECUser.h"
#import "ECNetworkRequestManager+User.h"
#import "AppDelegate.h"
#import "ECUserRegisterViewController.h"
#import "ECForgetPasswordViewController.h"
#import "ECScanViewController.h"
#import "ECBindUserMobileViewController.h"
#import "ECSetPasswordViewController.h"


@interface ECLoginViewController ()<UITextFieldDelegate>//, ScanDelegate>
{
    BOOL isFirst;
}

@property (strong, nonatomic) ECUser *m_user;
@property (strong, nonatomic) IBOutlet UITextField *m_usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *m_passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *showPasswordBtn;
@property (strong, nonatomic) IBOutlet UIButton *userLoginBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (strong, nonatomic) IBOutlet UIView *navBarView;
@property (strong, nonatomic) ECBaseNavController *theShowNavController;
@property (strong, nonatomic) IBOutlet UIButton *wechatLoginBtn;

@end

@implementation ECLoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //  [self hideNavgationBar];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    isFirst = YES;
    [self.showPasswordBtn setImage:[UIImage imageNamed:@"see_password_selected"] forState:UIControlStateSelected];
    [self.showPasswordBtn setImage:[UIImage imageNamed:@"see_password"] forState:UIControlStateNormal];
    
    [self.userLoginBtn setBackgroundImage:[UIImage imageNamed:@"bg_blue_color1"] forState:UIControlStateDisabled];
    [self.userLoginBtn setBackgroundImage:[UIImage imageNamed:@"bg_blue_color2"] forState:UIControlStateNormal];
    [self.userLoginBtn setBackgroundImage:[UIImage imageNamed:@"bg_blue_color3"] forState:UIControlStateHighlighted];
    [self.userLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.userLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.userLoginBtn.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navBarView.backgroundColor = [UIColor colorWithPatternImage:kECGreenImage2];
    
      ECUser *user = [ECUser lastLoginUser];
      if (user)
      {
        NSString *userName = [NSString stringEmptyTransform:user.loginUserName];
        if (userName.length > 4)
        {
          self.m_usernameTextField.text = [NSString stringEmptyTransform:user.loginUserName];
          self.userLoginBtn.enabled = YES;
        }
      }
      else
      {
        self.wechatLoginBtn.hidden = YES;
      }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //  [self.navigationController setNavigationBarHidden:YES];
    //  [self hideNavgationBar];
    //  self.isHideNavbar = YES;
    if (isFirst)
    {
        self.bgScrollView.frame = CGRectMake(0, 0, kECScreenWidth, kECScreenHeight);
        self.bgScrollView.contentSize = CGSizeMake(0, 400);
        [self setBGScrollViewHeight:kECScreenHeight];
        [self.bgScrollView setUserInteractionEnabled:YES];
        isFirst = NO;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgetPassword:(id)sender {
    
    ECForgetPasswordViewController *vc = [[ECForgetPasswordViewController alloc] initWithNibName:@"ECForgetPasswordViewController" bundle:nil];
    ECBlockSet
    vc.finishLogin = ^(BOOL finish){
        ECBlockGet(strongSelf)
        if (strongSelf && finish)
        {
            strongSelf.finishLogin(finish);
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)toWechatLogin:(id)sender
{
    if ([AppDelegate sendAuthRequest])
    {
        [self hideKeyBoard];
        AppDelegate * delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        ECBlockSet
        delegate.Appdelegateblock=^(NSDictionary * infoDic){
            ECBlockGet(strongSelf)
//            if (strongSelf.m_user == nil)
            {
                strongSelf.m_user = [[ECUser alloc] init];
            }
            strongSelf.m_user.loginType = UserLoginTypeOfWeCat;
            strongSelf.m_user.otherLoginData = infoDic;
            [strongSelf userLogin];
        };
    }
}

- (IBAction)registerTempUser:(id)sender {
    /*
     return;
     NSString *str = [NSString stringFromDate:[NSDate date]];
     str = [str replaceCharcter:@"-" withCharcter:@""];
     str = [str replaceCharcter:@" " withCharcter:@""];
     str = [str replaceCharcter:@":" withCharcter:@""];
     ECBlockSet
     [ECNetworkRequestManager registerTempUserWithUserName:str callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
     ECBlockGet(strongSelf)
     NSString *string = returnObject[@"username"];
     strongSelf.m_usernameTextField.text = string;
     strongSelf.userLoginBtn.enabled = YES;
     }];*/
}

- (IBAction)showPasswordClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.m_passwordTextField.secureTextEntry = !sender.selected;
    [self.m_passwordTextField becomeFirstResponder];
}

- (IBAction)onBack:(id)sender {
    [self keyboardHidden];
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)onUsernameLogin:(id)sender {
    NSString *userName = [NSString stringEmptyTransform:self.m_usernameTextField.text];
    NSString *password = [NSString stringEmptyTransform:self.m_passwordTextField.text];
    if (userName.length == 0)
    {
        [self showSimpleAlertViewWithMessage:@"登录用户名不能为空哦" title:@"提示"];
    }
    else
    {
        //if (self.m_user == nil)
        {
            self.m_user = [[ECUser alloc] init];
        }
        self.m_user.loginUserName = userName;
        self.m_user.loginUserPassword = password;
        self.m_user.loginType = UserLoginTypeOfCommon;
        [self userLogin];
    }
    
}


- (IBAction)onLoginWithQRCode:(id)sender {
    ECScanViewController * scanVc=[[ECScanViewController alloc]initWithNibName:@"ECScanViewController" bundle:nil];
    scanVc.delegate = self;
    scanVc.noticeStr = @"将PC端登录医生二维码图像置于矩形方框内，系统会自动识别。";
    [self.navigationController pushViewController:scanVc animated:YES];
}


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
                ECBlockGet(strongSelf)
                [strongSelf dissmissHub];
                if (code == 1)
                {
                    [strongSelf showSimpleInfo:@"登录成功"];
                    //使用默认登录，开启定时器开始接收问诊数据
                    [strongSelf compeletLogin];
                    
                    //          [self tcIMLoginWithCallback:^{
                    //
                    //          } fail:^(int code, NSString *msg) {
                    //
                    //          }];
                }
                else
                {
                    [strongSelf showSimpleAlertViewWithMessage:msg title:@"提示"];
                }
            }];
        });
        
    }
}


- (void)compeletLogin
{
    [self keyboardHidden];
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
    else
    {
        if (self.loginSuccess)
        {
            self.loginSuccess();
        }
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



- (void)keyboardHidden
{
    [self.m_passwordTextField resignFirstResponder];
    [self.m_usernameTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldChanged:(NSNotification *)notification
{
    NSString *str = [NSString stringEmptyTransform:self.m_usernameTextField.text];
    if (str.length > 4)
    {
        self.userLoginBtn.enabled = YES;
    }
    else
    {
        self.userLoginBtn.enabled = NO;
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
                     }
                     completion:^(BOOL finished){
                         if (self.bgScrollView.contentSize.height > self.bgScrollView.height)
                         {
                             self.bgScrollView.scrollEnabled = YES;
                             [self.bgScrollView setContentOffset:CGPointMake(0, self.bgScrollView.contentSize.height - CGRectGetHeight(self.bgScrollView.frame)) animated:YES];
                         }
                         else
                         {
                             self.bgScrollView.scrollEnabled = NO;
                         }
                     }
     ];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y < -0.2)
    {
        [self hideKeyBoard];
    }
}

#pragma mark - ScanDelegate
- (void)getScan:(NSString *)strScan
{
    if (strScan.length > 0)
    {
        //if (self.m_user == nil)
        //    {
        //      self.m_user = [[ECUser alloc] init];
        //    }
        //    self.m_user.loginQRCodeString = strScan;
        //    self.m_user.loginType = UserLoginTypeOfQRCode;
        //    [self userLogin];
    }
    else
    {
        [self showSimpleAlertViewWithMessage:@"无效二维码" title:@"提示"];
    }
}

@end
