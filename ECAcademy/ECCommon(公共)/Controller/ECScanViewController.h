//
//  ECScanViewController.h
//  ECDoctor
//
//  Created by Fussen on 15/8/28.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@protocol ScanDelegate <NSObject>

- (void)getScan:(NSString *)strScan;

@end

@interface ECScanViewController : ECBaseViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
    NSString * strUserid;
    NSString * strPassword;
    NSDictionary* m_mdScanParams;
    NSInteger funcid;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview; //二维码生成的图层
@property (nonatomic, strong) UIImageView * line;

@property (nonatomic,assign)NSInteger  state;
@property (nonatomic,assign)BOOL isAutoBack;
@property (nonatomic,copy)NSString *noticeStr;
@property (nonatomic,assign)id<ScanDelegate>delegate;
- (void)setupCamera;

@end
