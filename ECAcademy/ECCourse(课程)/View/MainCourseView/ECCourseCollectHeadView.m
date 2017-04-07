//
//  ECCourseCollectHeadView.m
//  ECAcademy
//
//  Created by Sophist on 2017/4/6.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "ECCourseCollectHeadView.h"


#define kBannerHeight 140.f
//#define kBannerHeight 140.f
@interface ECCourseCollectHeadView ()

@property(nonatomic,strong)UITableView *m_tableview;

@property(nonatomic,strong)NSMutableArray *btnArr;

@property(nonatomic,strong)UIView *baseItemView;
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

#pragma mark - Overwrite Methods
-(void)setBtnItemArrs:(NSMutableArray *)btnItemArrs
{
    if (_btnItemArrs != btnItemArrs) {
        _btnItemArrs = btnItemArrs;
    }
    [self configBtns];
}

#pragma mark - Private Methods
-(void)configSubViews
{
    CGFloat bottomHeight = self.height - kBannerHeight;
    _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kECScreenWidth,kBannerHeight) imageNamesGroup:@[@"banner_bg",@"banner_bg2",@"banner_bg",@"banner_bg2"]];
    [self addSubview:_cycleView];
    
    _baseItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, bottomHeight)];

    [self addSubview:_baseItemView];
}

-(void)configBtns
{
    CGFloat bottomHeight = self.height - kBannerHeight;
    if (_baseItemView) {
        for (UIView *subView in _baseItemView.subviews) {
            [subView removeFromSuperview];
        }
        NSInteger count = _btnItemArrs.count;
        CGFloat gap = 10.f;
        CGFloat itemWidth = (self.width - gap * (count + 1))/count;
        for (NSInteger i = 0; i <count ; i++) {
            
            UIButton *btn = [UIButton imageTitleButtonWithFrame:CGRectMake(gap+(itemWidth+gap)*i, 0, itemWidth,bottomHeight) image:[UIImage imageNamed:@""] showImageSize:CGSizeMake(0, 0) title:@"" titleFont:[UIFont systemFontOfSize:12.f] imagePosition:UIImageOrientationUp buttonType:UIButtonTypeSystem];
            
            
            [_baseItemView addSubview:btn];
        }
        
    }

}



@end

@implementation ECHomeItemModel
ECHomeItemModel *getHomeItemModel(NSString *key,NSString *title,NSString *imageName)
{

    ECHomeItemModel *model = [[ECHomeItemModel alloc] init];
    model.key = key;
    model.title = title;
    model.imageName = imageName;
    return model;
}


@end
