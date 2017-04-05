//
//  ECLoginGuideViewController.m
//  ECDoctorBalefire
//
//  Created by linsen on 15/12/17.
//  Copyright (c) 2015年 Sophist. All rights reserved.
//

#import "ECLoginGuideViewController.h"
#import "ECLoginViewController.h"
#import "ECUser.h"
#import "ECNetworkRequestManager+User.h"
#import "AppDelegate.h"
#import "ECUserRegisterViewController.h"
#import "ECBottomPopView.h"
#import "ECBindUserMobileViewController.h"
#import "ECSetPasswordViewController.h"
#import "ECPhoneLoginController.h"
#import "UIButton+Extension.h"
#import <MJRefresh.h>

@interface ECLoginGuideViewController ()<UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *weichatBtn;
@property (nonatomic, strong)ECUser * m_user;
@property (nonatomic, strong)UITextField *m_serverAddressField;


@end

@implementation ECLoginGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self _loadScrollView];
    [self _loadSubViews];
    
    CGFloat btnWidtn = 39;
    CGFloat height_Delta = btnWidtn * (kECScreenScale - 1);
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, kECScreenHeight - 105, (kECScreenWidth-40)/2, btnWidtn)];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10 * kECScreenScale, kECScreenHeight - 105 - height_Delta, (kECScreenWidth- (20 * kECScreenScale)), btnWidtn + height_Delta)];
    [btn1 setBackgroundColor:ECColorWithHEX(0x56cc79)];
    
    CGRect frame = CGRectMake(btn1.mj_x, btn1.mj_y, btn1.width, btn1.height);
    
    [btn1 setImageTitleButtonWithFrame:frame image:[UIImage imageNamed:@"icon_wechat_white"] showImageSize:CGSizeMake(24, 24) title:@"微信登录" titleFont:[UIFont systemFontOfSize:15] imagePosition:UIImageOrientationLeft];
    [btn1 setImage:[UIImage imageNamed:@"icon_wechat_white"] forState:UIControlStateHighlighted];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(toWechatLogin:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(toWechatDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [btn1 addTarget:self action:@selector(toWechatTouchDown:) forControlEvents:UIControlEventTouchDown];
    btn1.titleLabel.font = kECDoctorFont4;
    btn1.layer.shadowColor = [kECGreenColor3 CGColor];
    btn1.layer.cornerRadius = 2.0;
    [btn1.layer setMasksToBounds:YES];
    [self.view addSubview:btn1];
    
//    btn = [[UIButton alloc] initWithFrame:CGRectMake(kECScreenWidth/2+5, kECScreenHeight - 56, (kECScreenWidth-40)/2, btnWidtn)];
    UIButton * btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10 * kECScreenScale, kECScreenHeight - 56, (kECScreenWidth- 20 * kECScreenScale), btnWidtn + height_Delta)];
    [btn2 setBackgroundColor:kECWhiteColor];
    [btn2 setTitle:@"手机号登录" forState:UIControlStateNormal];
    [btn2 setTitleColor:ECColorWithHEX(0xcccccc) forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(toLoginByPhone:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(toLoginByPhoneDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [btn2 addTarget:self action:@selector(toLoginByPhoneTouchDown:) forControlEvents:UIControlEventTouchDown];
    btn2.titleLabel.font = kECDoctorFont4;
    btn2.layer.borderWidth = 0.5f;
    btn2.layer.borderColor = ECColorWithHEX(0xcccccc).CGColor;
    btn2.layer.cornerRadius = 2.0;
    [btn2.layer setMasksToBounds:YES];
    [self.view addSubview:btn2];
    
    self.view.backgroundColor = kECClearColor;//ECColorWithHEX(0x2399A8);
    
#ifdef kTestServer
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.guideScrollView addGestureRecognizer:longPressGr];
#endif
}

- (void)dealloc
{
    DLog(@"%@ Release!!", NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.pageControl == nil)
    {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kECScreenHeight - 20 - 15 - 41 - 15, kECScreenWidth, 20)];
        self.pageControl.numberOfPages = 4;
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = ECColorWithHEX(0xeeeeee);
        self.pageControl.currentPageIndicatorTintColor = ECColorWithHEX(0x01c7b5);
        self.pageControl.enabled = NO;
        [self.view addSubview:self.pageControl];
    }
    
    //屏蔽page, 今后使用可以打开
    self.pageControl.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


