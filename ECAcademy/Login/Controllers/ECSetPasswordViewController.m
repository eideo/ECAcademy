//
//  ECSetPasswordViewController.m
//  ECDoctor
//
//  Created by 涂捷 on 16/1/13.
//  Copyright © 2016年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECSetPasswordViewController.h"
//#import "ECUser.h"
//#import "ECNetworkRequestManager+User.h"
@interface ECSetPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)NSMutableArray *textFieldArray;
@property (nonatomic)ECSetPasswordViewControllerType m_type;
@property (nonatomic, strong)UIButton *compliteBtn;
@property (nonatomic, strong)UITextField * currentTextField;
@end

@implementation ECSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  if ([[ECUser standardUser] password].length > 0)
    //  {
    //    self.m_type = ECSetPasswordViewControllerTypeOfAlert;
    //  }
    //  else
    //  {
    //    self.m_type = ECSetPasswordViewControllerTypeOfSet;
    //  }
    
    NSString *rightTitle = self.rightNavBtnTitle;
    if (rightTitle.length == 0)
    {
        rightTitle = @"完成";
    }
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:kECBlackColor4 forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    self.compliteBtn = btn;
    [self customNavRightViews:@[btn]];
    [self.navigationItem setHidesBackButton:YES];
    
    NSArray *titleArr = nil;
    if (self.m_type == ECSetPasswordViewControllerTypeOfSet)
    {
        self.title = @"设置密码";
        titleArr = @[@"请输入密码", @"重复输入密码"];
    }
    else
    {
        self.title = @"修改密码";
        titleArr = @[@"请输入原始密码", @"请输入新密码", @"重复输入新密码"];
    }
    self.textFieldArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.view.backgroundColor = kECBackgroundColor;
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kECScreenWidth, 50*titleArr.count)];
    tempView.backgroundColor = kECBackgroundColor;
    [self.view addSubview:tempView];
    for (int i = 0 ; i < titleArr.count; i++)
    {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, kECScreenWidth, 50)];
        bg.backgroundColor = kECWhiteColor;
        [tempView addSubview:bg];
        
        UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kECScreenWidth-10, 49.5)];
        textfield.placeholder = titleArr[i];
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.backgroundColor = kECClearColor;
        textfield.secureTextEntry = YES;
        //textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.keyboardType = UIKeyboardTypeDefault;
        //    UIKeyboardAppearanceDark
        //  textfield.keyboardAppearance = UIKeyboardAppearanceDefault;
        if (i > 0)
        {
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            textfield.keyboardAppearance = UIKeyboardAppearanceDefault;
        }
        
        textfield.returnKeyType = UIReturnKeyDone;
        textfield.delegate = self;
        [bg addSubview:textfield];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kECScreenWidth - 40, 5, 40, 40)];
        [btn setImage:[UIImage imageNamed:@"see_password"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"see_password_selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        btn.tag = i;
        [bg addSubview:btn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 49.5, kECScreenWidth, 0.5)];
        line.backgroundColor = kECBlackColor5;
        [bg addSubview:line];
        
        if (i == titleArr.count - 1)
        {
            line.left = 0;
        }
        
        if (i == 0)
        {
            line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, 0.5)];
            line.backgroundColor = kECBlackColor5;
            [bg addSubview:line];
        }
        [self.textFieldArray addObject:textfield];
    }
}

