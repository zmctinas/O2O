//
//  goodsTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "goodsTableViewCell.h"
#import "UIColor+hexColor.h"

@implementation goodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.addressBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    // Configure the view for the selected state
}

-(void)addselectBtnStatestarget:(id)delegate andAction:(SEL)action
{
    _delegate = delegate;
    _action = action;
}

-(void)setModel:(adressModel *)model
{
    
    self.contentView.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
    self.contentView.layer.borderWidth = 0.5;
    _model = model;
    _nameLabel.text = model.rec_name;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _mobileLabel.text = model.phone;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@",model.road_address,model.cur_address];
    _youbianLabel.text = model.zipcode;
//    NSLog(@"%@",model.is_first);
    if ([model.is_first isEqualToString:@"1"]) {
        _addressBtn.selected = YES;
    }else
    {
        _addressBtn.selected = NO;
    }
}

- (IBAction)addressBtn:(UIButton *)sender {
    
//    sender.selected = !sender.selected;
    
    
    if ([_delegate respondsToSelector:_action]) {
        [_delegate performSelector:_action withObject:self];
    }
    
}

- (IBAction)deleteBtn:(UIButton *)sender {
    
    deleteReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[defaults objectForKey:@"uid"],@"uid",_model.id,@"id", nil];
    
    [deleteReq requestWitUrl:DELETEADDRESS_IF andArgument:dic andType:WXHTTPRequestGet];
    
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    if (request == deleteReq) {
        NSString* message = requestDic[@"message"];
        
        if ([message isEqualToString:@"1"]) {
            goodsViewController* VC = (goodsViewController*)_delegate;
            
            NSIndexPath* indexpath = [VC.tableView indexPathForCell:self];
            [VC.tableSource removeObjectAtIndex:indexpath.section];
            [VC.tableView reloadData];
        }
    }
}
@end
