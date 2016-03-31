//
//  recomTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "recomTableViewCell.h"
#import "guanggaoModel.h"
#import "goodsDetailViewController.h"

@implementation recomTableViewCell

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
    guanggaoModel* model1 = merModel.commoditys[2*self.tag];
    
    NSString* imageUrl1 = [NSString stringWithFormat:@"%@%@",HEADIMG,model1.picurl];
    [_iconView1 sd_setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _iconView1.userInteractionEnabled = YES;
    _iconView1.tag = 2*self.tag;
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapimage:)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    [_iconView1 addGestureRecognizer:tap1];
    _nameLabel1.text = model1.title;
    _currentPrc1.text = [NSString stringWithFormat:@"￥%@",model1.salesprice];
    _currentPrc1.adjustsFontSizeToFitWidth = YES;
    _oldPrc1.text = [NSString stringWithFormat:@"￥%@",model1.maketyj];
    
    
    if (merModel.commoditys.count>(2*self.tag + 1)) {
        guanggaoModel* model2 = merModel.commoditys[2*self.tag + 1];
        
        NSString* imageUrl2 = [NSString stringWithFormat:@"%@%@",HEADIMG,model2.picurl];
        [_iconview2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:[UIImage imageNamed:@"loding1"]];
        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapimage:)];
        tap2.numberOfTapsRequired = 1;
        tap2.numberOfTouchesRequired = 1;
        [_iconview2 addGestureRecognizer:tap2];
        _iconview2.userInteractionEnabled = YES;
        _iconview2.tag = 2*self.tag+1;
        _nameLabel2.text = model2.title;
        
        _currentPrc2.text = [NSString stringWithFormat:@"￥%@",model2.salesprice];
        _currentPrc2.adjustsFontSizeToFitWidth = YES;
        _oldPrc2.text = [NSString stringWithFormat:@"￥%@",model2.maketyj];
    }
    
    
    
}

-(void)tapimage:(UITapGestureRecognizer*)tap
{
    guanggaoModel* model1 = self.merModel.commoditys[tap.view.tag];
    allMerModel* model = [[allMerModel alloc]init];
    model.commodityID = model1.id;
    model.currentprice = model1.salesprice;
    model.originalprice = model1.maketyj;
    model.comName = model1.title;
    model.smallPic = model1.picurl;
    model.bigPic = model1.picurl;
    UIViewController* VC = (UIViewController*)self.delegate;
    goodsDetailViewController* root = [[goodsDetailViewController alloc]init];
    root.model = model;
    root.commid = model1.id;
    [VC.navigationController pushViewController:root animated:YES];
    
}

@end
