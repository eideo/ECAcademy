//
//  ECBindUserMobileViewController.m
//  ECDoctor
//
//  Created by 涂捷 on 16/1/14.
//  Copyright © 2016年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBindUserMobileViewController.h"
#import "ECUser.h"
#import "ECNetworkRequestManager+User.h"
@interface ECBindUserMobileViewController ()<UITextFieldDelegate>
{
    NSInteger _currentTime;
    BOOL _isSending;
    NSTimer *_myTimer;
}

@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UIButton *getCode;
//@property (nonatomic, strong)ECUser *m_user;
@property (strong, nonatomic) IBOutlet UIButton *sumbit;
@property (nonatomic, assign) BOOL isHadBindmobile;
@end

@implementation ECBindUserMobileViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = nil;
    if ([ECUser standardUser].bindmobile && [ECUser standardUser].bindmobile.length > 0)
    {
        str = @"更换手机";
        self.isHadBindmobile = YES;
    }
    else
    {
        str = @"绑定新手机";
        self.isHadBindmobile = NO;
    }
    self.title = str;
    [self.navigationItem setHidesBackButton:YES];
    self.getCode.layer.cornerRadius = 4;
    [self.getCode.layer setMasksToBounds:YES];
    
    self.sumbit.layer.cornerRadius = 4;
    [self.sumbit.layer setMasksToBounds:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    if (self.cancelBind)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:kECWhiteColor forState:UIControlStateNormal];
        [btn setTitleColor:kECBlackColor4 forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = btnItem;
        [self.navigationItem setHidesBackButton:NO];
    }
    self.view.backgroundColor = kECWhiteColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kECWhiteColor;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.cancelBind)
    {
        [self disablePopGesture];
    }
    else
    {
        if (self.isHiddenBackBtn)
        {
            [self disablePopGesture];
        }
    }
    if (self.isHadBindmobile)
    {
        self.phoneNum.text = [ECUser standardUser].bindmobile;
        self.phoneNum.enabled = NO;
        self.getCode.enabled = YES;
    }
    if (self.phoneNum.text.length != 0 || self.code.text.length != 0)
    {
        self.sumbit.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self enablePopGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBack:(id)sender
{
    if (self.cancelBind)
    {
        self.cancelBind(self);
    }
    else if (self.preViewController)
    {
        [self.navigationController popToViewController:self.preViewController animated:YES];
    }
    else
    {
        [super onBack:sender];
    }
}

- (IBAction)sumbitClick:(id)sender {
    
}

- (void)complite
{
    NSString *strCode = self.code.text;
    NSString *strbindMobile = self.phoneNum.text;
    if(strbindMobile.length < 4 || strbindMobile.length > 15)
    {
        
        [self showSimpleAlertViewWithMessage:@"手机号码格式错误" title:@"修改手机"];
        return;
    }
    if(strCode.length < 4 || strCode.length > 6)
    {
        [self showSimpleAlertViewWithMessage:@"验证码格式错误" title:@"修改手机"];
        return;
    }
    
    [self showWatingWithInfo:@"数据提交中"];
    [self restSmgBtn];
    ECBlockSet
    [ECNetworkRequestManager changePhoneNumSumbitWith:[ECUser standardUser]  mobile:strbindMobile code:strCode callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
        ECBlockGet(strongSelf1)
        if (strongSelf1)
        {
            if(code==1)
            {
                [ECUser standardUser].bindmobile = strbindMobile;
                [[ECUser standardUser] saveUser:YES];
                [ECNetworkRequestManager getUserInfoWithUser:[ECUser standardUser] callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
                    if(code==1)
                    {
                        [[ECUser standardUser] saveUser:YES];
                    }
                }];
                //请求一遍网络, 刷新user的本地数据
                {
                    ECBlockGet(strongSelf)
                    if (strongSelf)
                    {
                        NSString *str = @"";
                        if ([ECUser standardUser].bindmobile && [ECUser standardUser].bindmobile.length > 0)
                        {
                            str = @"修改手机成功";
                        }
                        else
                        {
                            str = @"绑定手机成功";
                        }
                        [strongSelf dissmissHub];
                        [strongSelf showSimpleInfo:str];
                        if (strongSelf.compliteBind)
                        {
                            strongSelf.compliteBind(self);
                        }
                    }

                
            }
            }
            else
            {
                NSString *str = @"";
                [strongSelf1 dissmissHub];
                str = [NSString stringEmptyTransform:msg];
                if (str.length == 0)
                {
                    if ([ECUser standardUser].bindmobile && [ECUser standardUser].bindmobile.length > 0)
                    {
                        str = @"修改手机号码失败";
                    }
                    else
                    {
                        str = @"绑定手机失败";
                    }
                }
                [strongSelf1 showSimpleAlertViewWithMessage:str title:@"提示"];
            }
        }
    }];
    [self hideKeyBoard];
}

