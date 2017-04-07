//
//  ECRefereeViewController.m
//  ECAcademy
//
//  Created by yellowei on 17/4/7.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECRefereeViewController.h"

@interface ECRefereeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *showNoticeBtn;
@property (weak, nonatomic) IBOutlet UITextField *textInputField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ECRefereeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐人";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
