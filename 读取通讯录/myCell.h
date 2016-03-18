//
//  myCell.h
//  读取通讯录
//
//  Created by dingdaifu on 15/8/7.
//  Copyright (c) 2015年 wangzhuoqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class model;

@interface myCell : UITableViewCell

@property (nonatomic, strong) model * myModel;

@property (nonatomic, weak) IBOutlet UILabel * name;
@property (nonatomic, weak) IBOutlet UILabel * telephone;


@end
