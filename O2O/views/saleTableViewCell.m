//
//  saleTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "saleTableViewCell.h"
#import "goodsDetailViewController.h"

@implementation saleTableViewCell

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
    _nowLabel.text = [NSString stringWithFormat:@"￥%@",merModel.salesprice];
    _nowLabel.adjustsFontSizeToFitWidth = YES;
    _oldLabel.text = [NSString stringWithFormat:@"￥%@",merModel.originalprice];
    _oldLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (IBAction)gopay:(UIButton *)sender {
    
    UIViewController* control = (UIViewController*)self.delegate;
    goodsDetailViewController* root = [[goodsDetailViewController alloc]init];
    root.model = self.merModel;
    root.commid = self.merModel.id;
    
    [control.navigationController pushViewController:root animated:YES];
    
}
@end
