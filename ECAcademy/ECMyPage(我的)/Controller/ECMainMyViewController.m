//
//  ECMainMyViewController.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/24.
//  Copyright © 2017年 dentalink. All rights reserved.
//

//Controllers
#import "ECMainMyViewController.h"

//Views

//Models

//Tools

@interface ECMainMyViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headerImgView;

@property (weak, nonatomic) IBOutlet UIButton *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *seeMsgBtn;


@end

@implementation ECMainMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

# pragma mark - Events
- (IBAction)onHeaderImgViewClick:(id)sender
{
    NSLog(@"daf");
}

- (IBAction)onSeeMsgBtnClick:(UIButton *)sender
{
    
}




# pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat scale = kECScreenWidth / 320.f;
    switch (section)
    {
        case 0:
        {
            switch (row)
            {
                case 0:
                {
                    return 210.f * scale;
                }
                    break;
                    
                default:
                    return 45.f * scale;
                    break;
            }
        }
            break;
            
        default:
            return 45.f * scale;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
        {
            switch (row)
            {
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (row)
            {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (row)
            {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (row)
            {
                case 0:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}


@end
