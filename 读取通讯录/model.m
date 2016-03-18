//
//  model.m
//  读取通讯录
//
//  Created by dingdaifu on 15/8/7.
//  Copyright (c) 2015年 wangzhuoqun. All rights reserved.
//

#import "model.h"

@implementation model

// 在缺少对应key的定义的情况下调用，以及一些特殊的处理也在该函数中完成
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"---undefinedKey:%@:%@", key, value);
}

// 类方法-根据字典信息创建对象
+ (instancetype)instanceWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

// 初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

@end
