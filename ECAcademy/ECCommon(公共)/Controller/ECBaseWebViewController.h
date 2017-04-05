//
//  ECBaseWebViewController.h
//  ECDoctor
//
//  Created by Sophist on 15/8/17.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBaseViewController.h"
#import "ECUser.h"

@interface ECBaseWebViewController : ECBaseViewController<UIWebViewDelegate>

@property (nonatomic,strong)UIView * webView;

@property (nonatomic,copy)NSString *m_strUrl;

@property (nonatomic,copy) NSString *barTitle;

@property (nonatomic, assign) BOOL isTitleNoAutoChange;

@end
