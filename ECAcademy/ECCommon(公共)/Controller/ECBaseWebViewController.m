//
//  ECBaseWebViewController.m
//  ECDoctor
//
//  Created by Sophist on 15/8/17.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBaseWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "ECUser.h"
#import "UIViewController+ECCommonMethods.h"
@import WebKit;
//#import <WebKit/WebKit.h>

@interface ECBaseWebViewController ()<NJKWebViewProgressDelegate,WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate>
{
    NJKWebViewProgressView * _progressView;
    NJKWebViewProgress *_progressProxy;
//    WKWebView *wkWeb;
}
@property (nonatomic, strong)UIButton *toTopButton;
@end

@implementation ECBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.barTitle)
    {
        self.title = self.barTitle;
        self.isTitleNoAutoChange = YES;
    }
    [self _initWebview];
    [self _loadProcess];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    [self disablePopGesture];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    [self enablePopGesture];
}


#pragma mark - OverWrite Methods
-(void)setM_strUrl:(NSString *)m_strUrl
{
    if (_m_strUrl != m_strUrl) {
        _m_strUrl = m_strUrl;
    }
    if (_m_strUrl&&_webView) {
        NSString *url = [self.m_strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        if (kIOS8)
        {
            [((WKWebView *)_webView) loadRequest:request];
        }
        else
        {
            [((UIWebView *)_webView) loadRequest:request];
        }
        
    }
}


#pragma mark - Private Methods
-(void)_initWebview
{
    if (kIOS8)
    {
        NSString *jScript = @"";//@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'nitial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
//        @"<meta content=\"initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width\" name=\"viewport\"";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, kECScreenHeight) configuration:wkWebConfig];
        
        ((WKWebView *)_webView).allowsBackForwardNavigationGestures = YES;
        
        ((WKWebView *)_webView).UIDelegate = self;
        WKWebView *tempView = (WKWebView *)self.webView;
     // tempView.scrollView.delegate = self;
        [tempView addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];

    }
    else
    {
        self.webView = [[UIWebView alloc ] initWithFrame:CGRectMake(0, 0, kECScreenWidth, kECScreenHeight)];
        ((UIWebView *)_webView).scalesPageToFit = YES;
        ((UIWebView *)_webView).delegate = self;
      
      UIWebView *tempView = (UIWebView *)self.webView;
      // tempView.scrollView.delegate = self;
      [tempView addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    
    self.webView.backgroundColor = kECBackgroundColor;
    self.view.backgroundColor = kECBackgroundColor;
    
    if (self.m_strUrl)
    {
        NSString *url = [self.m_strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        if (kIOS8)
        {
            [((WKWebView *)_webView) loadRequest:request];
        }
        else
        {
            [((UIWebView *)_webView) loadRequest:request];
        }
        
    }
    [self.view addSubview:self.webView];
}
    //进度
- (void)_loadProcess
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    
    //WKWebView
    if (kIOS8)
    {
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    //UIWebView
    else
    {
        ((UIWebView *)_webView).delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    
    
    CGFloat progressBarHeight = 2.f;
//    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, kNavHeight - progressBarHeight - kStateBarHeight, kECScreenWidth, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.hidden = YES;
    //_progressView.backgroundColor = kECGreenColor3;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}


#pragma mark - NJKWebViewProgressDelegate AND WK_Observers
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
  if ([_progressView isHidden]) {
    _progressView.hidden = NO;
  }
  [_progressView setProgress:progress animated:YES];
    //    self.title = [self.m_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    //用代理获取点击焦点的href
    NSString* strURL = [[request.URL absoluteString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if([strURL rangeOfString:@"mfunc"].location!=NSNotFound){
        return FALSE;
    }else if ([strURL isValidMoblieNum]){
        return TRUE;
    }else if ([strURL hasPrefix:@"http"]||[strURL hasPrefix:@"HTTP"]){
        return TRUE;
    }
    
    return FALSE;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //1.获取当前页面的url
   // NSString *currentUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    
    //2.获取当前网页的title
    if (!_isTitleNoAutoChange)
    {
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = title;

    }
    
    
}


# pragma mark WK_Observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"estimatedProgress"])
    {
        if ([_progressView isHidden]) {
            _progressView.hidden = NO;
            [_progressView setProgress:0.f animated:YES];
        }
        double progress = [change[@"new"] doubleValue];
        [_progressView setProgress:progress animated:YES];
        
    }
    else if([keyPath isEqualToString:@"title"])
    {
        if (!_isTitleNoAutoChange)
        {
            self.title = change[@"new"];
        }
        
    }
    else if([keyPath isEqualToString:@"scrollView.contentOffset"])
    {
      CGPoint point = [[change objectForKey:@"new"] CGPointValue];
      if (point.y >= 50)
      {
        if (self.toTopButton == nil)
        {
          UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kECScreenWidth - 60, kECScreenHeight - 60, 50, 50)];
          btn.backgroundColor = ECColorWithRGB(0, 0, 0, 0.6);
          [btn setTitle:@"回到\n顶部" forState:UIControlStateNormal];
          [btn setTitleColor:kECWhiteColor forState:UIControlStateNormal];
          btn.layer.cornerRadius = btn.height/2;
          btn.titleLabel.font = [UIFont systemFontOfSize:13];
          btn.titleLabel.numberOfLines = 2;
          [btn addTarget:self action:@selector(goToTop:) forControlEvents:UIControlEventTouchUpInside];
          //[btn addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
          //[btn addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
          [btn.layer setMasksToBounds:YES];
          self.toTopButton = btn;
          [self.view addSubview:btn];
        }
        self.toTopButton.hidden = NO;
        //[self.view bringSubviewToFront:self.toTopButton];
      }
      else
      {
        if (self.toTopButton)
        {
          self.toTopButton.hidden = YES;
        }
      }
    }
}

- (void)goToTop:(UIButton *)sender
{
  WKWebView *tempView = (WKWebView *)self.webView;
  [tempView.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (void)dragMoving:(UIControl *)c withEvent:ev
{
  c.center = [[[ev allTouches] anyObject] locationInView:self.view];
}

- (void)dragEnded:(UIControl *)c withEvent:ev
{
  CGPoint point = [[[ev allTouches] anyObject] locationInView:self.view];
  if (point.x > self.view.width - 35)
  {
    point.x = self.view.width - 35;
  }
  else if (point.x < 35)
  {
    point.x = 35;
  }
  
  if (point.y > self.view.height - 35)
  {
    point.y = self.view.height - 35;
  }
  else if (point.y < 35+64)
  {
    point.y = 35+64;
  }
  c.center = point;
}

# pragma mark - WKWebViewDelegates
# pragma mark UIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler
{
    
    completionHandler(@"Client Not handler");
    
}

# pragma mark WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message
{
    
}

# pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //NSURLRequest *request = navigationAction.request;
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

# pragma mark - 生命周期
- (void)dealloc
{
    if ([_webView isKindOfClass:[WKWebView class]])
    {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_webView removeObserver:self forKeyPath:@"title"];
        [_webView removeObserver:self forKeyPath:@"scrollView.contentOffset"];
    }
    else if ([_webView isKindOfClass:[UIWebView class]])
    {
      [_webView removeObserver:self forKeyPath:@"scrollView.contentOffset"];
    }
    [_webView removeFromSuperview];
}


@end