#if Re

- (void)longPressToDo:(id)sender
{
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, 175)];
    showView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, 43)];
    titleLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = kECBlackColor2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"配置测试服务器地址";
    [showView addSubview:titleLabel];
    NSInteger index = 1;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kECScreenWidth, 1)];
    line.backgroundColor = kECBlackColor5;
    [showView addSubview:line];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kECScreenWidth, 75)];
    bgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [showView addSubview:bgView];
    
    if (index == 1)
    {
        UIView *logo = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 4, 15)];
        logo.backgroundColor = kECBlueColor;
        logo.layer.cornerRadius = 1;
        [bgView addSubview:logo];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, kECScreenWidth - 40, 25)];
        titleLabel.backgroundColor = kECClearColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = kECBlackColor2;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"服务器地址";
        [bgView addSubview:titleLabel];
        
        UITextField *visitContentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, kECScreenWidth - 25, 45)];
        visitContentField.textAlignment = NSTextAlignmentLeft;
        self.m_serverAddressField = visitContentField;
        visitContentField.font = [UIFont systemFontOfSize:15];
        visitContentField.textColor = kECBlackColor2;
        visitContentField.placeholder = @"请输入需要输入的回访内容";
        visitContentField.text =  kServerHostStr;
        [bgView addSubview:visitContentField];
    }
    index ++;
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), kECScreenWidth, 1)];
    line.backgroundColor = kECBlackColor5;
    [showView addSubview:line];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), kECScreenWidth, 45)];
    bgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [showView addSubview:bgView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, CGRectGetWidth(bgView.frame)/2-40, CGRectGetHeight(bgView.frame)-10)];
    [btn addTarget:self action:@selector(onSure) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:kECBlueColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [kECBlueColor CGColor];
    btn.layer.borderWidth = 1;
    [bgView addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgView.frame)/2+20, 5, CGRectGetWidth(bgView.frame)/2-40, CGRectGetHeight(bgView.frame)-10)];
    [btn addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:kECRedColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [kECRedColor CGColor];
    btn.layer.borderWidth = 1;
    [bgView addSubview:btn];
    
    [ShareView defaultShareView].customView = showView;
    [[ShareView defaultShareView] show];
}

- (void)onSure
{
    NSString *str = [NSString stringEmptyTransform:self.m_serverAddressField.text];
    [ECNetworkRequestManager configServerHostStr:str];
    [[ShareView defaultShareView] hide];
}

#endif

- (void)onCancel
{
    [[ECBottomPopView sharedECBottomPopView] hide];
}

#pragma mark - Private methods
- (void)_loadScrollView
{
    //  UIImageView *baseImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, kECScreenHeight)];
    //  baseImgView.backgroundColor = ECColorWithHEX(0xf6fffe);
    //  baseImgView.contentMode = UIViewContentModeScaleToFill;
    //  [self.view addSubview:baseImgView];
    _guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth,kECScreenHeight)];
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    _guideScrollView.showsVerticalScrollIndicator = NO;
    _guideScrollView.pagingEnabled = YES;
    _guideScrollView.delegate = self;
    [self.view addSubview:_guideScrollView];
}

