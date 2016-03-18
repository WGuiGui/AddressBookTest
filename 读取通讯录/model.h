//
//  model.h
//  读取通讯录
//
//  Created by dingdaifu on 15/8/7.
//  Copyright (c) 2015年 wangzhuoqun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface model : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * telephoneNum;

// 公用方法
// 在缺少对应key的定义的情况下调用，以及一些特殊的处理也在该函数中完成
- (void)setValue:(id)value forUndefinedKey:(NSString*)key;
// 初始化方法
- (instancetype)initWithDictionary : (NSDictionary*)dict;

// 类方法-根据字典信息创建对象
+ (instancetype)instanceWithDictionary : (NSDictionary*)dict;

@end