- (IBAction)getPhoneCode:(UIButton *)sender {
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
            if (self.isHadBindmobile)
            {
                [ECNetworkRequestManager cancelBindingCellPhoneApplyWith:[ECUser standardUser] number:mobile callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
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
            else
            {/*
              [ECNetworkRequestManager changePhoneNumApplyWith:[ECUser standardUser] number:mobile callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
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
              }];*/
            }
        }
    }
    else
    {
        [self showSimpleAlertViewWithMessage:@"手机号码不符合要求" title:@"提示"];
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
    if ([phone isValidMoblieNum] && !_isSending)
    {
        self.getCode.enabled = YES;
    }
    else
    {
        self.getCode.enabled = NO;
    }
    if ([phone isValidMoblieNum] && code.length >= 4)
    {
        self.sumbit.enabled = YES;
    }
    else
    {
        self.sumbit.enabled = NO;
    }
}

- (IBAction)sumbitBtn:(UIButton *)sender
{
    NSString *strCode = self.code.text;
    NSString *strbindMobile = self.phoneNum.text;
    if(strbindMobile.length < 4 || strbindMobile.length > 15)
    {
        [self showSimpleAlertViewWithMessage:@"手机号码格式错误" title:@"修改手机"];
        return;
    }
    if(strCode.length < 4 || strCode.length > 6)
    {
        [self showSimpleAlertViewWithMessage:@"验证码格式错误" title:@"修改手机"];
        return;
    }
    [self showWatingWithInfo:@"数据提交中"];
    [self restSmgBtn];
    ECBlockSet
    if (self.isHadBindmobile)
    {
        [ECNetworkRequestManager cancelBindingCellPhoneWith:[ECUser standardUser] code:strCode callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
            ECBlockGet(strongSelf)
            if (code == 1)
            {
                ECUser *user = [ECUser standardUser];
                if (user)
                {
                    user.bindmobile = @"";
                    ECBindUserMobileViewController *vc = [[ECBindUserMobileViewController alloc] init];
                    vc.preViewController = strongSelf.preViewController;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
            }
            else
            {
                [strongSelf showSimpleAlertViewWithMessage:@"解除绑定失败" title:@"提示"];
            }
            [self dissmissHub];
        }];
    }
    else
    {
        [ECNetworkRequestManager changePhoneNumSumbitWith:[ECUser standardUser]  mobile:strbindMobile code:strCode callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
            ECBlockGet(strongSelf1)
            if (strongSelf1)
            {
                if(code==1)
                {
                    [ECUser standardUser].bindmobile = strbindMobile;
                    [[ECUser standardUser] saveUser:YES];
                    [ECNetworkRequestManager getUserInfoWithUser:[ECUser standardUser] callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
                        if(code==1)
                        {
                            [[ECUser standardUser] saveUser:YES];
                        }
                    }];
                    //在这里刷新user本地数据
                    {
                        ECBlockGet(strongSelf)
                        if (strongSelf)
                        {
                            NSString *str = @"";
                            if ([ECUser standardUser].bindmobile && [ECUser standardUser].bindmobile.length > 0)
                            {
                                str = @"修改手机成功";
                            }
                            else
                            {
                                str = @"绑定手机成功";
                            }
                            [strongSelf dissmissHub];
                            [strongSelf showSimpleInfo:str];
                            if (strongSelf.compliteBind)
                            {
                                strongSelf.compliteBind(self);
                            }
                        }
                    }
                    
                }
                else
                {
                    NSString *str = @"";
                    [strongSelf1 dissmissHub];
                    str = [NSString stringEmptyTransform:msg];
                    if (str.length == 0)
                    {
                        if ([ECUser standardUser].bindmobile && [ECUser standardUser].bindmobile.length > 0)
                        {
                            str = @"修改手机号码失败";
                        }
                        else
                        {
                            str = @"绑定手机失败";
                        }
                    }
                    [strongSelf1 showSimpleAlertViewWithMessage:str title:@"提示"];
                }
            }
        }];
        [self hideKeyBoard];
    }
}
@end
