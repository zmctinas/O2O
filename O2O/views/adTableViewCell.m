//
//  adTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/5/29.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "adTableViewCell.h"
#import "goodsDetailViewController.h"

@implementation adTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessages:(NSMutableArray *)messages
{
    [super setMessages:messages];
    
    NSDictionary* dic = messages[self.tag];
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,dic[@"picurl"]];
    [_guanggao sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_guanggao addGestureRecognizer:tap];
    
}

-(void)tapImage:(UITapGestureRecognizer*)tap
{
    UIViewController* VC = (UIViewController*)self.delegate;
    goodsDetailViewController* root = [[goodsDetailViewController alloc]init];
    NSDictionary* dic = self.messages[self.tag];
    root.commid = dic[@"goods_id"];
    allMerModel* model = [[allMerModel alloc]init];
    model.smallPic = dic[@"picurl"];
    root.model = model;
    [VC.navigationController pushViewController:root animated:YES];
}

@end
