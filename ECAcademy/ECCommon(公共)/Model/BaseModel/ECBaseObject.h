//
//  ECBaseObject.h
//  ECDoctor
//
//  Created by linsen on 15/8/21.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECBaseObject : NSObject
+ (NSArray *)getAllKeys;

+ (NSMutableArray *)objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray;

+ (instancetype)objectWithKeyValues:(id)keyValues;

- (NSMutableDictionary *)keyValues;

- (NSMutableDictionary *)keyValuesForDatabase;

- (instancetype)setKeyValues:(id)keyValues;


@end
