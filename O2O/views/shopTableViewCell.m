//
//  shopTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/13.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "shopTableViewCell.h"
#import "credetialViewController.h"
#import "goodsDetailViewController.h"
#import "loginViewController.h"

@implementation shopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setMessages:(NSArray *)messages
{
    
    [super setMessages:messages];
    NSInteger num = messages.count>3?3:messages.count;
    for (int i = 0 ; i< num; i++) {
        NSDictionary* dic = messages[i];
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,dic[@"smallPic"]];
        UIImageView* imageView = (UIImageView*)[self.contentView viewWithTag:i+30];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
        imageView.userInteractionEnabled = YES;
        UILabel* nameLabel = (UILabel*)[self.contentView viewWithTag:10+i];
        nameLabel.text = dic[@"comName"];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetail:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        
        if (self.index == 2) {
            UILabel* price = (UILabel*)[self.contentView viewWithTag:20+i];
            price.text = [NSString stringWithFormat:@"%@积分",dic[@"integral"]];
        }else
        {
            UILabel* price = (UILabel*)[self.contentView viewWithTag:20+i];
            price.text = [NSString stringWithFormat:@"￥%@",dic[@"currentprice"]];
        }
        
    }
    
}

-(void)tapDetail:(UITapGestureRecognizer*)tap
{
    NSDictionary* dic = self.messages[tap.view.tag - 30];
    allMerModel* model = [[allMerModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    model.id = dic[@"commodityID"];
    UIViewController* VC = (UIViewController*)self.delegate;
    if (self.index == 2) {
        
        
        
        NSString* uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
        if (uid == nil) {
            
            loginViewController* login = [[loginViewController alloc]init];
            [VC.navigationController pushViewController:login animated:YES];
            
            return;
        }
        
        credetialViewController* root = [[credetialViewController alloc]init];
        root.model = model;
        root.inteID = model.commodityID;
        [VC.navigationController pushViewController:root animated:YES];
    }else
    {
        goodsDetailViewController* root = [[goodsDetailViewController alloc]init];
        
        model.commodityID = dic[@"id"];
        model.id = dic[@"id"];
        NSLog(@"%@",dic[@"id"]);
        model.salesprice = dic[@"currentprice"];
        model.currentprice = dic[@"currentprice"];
        
        root.model = model;
        root.commid = model.commodityID;
        
        [VC.navigationController pushViewController:root animated:YES];
    }
    
}

@end
