//
//  cateTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "cateTableViewCell.h"

@implementation cateTableViewCell
{
    
}

- (void)awakeFromNib {
    // Initialization code
    
    [FrameSize MLBFrameSize:self];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _numLabel.layer.borderWidth = 0.5;
    _numLabel.layer.borderColor = [UIColor colorWithHexString:@"#F2F2F2"].CGColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    [self initcell];
}

-(void)initcell
{
    [_select setBackgroundImage:[UIImage imageNamed:@"radio2.png"] forState:UIControlStateSelected];
    [_select setBackgroundImage:[UIImage imageNamed:@"radio1.png"] forState:UIControlStateNormal];

    
}

-(void)setCarModel:(carComModel *)carModel
{
    _carModel = carModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMG,carModel.picurl]] placeholderImage:[UIImage imageNamed:@"loding1"]];
    _nameLabel.text = carModel.title;
    _numLabel.text = carModel.num;
    _numLabel.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    _numLabel.layer.borderWidth = 1;
    _messageLabel.text = carModel.attrs;
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",carModel.salesprice];
    
    _select.selected = carModel.isSelect;
    
}



- (IBAction)numBtn:(UIButton *)sender {
    NSInteger num = [self.numLabel.text integerValue];
    if (sender.tag == 10) {
        if (![self.numLabel.text isEqualToString:@"1"]) {
            
            num --;
        }
    }else
    {
        num++;
    }
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:self.carModel.uid,@"uid",@"update",@"act",self.carModel.carid,@"array_id",[NSString stringWithFormat:@"%ld",num],@"num", nil];
    
    [HTTPRequest requestWitUrl:EXITSHOPCAR_IF andArgument:dic andType:WXHTTPRequestGet Finished:^(NSURLResponse *response, NSDictionary *requestDic) {
        
        if ([requestDic[@"message"]isEqualToString:@"1"]) {
            [WXalertView alertWithMessage:@"修改成功" andDelegate:self];
        }else
        {
            [WXalertView alertWithMessage:@"修改失败" andDelegate:self];
        }
    } Falsed:^(NSError *error) {
        [WXalertView alertWithMessage:@"修改失败" andDelegate:self];
    }];
    
}

- (IBAction)deleteBtn:(UIButton *)sender {
    
    
    
}

- (IBAction)selectBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.carModel.isSelect = sender.selected;
    
    
}
@end
