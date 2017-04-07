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
