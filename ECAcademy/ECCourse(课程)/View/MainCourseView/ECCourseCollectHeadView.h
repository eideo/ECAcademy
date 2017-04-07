//
//  ECCourseCollectHeadView.h
//  ECAcademy
//
//  Created by Sophist on 2017/4/6.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

typedef void (^BtnClick)(NSInteger index);
@interface ECCourseCollectHeadView : UIView

@property(nonatomic,strong)SDCycleScrollView *cycleView;

@property(nonatomic,copy)BtnClick clickBtn;

/**
 @[ECHomeItemModel,...]
 */
@property(nonatomic,strong)NSMutableArray *btnItemArrs;

@end

@interface ECHomeItemModel : ECBaseObject

@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *imageName;

ECHomeItemModel *getHomeItemModel(NSString *key,NSString *title,NSString *imageName);


@end
