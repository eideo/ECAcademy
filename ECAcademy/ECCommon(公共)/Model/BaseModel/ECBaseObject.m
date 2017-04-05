//
//  ECBaseObject.m
//  ECDoctor
//
//  Created by linsen on 15/8/21.
//  Copyright (c) 2015年 EasyCloud Health Co.,Ltd. All rights reserved.
//

#import "ECBaseObject.h"
#import "MJExtension.h"

@implementation ECBaseObject


+ (NSArray *)getAllKeys
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

+ (NSMutableArray *)objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

+ (instancetype)objectWithKeyValues:(id)keyValues
{
    return [self mj_objectWithKeyValues:keyValues];
}

- (instancetype)init
{
  self = [super init];
  return self;
}

- (NSMutableDictionary *)keyValues
{
    return [self mj_keyValues];
}

- (instancetype)setKeyValues:(id)keyValues
{
    return [self mj_setKeyValues:keyValues];
}

- (NSMutableDictionary *)keyValuesForDatabase
{
  NSMutableDictionary *dict = [self mj_keyValues];
  NSArray *array = [dict allKeys];
  for (NSString *key in array)
  {
    NSString *value = dict[key];
    if (value && [value isKindOfClass:[NSString class]] && value.length > 0 && [value containsString:@"'"])
    {
      value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
      [dict setObject:value forKey:key];
    }
  }
  return dict;
}


- (void)objectDetailInfo
{
  NSLog (@"class %@", NSStringFromClass([self class]));
  unsigned int count;
  //获取属性列表
  objc_property_t *propertyList = class_copyPropertyList([self class], &count);
  for (unsigned int i=0; i<count; i++) {
    const char *propertyName = property_getName(propertyList[i]);
    NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
  }
  
  //获取方法列表
  Method *methodList = class_copyMethodList([self class], &count);
  for (unsigned int i; i<count; i++) {
    Method method = methodList[i];
    NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
  }
  
  //获取成员变量列表
  Ivar *ivarList = class_copyIvarList([self class], &count);
  for (unsigned int i; i<count; i++) {
    Ivar myIvar = ivarList[i];
    const char *ivarName = ivar_getName(myIvar);
    NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
  }
  
  //获取协议列表
  __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
  for (unsigned int i; i<count; i++) {
    Protocol *myProtocal = protocolList[i];
    const char *protocolName = protocol_getName(myProtocal);
    NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
  }
  NSLog (@"class %@ end", NSStringFromClass([self class]));
}

@end
