//
//  ECSettingTableController.m
//  ECAcademy
//
//  Created by yellowei on 17/4/6.
//  Copyright © 2017年 dentalink. All rights reserved.
//

//Controllers
#import "ECSettingTableController.h"

//Views

//Models

//Tools
#import "FileService.h"
#import "HWSandbox.h"


@interface ECSettingTableController ()<UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@property (weak, nonatomic) IBOutlet UISwitch *onlyWifiPlaySwitch;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation ECSettingTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    ECBlockSet
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * cachePath = [HWSandbox libCachePath];
        CGFloat cacheSize = [FileService folderSizeAtPath:cachePath];
        weakSelf.cacheLabel.text = [NSString stringWithFormat:@"%.2f M", cacheSize];
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f * kECScreenHeight / 568.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10.f;
    }
    return 0.01f;
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
                case 0:
                {
                    //账号安全
                }
                    break;
                case 1:
                {
                    //账号绑定
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            //只在WIFI网络播放视频
        }
            break;
        case 2:
        {
            switch (row)
            {
                case 0:
                {
                    //推送设置
                }
                    break;
                case 1:
                {
//                    清除缓存
                    ECBlockSet
                    NSString *message = @"您确定要清除缓存数据吗?";
                    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1)
                        {
                            [weakSelf showWatingWithInfo:@"正在清理中"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    NSString * cachePath = [HWSandbox libCachePath];
                                    [FileService clearCache:cachePath];
                                    CGFloat cacheSize = [FileService folderSizeAtPath:cachePath];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        weakSelf.cacheLabel.text = [NSString stringWithFormat:@"%.2f M", cacheSize];
                                        [weakSelf dissmissHub];
                                    });
                                });
                            });
                        }
                    }];
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
                    //软件升级
                }
                    break;
                case 1:
                {
                    //关于
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

# pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 4001)
    {
        if(1 == buttonIndex)
        {
            
            ECBlockSet
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showWatingWithInfo:@"正在清理中"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString * cachePath = [HWSandbox libCachePath];
                    [FileService clearCache:cachePath];
                    CGFloat cacheSize = [FileService folderSizeAtPath:cachePath];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.cacheLabel.text = [NSString stringWithFormat:@"%.2f M", cacheSize];
                        [weakSelf dissmissHub];
                    });
                });
            });
           
        }
    }
}

@end
