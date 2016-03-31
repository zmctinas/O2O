//
//  groupTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/9/15.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "groupTableViewCell.h"

@implementation groupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCoupModel:(couponModel *)coupModel
{
    _coupModel = coupModel;
    //    NSString* consume = coupModel.consume;
    //    if ([consume isEqualToString:@"N"]) {
    //        _timetyoe.text = @"下单时间:";
    //        _numLabel.hidden = YES;
    //        [_leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    //        [_rightBtn setTitle:@"评价订单" forState:UIControlStateNormal];
    //    }else
    //    {
    //        _timetyoe.text = @"消费时间:";
    //        [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    //        [_rightBtn setTitle:@"评价订单" forState:UIControlStateNormal];
    //    }
    NSString* checkinfo = coupModel.checkinfo;
    switch ([checkinfo integerValue]) {
        case 1:
            _timetyoe.text = @"下单时间:";
            _numLabel.hidden = YES;
            _typeLabel.text = [NSString stringWithFormat:@"未付款"];
            [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            break;
        case 2:
            _timetyoe.text = @"下单时间:";
            _numLabel.hidden = YES;
            _typeLabel.text = [NSString stringWithFormat:@"未使用"];
            [_leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            break;
        case 3:
            _timetyoe.text = @"消费时间:";
            _typeLabel.text = [NSString stringWithFormat:@"已使用"];
            [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"评价订单" forState:UIControlStateNormal];
            break;
        case 4:
            _timetyoe.text = @"下单时间:";
            _typeLabel.text = [NSString stringWithFormat:@"已申请"];
            [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"评价订单" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    
    
    if ([checkinfo isEqualToString:@"applyreturn"]) {
        _leftBtn.hidden = YES;
        _rightBtn.hidden = YES;
    }else
    {
        _leftBtn.hidden = NO;
        _rightBtn.hidden = NO;
    }
    
    if ([checkinfo isEqualToString:@"2"]) {
        _leftBtn.hidden = YES;
    }
    
    _nameLabel.text = coupModel.comName;
    _messageLabel.text = coupModel.descriptions;
    _totalLabel.text = [NSString stringWithFormat:@"￥%@",coupModel.salesprice];
    
    _tiemLabel.text = coupModel.create_time;
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,coupModel.smallPic];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _priceLabel.text = coupModel.groupcoupon;
    [self initleftBtn];
    
}

-(void)initleftBtn
{
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
    _leftBtn.layer.borderWidth = 0.5;
}

- (IBAction)rightBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:sender];
    }
}

- (IBAction)leftBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:sender];
    }
    
}

@end
