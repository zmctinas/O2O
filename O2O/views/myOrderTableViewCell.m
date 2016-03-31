//
//  myOrderTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/24.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "myOrderTableViewCell.h"
#import "evaluateViewController.h"
#import "UIColor+hexColor.h"

@implementation myOrderTableViewCell

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
            [_rightBtn setTitle:@"评价订单" forState:UIControlStateNormal];
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
    
    _nameLabel.text = coupModel.comName;
    _messageLabel.text = coupModel.descriptions;
    _totalLabel.text = [NSString stringWithFormat:@"￥%@",coupModel.salesprice];
    
    _tiemLabel.text = coupModel.create_time;
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,coupModel.smallPic];
    [_iconVIew sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _priceLabel.text = coupModel.groupcoupon;
    [self initleftBtn];

}

-(void)setOrderModel:(orderModel *)orderModel
{
    _orderModel = orderModel;
//    NSInteger act = [orderModel.act integerValue];
//    switch (act) {
//        case 1:
//            _typeLabel.text = @"等待付款";
//            [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//            [_rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
//            
//            break;
//        case 2:
//            _typeLabel.text = @"待发货";
//            [_leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//            [_rightBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
//            break;
//        case 3:
//            _typeLabel.text = @"已发货";
//            [_leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
//            [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//            
//            break;
//        case 4:
//            _typeLabel.text = @"交易成功";
//            [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
//            [_rightBtn setTitle:@"评价订单" forState:UIControlStateNormal];
//            
//            break;
//        
//        
//            
//        default:
//            break;
//    }
    
//    if (act<=4&& act!= 3&&act!=2) {
//        _leftBtn.hidden = NO;
//        _rightBtn.hidden = NO;
//    }else if (act == 3||act == 2)
//    {
//        _rightBtn.hidden = NO;
//        _leftBtn.hidden = YES;
//    }
//    else
//    {
//        _leftBtn.hidden = YES;
//        _rightBtn.hidden = YES;
//    }
    
//    if () {
//        
//    }else
//    {
//        _leftBtn.hidden = NO;
//    }
    
    
    [self initleftBtn];
    [self setdate];
}

-(void)initleftBtn
{
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
    _leftBtn.layer.borderWidth = 0.5;
}

-(void)setdate
{
    _tiemLabel.text = _orderModel.posttime;
//    _typeLabel.text = _orderModel.checkinfo;
    _typeLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = _orderModel.title;
//    NSData* data = [_orderModel.attrstrs dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@",dic);
    _messageLabel.text = _orderModel.attrstrs;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_orderModel.salesprice];
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _numLabel.text = [NSString stringWithFormat:@"x%@",_orderModel.gnum];
    _totalLabel.text = [NSString stringWithFormat:@"￥%@",_orderModel.totmoney];
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,_orderModel.picurl];
    [_iconVIew sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
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

-(void)addDelegate:(id)delegate andAction:(SEL)action
{
    [super addDelegate:delegate andAction:action];
}

@end