#if Re
- (void)complite
{
    [self hideKeyBoard];
    NSString *newPassword = nil;
    if (self.m_type == ECSetPasswordViewControllerTypeOfAlert)
    {
        NSString *oldPassword = [NSString stringEmptyTransform:[[ECUser standardUser] password]];
        NSString *old = nil;
        NSString *new1 = nil;
        NSString *new2 = nil;
        if ([self.textFieldArray count] > 0)
        {
            UITextField *field = [self.textFieldArray objectAtIndex:0];
            old = [NSString stringEmptyTransform:field.text];
            if (oldPassword.length > 0)
            {
                if (![[ECNetworkRequestManager md5HexDigest:old] isEqualToString:oldPassword])
                {
                    _currentTextField = field;
                    [self showSimpleAlertViewWithMessage:@"原始密码输入有误" title:@"提示"];
                    return;
                }
            }
        }
        if ([self.textFieldArray count] > 1)
        {
            UITextField *field = [self.textFieldArray objectAtIndex:1];
            _currentTextField = field;
            new1 = [NSString stringEmptyTransform:field.text];
            if (new1.length == 0)
            {
                [self showSimpleAlertViewWithMessage:@"新密码不能为空" title:@"提示"];
                return;
            }
            else if (new1.length < 6 || new1.length > 16)
            {
                [self showSimpleAlertViewWithMessage:@"请保证设置密码长度为6-16位" title:@"提示"];
                return;
            }
        }
        if ([self.textFieldArray count] > 2)
        {
            UITextField *field = [self.textFieldArray objectAtIndex:2];
            _currentTextField = field;
            new2 = [NSString stringEmptyTransform:field.text];
            if (![new1 isEqualToString:new2])
            {
                [self showSimpleAlertViewWithMessage:@"新密码输入不一致" title:@"提示"];
                return;
            }
        }
        newPassword = new1;
    }
    else
    {
        NSString *new1 = nil;
        NSString *new2 = nil;
        if ([self.textFieldArray count] > 0)
        {
            UITextField *field = [self.textFieldArray objectAtIndex:0];
            _currentTextField = field;
            new1 = [NSString stringEmptyTransform:field.text];
            if (new1.length == 0)
            {
                [self showSimpleAlertViewWithMessage:@"新密码不能为空" title:@"提示"];
                return;
            }
        }
        if ([self.textFieldArray count] > 1)
        {
            UITextField *field = [self.textFieldArray objectAtIndex:1];
            new2 = [NSString stringEmptyTransform:field.text];
            _currentTextField = field;
            if (![new1 isEqualToString:new2])
            {
                [self showSimpleAlertViewWithMessage:@"新密码输入不一致" title:@"提示"];
                return;
            }
        }
        /*
         if (new1.length == 0 || new2.length == 0 || ![new1 isEqualToString:new2])
         {
         if (new1.length == 0 && new2.length == 0)
         {
         [self showSimpleAlertViewWithMessage:@"新密码不能为空" title:@"提示"];
         }
         else
         {
         [self showSimpleAlertViewWithMessage:@"新密码输入不一致" title:@"提示"];
         }
         return;
         }
         */
        newPassword = new1;
    }
    if (newPassword.length > 0)
    {
        ECBlockSet
        [self showWatingWithInfo:@"数据提交中"];
        [ECNetworkRequestManager alertUserPasswordAndUserNameWith:[ECUser standardUser] password:newPassword username:nil callback:^(NSInteger code, NSString *msg, NSError *error, id returnObject) {
            ECBlockGet(strongSelf)
            [strongSelf dissmissHub];
            if (code == 1)
            {
                [strongSelf showSimpleInfo:@"修改密码成功"];
                if (strongSelf.complete)
                {
                    strongSelf.complete(self);
                }
                else
                {
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES ];
                }
            }
            else
            {
                if (msg.length == 0)
                {
                    msg = @"修改密码失败";
                }
                [strongSelf showSimpleAlertViewWithMessage:msg title:@"提示"];
            }
        }];
    }
}

#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)seePassword:(UIButton *)sender
{
    BOOL bl = sender.selected;
    bl = !bl;
    sender.selected = bl;
    if (sender.tag < self.textFieldArray.count)
    {
        UITextField * textfield = self.textFieldArray[sender.tag];
        textfield.secureTextEntry = !bl;
        [textfield becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isHiddenBackBtn)
    {
        self.navigationItem.leftBarButtonItem = nil;
        [self disablePopGesture];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isHiddenBackBtn)
    {
        [self disablePopGesture];
    }
    if ([self.textFieldArray count] > 0)
    {
        UITextField *field = [self.textFieldArray firstObject];
        [field becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self enablePopGesture];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_currentTextField && [_currentTextField isKindOfClass:[UITextField class]])
    {
        [_currentTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
