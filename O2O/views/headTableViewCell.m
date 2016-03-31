//
//  headTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/21.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "headTableViewCell.h"
#import "goodsDetailViewController.h"

@implementation headTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

-(CGFloat)heightforcell
{
    return 240;
}

#pragma mark - private

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,merModel.smallPic];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        goodsDetailViewController* root = (goodsDetailViewController*)self.delegate;
        root.image = _iconView.image;
    }];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapheadImage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_iconView addGestureRecognizer:tap];
    
    if (merModel.salesprice.length>0) {
        _lastPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[merModel.salesprice floatValue]];
    }else
    {
        _lastPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[merModel.currentprice floatValue]];
    }
    
    
    _originalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[merModel.originalprice floatValue]];
    
    _lastPriceLabel.adjustsFontSizeToFitWidth = YES;
    _originalPriceLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([merModel.ydfs isEqualToString:@"2"]) {
        self.addShopCar.hidden = NO;
    }else
    {
        self.addShopCar.hidden = YES;
    }
    
}



-(void)setModel:(detailModel *)model
{
    
}

-(void)addDelegate:(id)delegate andAction:(SEL)action
{
    [super addDelegate:delegate andAction:action];
}

#pragma mark - xib

-(void)tapheadImage:(UITapGestureRecognizer*)tap
{
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"headImage",@"key", nil];
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:dic];
    }
}

- (IBAction)getBuy:(UIButton *)sender {
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"buy",@"key", nil];
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:dic];
    }
    
}

- (IBAction)getDetailBtn:(UIButton *)sender {
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"headImage",@"key", nil];
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:dic];
    }
    
}
- (IBAction)addShopCar:(UIButton *)sender {
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"shopcar",@"key", nil];
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:dic];
    }
    
}
@end
