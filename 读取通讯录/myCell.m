//
//  myCell.m
//  读取通讯录
//
//  Created by dingdaifu on 15/8/7.
//  Copyright (c) 2015年 wangzhuoqun. All rights reserved.
//

#import "myCell.h"
#import "model.h"

@implementation myCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setMyModel:(model *)myModel
{
    _myModel = myModel;
    self.name.text = myModel.name;
    self.telephone.text = myModel.telephoneNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
