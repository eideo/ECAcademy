//
//  ECCourseCollectHeadView.m
//  ECAcademy
//
//  Created by Sophist on 2017/4/6.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECCourseCollectHeadView.h"
#import "SDCycleScrollView/SDCycleScrollView.h"
@interface ECCourseCollectHeadView ()

@property(nonatomic,strong)UITableView *m_tableview;
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property(nonatomic,strong)NSMutableArray *btnArr;

@end

@implementation ECCourseCollectHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubViews];
    }
    return self;
}

#pragma mark - Private Methods
-(void)configSubViews
{
    
    


}





@end
