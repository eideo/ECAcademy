//
//  ECTrainListCell.m
//  ECAcademy
//
//  Created by Sophist on 2017/4/5.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECTrainListCell.h"
#import "UIButton+Extension.h"
@implementation ECTrainListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self configSubViews];
    
}

-(void)configSubViews
{
    self.imgView.frame = CGRectMake(0, 0, self.width, self.width/2.f);
    self.shareBtn.right = self.width - 5.f;
    [self.watchBtn setImageTitleButtonWithFrame:CGRectMake(self.shareBtn.left - 60, self.shareBtn.top, 60, self.shareBtn.height) image:[UIImage imageNamed:@"icon_academy_watch"] showImageSize:CGSizeMake(18, 18) title:@"1000" titleFont:kECDoctorFont2 imagePosition:UIImageOrientationLeft];
    
}


- (IBAction)watchAction:(UIButton *)sender {
    if (self.browse) {
        self.browse();
    }
}

- (IBAction)shareAction:(UIButton *)sender {
    if (self.share) {
        self.share();
    }
}

@end
