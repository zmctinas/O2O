//
//  credetTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/5/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "credetTableViewCell.h"
#import "goodsViewController.h"
#import "credetialViewController.h"

@implementation credetTableViewCell
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)changeLabelFrame
{
    
    
    CGRect rect = [self.merModel.descriptions boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    CGRect labelFrame = self.messageLabel.frame;
    
    labelFrame.size.height = rect.size.height;
    self.messageLabel.frame = labelFrame;
    
    self.numBackView.frame = CGRectMake(self.numBackView.frame.origin.x, self.messageLabel.frame.origin.y+self.messageLabel.frame.size.height+10, self.numBackView.frame.size.width, self.numBackView.frame.size.height);
    
}

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    self.messageLabel.text = merModel.descriptions;
    
    [_shangBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    
    [_songBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    _timedescriptions.text = merModel.timedsc;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
//    [self performSelector:@selector(changeLabelFrame) withObject:nil afterDelay:0.1];
}

-(CGFloat)heightforcell
{
    CGRect rect = [self.model.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    CGFloat HH = rect.size.height - 20;
    return HH;
}

-(void)addDelegate:(id)delegate andAction:(SEL)action
{
    [super addDelegate:delegate andAction:action];
}

-(void)changeLabel
{
    _xiaojieLabel.text = [NSString stringWithFormat:@"%ld积分",[self.merModel.integral integerValue]*[_numLabel.text integerValue]];
    [defaults setInteger:[_numLabel.text integerValue] forKey:@"intNum"];
    [defaults synchronize];
}

- (IBAction)selectBtn:(UIButton *)sender {
    
    sender.selected = YES;
    if (sender.tag == 10) {
        [defaults setObject:@"1" forKey:@"isMoren"];
        [defaults synchronize];
    }else
    {
        [defaults setObject:@"2" forKey:@"isMoren"];
        [defaults synchronize];
    }
    
    for (int i = 0 ; i<2; i++) {
        UIButton* btn = (UIButton*)[self.contentView viewWithTag:10+i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    
}

- (IBAction)numBtn:(UIButton *)sender {
    
    NSInteger num = [_numLabel.text integerValue];
    if (sender.tag == 20) {
        if (num>0) {
            num--;
        }
    }else
    {
        NSInteger inte = [[defaults objectForKey:@"integral"] integerValue]/[self.merModel.integral integerValue];
        
        NSInteger max = MIN( inte,self.merModel.num);
        if (num<max) {
            num++;
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"积分或库存不足" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
    }
    _numLabel.text = [NSString stringWithFormat:@"%ld",num];
    [self changeLabel];
}

- (IBAction)changeAddress:(UIButton *)sender {
    
    __weak credetialViewController* root = self.delegate;
    goodsViewController* goods = [[goodsViewController alloc]init];
    [root.navigationController pushViewController:goods animated:YES];
}
@end
