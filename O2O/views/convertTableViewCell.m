//
//  convertTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "convertTableViewCell.h"
#import "credetialViewController.h"

@implementation convertTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,merModel.smallPic];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _nameLabel.text = merModel.comName;
    _timeLabel.text = [NSString stringWithFormat:@"%@开始",merModel.timedsc];
    _messageLabel.text = [NSString stringWithFormat:@"限量%@份，不支持退货",merModel.numdsc];
    _creditLabel.text = [NSString stringWithFormat:@"%@积分",merModel.integral];
    
    
}

- (IBAction)rightNow:(UIButton *)sender {
    
    UIViewController* VC = (UIViewController*)self.delegate;
    
    credetialViewController* root = [[credetialViewController alloc]init];
    
    
    root.model = self.merModel;
    [VC.navigationController pushViewController:root animated:YES];
    
}
@end
