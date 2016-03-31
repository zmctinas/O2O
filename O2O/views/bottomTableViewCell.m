//
//  bottomTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/5/12.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "bottomTableViewCell.h"

@implementation bottomTableViewCell
{
    NSInteger maxnum;
    NSInteger minnum;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}

#pragma mark - setter

-(void)setModel:(attModel *)model
{
    _model = model;
    
    self.nameLabel.text = _model.attrs;
    
    maxnum = [model.housenum integerValue];
    
    if (_model.num.length>0) {
        self.numLabel.text = _model.num;
    }else
    {
        self.numLabel.text = @"0";
    }
    
    _numLabel.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    _numLabel.layer.borderWidth = 1;
    
}

- (IBAction)numBtn:(UIButton *)sender {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSInteger num = [_numLabel.text integerValue];
    
    [dic setValue:@"btn" forKey:@"key"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.tag] forKey:@"row"];
    
    if (sender.tag == 11) {
        if (num < maxnum) {
            [dic setValue:@"plus" forKey:@"action"];
            num++;
        }
        
    }else
    {
        
        if (num > minnum) {
            num --;
            [dic setValue:@"minus" forKey:@"action"];
        }
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    NSString* action = dic[@"action"];
    if (action) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changenum" object:self userInfo:dic];
    }
    
}
@end
