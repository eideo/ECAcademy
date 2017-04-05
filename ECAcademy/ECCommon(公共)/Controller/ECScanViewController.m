//
//  ECScanViewController.m
//  ECDoctor
//
//  Created by Fussen on 15/8/28.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECScanViewController.h"
#import "PhotoPickerController.h"
#import "UIButton+Extension.h"

@interface ECScanViewController ()<UIAlertViewDelegate, PhotoPickerControllerDelegate>
@property (nonatomic, strong)UIImage *qrcodeImage;
@property (nonatomic, strong)NSString *qrcodeValue;
@property (nonatomic, strong)UIButton *openFlashLightBtn;
@property (nonatomic)BOOL isShowAlbum;
@end
#define kScanRectOfInterest CGRectMake(40, (kECScreenHeight - kECScreenWidth+80)/2, kECScreenWidth-80, kECScreenWidth-80)//164
#define kScanExtendedLengthValue    10.0
@implementation ECScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"扫描二维码";
    self.view.frame = CGRectMake(0, 0, kECScreenWidth, kECScreenHeight);
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //UIImageView *backImageView = [[UIImageView alloc] initWithImage:[self backgroundImage]];
    //[self.view addSubview:backImageView];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kECScreenWidth, 64)];
    [navView setBackgroundColor:kECClearColor];
    navView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:navView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kECScreenWidth, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.text = @"扫描二维码";
    titleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:titleLabel];
    
    //    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    backBtn.frame = CGRectMake(0, 20, 60, 44);
    //    backBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 14);
    //    [backBtn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    //    [backBtn setImage:[UIImage imageNamed:@"btn_navi_return_title"] forState:UIControlStateNormal];
    //    //[backBtn setImage:[UIImage imageNamed:@"scan_back_icon"] forState:UIControlStateNormal];
    //    [navView addSubview:backBtn];
    
    UIView *baseView = [UIButton customBackButtonWithTarget:self action:@selector(onBack)];//[ECCommenMethod customBackImage:nil title:nil target:self action:@selector(onBack)];
    [navView addSubview:baseView];
    
    UIButton *picture = [UIButton buttonWithType:UIButtonTypeCustom];
    picture.frame = CGRectMake((kECScreenWidth - 60)/2, 20, 60, 44);
    picture.imageEdgeInsets = UIEdgeInsetsMake(4, 12, 4, 12);
    [picture addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    //[backBtn setImage:[UIImage imageNamed:@"btn_navi_return_title"] forState:UIControlStateNormal];
    [picture setImage:[UIImage imageNamed:@"scan_picture_icon"] forState:UIControlStateNormal];
    //[navView addSubview:picture];
    
    UIButton *flashLight = [UIButton buttonWithType:UIButtonTypeCustom];
    flashLight.frame = CGRectMake(kECScreenWidth - 70, 20, 60, 44);
    flashLight.imageEdgeInsets = UIEdgeInsetsMake(4, 14, 4, 10);
    [flashLight addTarget:self action:@selector(closeFlashlight) forControlEvents:UIControlEventTouchUpInside];
    //[backBtn setImage:[UIImage imageNamed:@"btn_navi_return_title"] forState:UIControlStateNormal];
    [flashLight setImage:[UIImage imageNamed:@"scan_flash_light_icon"] forState:UIControlStateSelected];
    [flashLight setImage:[UIImage imageNamed:@"scan_flash_light_open_icon"] forState:UIControlStateNormal];
    self.openFlashLightBtn = flashLight;
    //[navView addSubview:flashLight];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(kScanRectOfInterest)-3, CGRectGetMinY(kScanRectOfInterest) - 3, 21.5, 21.5)];
    tempImageView.tintColor = kECGreenColor2;
    tempImageView.image = [UIImage imageNamed:@"icon_scan_lt"];
    [self.view addSubview:tempImageView];
    
    tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(kScanRectOfInterest)+ 3 - 21.5, CGRectGetMinY(kScanRectOfInterest) - 3, 21.5, 21.5)];
    tempImageView.tintColor = kECGreenColor2;
    tempImageView.image = [UIImage imageNamed:@"icon_scan_rt"];
    [self.view addSubview:tempImageView];
    
    tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(kScanRectOfInterest)- 3, CGRectGetMaxY(kScanRectOfInterest) + 3 - 21.5, 21.5, 21.5)];
    tempImageView.tintColor = kECGreenColor2;
    tempImageView.image = [UIImage imageNamed:@"icon_scan_ld"];
    [self.view addSubview:tempImageView];
    
    tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(kScanRectOfInterest)+ 3 - 21.5, CGRectGetMaxY(kScanRectOfInterest) + 3 - 21.5, 21.5, 21.5)];
    tempImageView.tintColor = kECGreenColor2;
    tempImageView.image = [UIImage imageNamed:@"icon_scan_rd"];
    [self.view addSubview:tempImageView];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(kScanRectOfInterest.origin.x, kScanRectOfInterest.origin.y, kScanRectOfInterest.size.width , 9)];
    _line.image = [UIImage imageNamed:@"scan_move_line"];
    //_line.backgroundColor = kECGreenColor2;
    [self.view addSubview:_line];
    
    UILabel *noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(kScanRectOfInterest)+10, kECScreenWidth - 20, 40)];
    noticeLab.backgroundColor = [UIColor clearColor];
    noticeLab.textColor = [UIColor whiteColor];
    noticeLab.font = [UIFont systemFontOfSize:15];
    noticeLab.textAlignment = NSTextAlignmentCenter;
    noticeLab.text = self.noticeStr;
    noticeLab.numberOfLines = 0;
    [self.view addSubview:noticeLab];
    
    // Do any additional setup after loading the view from its nib.
}

