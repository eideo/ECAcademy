//
//  ECBottomPopView.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/31.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECBottomPopView.h"
@interface ECBottomPopView()
@property (nonatomic, copy)actionCallBack m_callBack;
@end
@implementation ECBottomPopView
singleton_implementation(ECBottomPopView)

+ (void)showActionViewWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles cancelTitle:(NSString *)cancelTitle actionCallBack:(actionCallBack)callBack
{
    ECBottomPopView *view = [ECBottomPopView sharedECBottomPopView];
    [view setCustomView:[view actionViewWithTitle:title actionTitles:actionTitles cancelTitle:cancelTitle actionCallBack:callBack]];
    [view show];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    //增加监听，当键盘出现时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册监听 ，当键盘消失时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return self;
}

#pragma mark - OverWrite Methods
-(void)setCustomView:(UIView *)customView
{
    if (_customView && [_customView superview])
    {
        [_customView removeFromSuperview];
    }
    if (_customView != customView)
    {
        _customView = customView;
    }
    if(_customView)
    {
        [self _initCustomView];
    }
}

#pragma mark - Private Methods
-(void)_initSubViews
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheShade)];
    
    
    _shadeView = [[UIView alloc] initWithFrame:self.bounds];
    _shadeView.alpha = 0.0;
    _shadeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self addSubview:_shadeView];
    [_shadeView addGestureRecognizer:tap];
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kECScreenHeight, kECScreenWidth , 120)];
    
    [self addSubview:_bottomView];
}


-(void)_initCustomView
{
    _bottomView.frame = _customView.bounds;
    _bottomView.top = kECScreenHeight;
    [_bottomView addSubview:_customView];
}

- (UIView *)actionViewWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles cancelTitle:(NSString *)cancelTitle actionCallBack:(actionCallBack)callBack
{
    CGFloat titleHeight = 40;
    CGFloat btnHeight = 50;
    CGFloat cancelBtnHeight = 52;
    CGFloat spacingHeight = 8;
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, titleHeight*(title.length > 0)+btnHeight*actionTitles.count + (cancelTitle.length > 0)*(cancelBtnHeight+spacingHeight))];
    baseView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    if (title.length > 0)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(baseView.frame), titleHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0x88/255.0 green:0x88/255.0 blue:0x88/255.0 alpha:1.0] forState:UIControlStateNormal];
        [baseView addSubview:btn];
    }
    
    for (NSInteger i = 0; i < [actionTitles count]; i++)
    {
        NSString *title = [NSString stringWithFormat:@"%@", actionTitles[i]];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*btnHeight + 0.5 + titleHeight*(title.length > 0), CGRectGetWidth(baseView.frame), btnHeight - 0.5)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
    }
    
    if (cancelTitle.length > 0)
    {
        NSString *title = [NSString stringWithFormat:@"%@", cancelTitle];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, actionTitles.count*btnHeight + spacingHeight + titleHeight*(title.length > 0), CGRectGetWidth(baseView.frame), cancelBtnHeight)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0x1a/255.0 green:0x1a/255.0 blue:0x1a/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
    }
    self.m_callBack = callBack;
    return baseView;
}

- (void)actionBtnClick:(UIButton *)btn
{
    if (self.m_callBack)
    {
        self.m_callBack(btn.titleLabel.text);
    }
    [self hide];
}

#pragma mark - Public Methods
- (void)show
{
    if (_delegate && [_delegate respondsToSelector:@selector(onShareViewShow:)])
    {
        [_delegate onShareViewShow:self];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _shadeView.alpha = 1.0;
        _bottomView.top = kECScreenHeight - _bottomView.height;
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(shareViewShowComplete:)])
        {
            [_delegate shareViewShowComplete:self];
        }
    }];
    
}

- (void)hide
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onShareViewHide:)])
    {
        [_delegate onShareViewHide:self];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _shadeView.alpha = 0.0;
        _bottomView.top = kECScreenHeight;
    } completion:^(BOOL finished) {
        if (_delegate && [_delegate respondsToSelector:@selector(shareViewHideComplete:)])
        {
            [_delegate shareViewHideComplete:self];
        }
        
        if (_delegate)
        {
            _delegate = nil;
        }
    }];
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:0.2];
}

-(void)clickTheShade
{
    if (_clickShade) {
        _clickShade();
    }
    [self hide];
}

//键盘将要出现
- (void)_keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary * userInfo=[notification userInfo];
    CGRect  keyboardRect=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSTimeInterval animationDuration=[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    CGRect bound=self.bounds;
    bound.origin.y+=keyboardRect.size.height;
    if(bound.origin.y>keyboardRect.size.height){
        bound.origin.y=keyboardRect.size.height;
    }
    
    self.bounds=bound;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}



//键盘将要消失
- (void)_keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"%@",notification);
    
    NSDictionary * userInfo=[notification userInfo];
    
    NSTimeInterval animationDuration=[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect bound = self.bounds;
    bound.origin.y = 0;
    self.bounds = bound;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
    
}



@end