- (void)_loadSubViews
{
    //nib中height设为freeForm，设置成当前屏幕大小
    self.view.height = kECScreenHeight;
    //获取图片数据
    NSMutableArray *guidesImg=[NSMutableArray arrayWithCapacity:4];
    //获取图片名字
    for (int i=0; i<1 ; i++) {
        NSString *guideImg=[NSString stringWithFormat:@"login_guide_logo_%zd", i];
        [guidesImg addObject:guideImg];
    }
    NSArray *bgColors = @[ECColorWithHEX(0xf6fffe),ECColorWithHEX(0xedfff5),ECColorWithHEX(0xf3fbff),ECColorWithHEX(0xfffaf4)];
    //设置图片视图的大小和设置图片内容
    for (int i=0; i<guidesImg.count; i++) {
        //guide图片
        UIView *imgView=[[UIView alloc]initWithFrame:CGRectMake(kECScreenWidth*i , 0,kECScreenWidth,kECScreenHeight)];
        imgView.backgroundColor = bgColors[i];
        imgView.userInteractionEnabled = YES;
        [self.guideScrollView addSubview:imgView];
        
        UIImageView *titleView = [[UIImageView alloc]initWithFrame:CGRectMake((kECScreenWidth-277)/2 , 40,277,48.5)];
        titleView.image=[UIImage imageNamed:@"zi"];
        //[imgView addSubview:titleView];
        
//        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake((kECScreenWidth-203)/2 ,104*kECScreenHeight/568, 203, 283)];
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:imgView.bounds];
        
        iconView.image=[UIImage imageNamed:guidesImg[i]];
        [imgView addSubview:iconView];
    }
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(-kECScreenWidth , 0,kECScreenWidth,kECScreenHeight)];
    [self.guideScrollView addSubview:imgView];
    
    imgView=[[UIImageView alloc]initWithFrame:CGRectMake(kECScreenWidth*4, 0,kECScreenWidth,kECScreenHeight)];
    [self.guideScrollView addSubview:imgView];
    //滑动视图的内容大小
    self.guideScrollView.contentSize=CGSizeMake(kECScreenWidth*guidesImg.count, 0);
    
    //屏蔽滑动, 今后使用可以打开
    self.guideScrollView.scrollEnabled = NO;
    
    
}

# pragma mark - 手机验证码登录

- (void)toLoginByPhone:(UIButton *)btn
{
    [btn setBackgroundColor:kECWhiteColor];
    
    ECPhoneLoginController * logVc = [[ECPhoneLoginController alloc] initWithNibName:@"ECPhoneLoginController" bundle:nil];
    logVc.title = @"手机号快捷登录";
    
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
    
    ECLoginViewController * logVc=[[ECLoginViewController alloc] initWithNibName:@"ECLoginViewController" bundle:nil];
    //  ECUserRegisterViewController *logVc = [[ECUserRegisterViewController alloc] initWithNibName:@"ECUserRegisterViewController" bundle:nil];
    ECBlockSet
    logVc.loginSuccess = ^(){
        ECBlockGet(strongSelf)
        if (strongSelf.loginSuccess)
        {
            strongSelf.loginSuccess();
        }
    };
    logVc.finishLogin = ^(BOOL isSuccess){
        ECBlockGet(strongSelf)
        if (strongSelf)
        {
            if (strongSelf.finishLogin)
            {
                strongSelf.finishLogin(isSuccess);
            }
        }
    };
    
    [self.navigationController pushViewController:logVc animated:YES];
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
        ECBindUserMobileViewController *vc = [[ECBindUserMobileViewController alloc] initWithNibName:@"ECBindUserMobileViewController" bundle:nil];
        //vc.isHiddenBackBtn = YES;
        //        if (password.length == 0 || needToAddClinic)
        //        {
        //            vc.rightNavBtnTitle = @"下一步";
        //        }
        vc.compliteBind = ^(ECBindUserMobileViewController *controller){
            ECBlockGet(strongSelf1)
            [strongSelf1 compeletLogin];
        };
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

#pragma mark - UIScrollView delegate
//滑动显示主界面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0)
    {
        self.pageControl.currentPage = 0;
        self.view.backgroundColor = ECColorWithHEX(0xf6fffe);
    }
    else if (scrollView.contentOffset.x == kECScreenWidth)
    {
        self.pageControl.currentPage = 1;
    }
    else if (scrollView.contentOffset.x == kECScreenWidth*2)
    {
        self.pageControl.currentPage = 2;
    }
    else if (scrollView.contentOffset.x >= kECScreenWidth*3)
    {
        self.pageControl.currentPage = 3;
        self.view.backgroundColor = ECColorWithHEX(0xfffaf4);
    }
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