- (UIView *)navBackImage:(UIImage *)backImg title:(NSString *)title
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 80, 44)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    [backBtn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backImg forState:UIControlStateNormal];
    [baseView addSubview:backBtn];
    if (title)
    {
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(14, 15, 14, 35)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 40, 44)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kECWhiteColor;
        label.backgroundColor = kECClearColor;
        label.text = title;
        label.font = [UIFont systemFontOfSize:17];
        [baseView addSubview:label];
    }
    else
    {
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 22)];
    }
    return baseView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self hideNavgationBar];
    //[self.navigationController setNavigationBarHidden:YES];
    [self setupCamera];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    AVCaptureFlashMode modle = _device.flashMode;
    if (modle != AVCaptureFlashModeOn)
    {
        self.openFlashLightBtn.selected = NO;
    }
    else
    {
        self.openFlashLightBtn.selected = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isShowAlbum)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    [timer setFireDate:[NSDate distantFuture]];
    [timer invalidate];
    [self.preview removeFromSuperlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)backgroundImage
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0.0,0.0,0.0,0.4);
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect drawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    CGContextFillRect(ctx, drawRect);   //draw the transparent layer
    drawRect = kScanRectOfInterest;
    CGContextClearRect(ctx, drawRect);  //clear the center rect  of the layer
    UIImage* returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnimage;
}

-(void)closeFlashlight
{
    if (_device.flashAvailable)
    {
        AVCaptureTorchMode torch = AVCaptureTorchModeOff;
        AVCaptureFlashMode modle = _device.flashMode;
        if (modle != AVCaptureFlashModeOn)
        {
            modle = AVCaptureFlashModeOn;
            torch = AVCaptureTorchModeOn;
            self.openFlashLightBtn.selected = YES;
        }
        else
        {
            modle = AVCaptureFlashModeOff;
            torch = AVCaptureTorchModeOff;
            self.openFlashLightBtn.selected = NO;
        }
        [_device lockForConfiguration:nil];
        [_device setFlashMode:modle];
        [_device setTorchMode:torch];
        [_device unlockForConfiguration];
    }
    else
    {
        [self showSimpleInfo:@"设备闪光灯不可用"];
    }
}

-(void)openAlbum
{
    PhotoPickerController *imagePickerController = [[PhotoPickerController alloc] initWithNibName:nil bundle:nil];
    imagePickerController.title = @"本地相册";
    imagePickerController.maxImageCount = 1;
    [imagePickerController setDelegate:(id<PhotoPickerControllerDelegate>)self];
    imagePickerController.filterType = pickerFilterTypeAllPhotos;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    //self.view.backgroundColor = kECWhiteColor;
    self.isShowAlbum = YES;
    [self presentViewController:navigationController animated:YES completion:^{
        self.view.backgroundColor = kECClearColor;
        self.isShowAlbum = NO;
    }];
}

