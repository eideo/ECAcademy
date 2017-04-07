//
//  ECTrainListCell.h
//  ECAcademy
//
//  Created by Sophist on 2017/4/5.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^Browse)();
typedef void (^Share)();

@interface ECTrainListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *teacherLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIButton *watchBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@property(nonatomic,copy)Browse browse;
@property(nonatomic,copy)Browse share;

@end
