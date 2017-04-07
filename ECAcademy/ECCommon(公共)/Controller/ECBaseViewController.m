//
//  ECBaseViewController.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/24.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECBaseViewController.h"
#import "UIViewController+HUD.h"
#import "UIViewController+ECCommonMethods.h"
#import "UIView+CommonMethods.h"
#import "UIImage+ECExtensions.h"
@interface ECBaseViewController ()

@end

@implementation ECBaseViewController

-(instancetype)init
{
    
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