- (void)onBack
{
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    [timer setFireDate:[NSDate distantFuture]];
    [timer invalidate];
    if (self.navigationController)
    {
        [self popViewController];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)animation1
{
    CGRect rect = _line.frame;
    if (upOrdown == NO)
    {
        num ++;
        rect.origin.y = kScanRectOfInterest.origin.y + 2*num;
        _line.frame = rect;
        // _line.center = CGPointMake(imageView.center.x, kScanRectOfInterest.origin.y + 2*num);
        if (2*num >= kScanRectOfInterest.size.height-9)
        {
            upOrdown = YES;
        }
    }
    else
    {
        num --;
        rect.origin.y = kScanRectOfInterest.origin.y + 2*num;
        _line.frame = rect;
        //_line.center=CGPointMake(imageView.center.x, 164+2*num);
        if (num <= 0) {
            upOrdown = NO;
        }
    }
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode 模拟器这么写会挂掉 真机测试则不会
    if([_output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
    {
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        // Preview
        //上左下右
        //[_output setRectOfInterest:CGRectMake((CGRectGetMinY(kScanRectOfInterest) - kScanExtendedLengthValue)/kECScreenHeight, (CGRectGetMinX(kScanRectOfInterest) - kScanExtendedLengthValue)/ kECScreenWidth , (CGRectGetMaxY(kScanRectOfInterest) + kScanExtendedLengthValue)/kECScreenHeight , (CGRectGetMaxX(kScanRectOfInterest) + kScanExtendedLengthValue)/ kECScreenWidth)];
        [_output setRectOfInterest:CGRectMake((CGRectGetMinY(kScanRectOfInterest) - kScanExtendedLengthValue)/kECScreenHeight, (CGRectGetMinX(kScanRectOfInterest) - kScanExtendedLengthValue)/ kECScreenWidth , (CGRectGetHeight(kScanRectOfInterest) + 2*kScanExtendedLengthValue)/kECScreenHeight , (CGRectGetWidth(kScanRectOfInterest) + 2*kScanExtendedLengthValue)/ kECScreenWidth)];
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = CGRectMake(0, 0, kECScreenWidth, kECScreenHeight);
        
        [self.view.layer insertSublayer:self.preview atIndex:0];
        // Start
        [_session startRunning];
        
        upOrdown = NO;
        num =0;
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
    else
    {
        [self showSimpleAlertViewWithMessage:@"不支持扫描" title:@"提示"];
        self.view.backgroundColor = kECWhiteColor;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"不支持扫描"])
    {
        if (self.navigationController)
        {
            [self popViewController];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

#pragma mark 照片处理
/*-(void)getInfoWithImage:(UIImage *)img{
 self.qrcodeImage = img;
 if (img && [img isKindOfClass:[UIImage class]])
 {
 ECBlockSet
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 ECBlockGet(strongSelf)
 if (strongSelf && strongSelf.qrcodeImage)
 {
 UIImage *loadImage= strongSelf.qrcodeImage;
 CGImageRef imageToDecode = loadImage.CGImage;
 ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
 ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
 NSError *error = nil;
 ZXDecodeHints *hints = [ZXDecodeHints hints];
 ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
 ZXResult *result = [reader decode:bitmap
 hints:hints
 error:&error];
 
 if (result)
 {
 NSString *contents = result.text;
 NSLog(@"相册图片contents == %@",contents);
 strongSelf.qrcodeValue = contents;
 }
 else
 {
 strongSelf.qrcodeValue = @"";
 }
 dispatch_async(dispatch_get_main_queue(), ^{
 ECBlockGet(strongSelf2)
 if (strongSelf2)
 {
 if (strongSelf2.qrcodeValue.length > 0)
 {
 [strongSelf2 compliteScan:strongSelf2.qrcodeValue];
 }
 else
 {
 [strongSelf2 showSimpleInfo:@"解析失败"];
 }
 }
 });
 }
 });
 }
 else
 {
 [self showSimpleInfo:@"读取二维码图片失败"];
 }
 
 }
 */
- (void)compliteScan:(NSString *)strValue
{
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    [timer setFireDate:[NSDate distantFuture]];
    [timer invalidate];
    if (_isAutoBack)
    {
        
    }
    else
    {
        if (self.parentViewController)
        {
            [self popViewController];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getScan:)])
    {
        [self.delegate getScan:strValue];
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString*   strValue = nil;
    if ([metadataObjects count] >0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        strValue = metadataObject.stringValue;
    }
    NSLog(@"___%@",strValue);
    [self compliteScan:strValue];
}

#pragma mark - PhotoPickerControllerDelegate;
- (void)photoPickerController:(PhotoPickerController *)controller
   didFinishPickingWithImages:(NSArray *)images
{
    if (images.count > 0)
    {
        //NSDictionary *dic = images[0];
        //UIImage *tempImage = dic[@"IMG"];
        //[self getInfoWithImage:tempImage];
    }
    else
    {
        [self showSimpleInfo:@"读取二维码图片失败"];
    }
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
