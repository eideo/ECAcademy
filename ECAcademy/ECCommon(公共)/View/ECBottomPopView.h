//
//  ECBottomPopView.h
//  ECAcademy
//
//  Created by Sophist on 2017/3/31.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickShade)();
typedef void (^actionCallBack)(NSString *actionTitle);

@class ECBottomPopView;
@protocol ShareViewDelegate <NSObject>

@optional
- (void)onShareViewHide:(ECBottomPopView *)shareView;
- (void)onShareViewShow:(ECBottomPopView *)shareView;

- (void)shareViewHideComplete:(ECBottomPopView *)shareView;
- (void)shareViewShowComplete:(ECBottomPopView *)shareView;

@end

@interface ECBottomPopView : UIView

singleton_interface(ECBottomPopView)
@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UIView *shadeView;

@property(nonatomic,strong)UIView *customView;

@property(nonatomic,copy)clickShade clickShade;

@property(nonatomic,weak)id<ShareViewDelegate> delegate;

+ (void)showActionViewWithTitle:(NSString *)title actionTitles:(NSArray *)actionTitles cancelTitle:(NSString *)cancelTitle actionCallBack:(actionCallBack)callBack;
-(void)show;
-(void)hide;


@end
