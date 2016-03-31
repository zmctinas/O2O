//
//  cardViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/23.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "cardViewController.h"
#import "recordViewController.h"
#import "balanceViewController.h"
#import "rechargeViewController.h"
#import "explainViewController.h"

@interface cardViewController ()
{
    NSUserDefaults* defaults;
}


@property(strong,nonatomic)UILabel* label;

@property (weak, nonatomic) IBOutlet UIView *switchView;

@property (weak, nonatomic) IBOutlet UIButton *onBtn;

@property (weak, nonatomic) IBOutlet UIButton *offBtn;

- (IBAction)switchBtn:(UIButton *)sender;

- (IBAction)explain:(UIButton *)sender;

- (IBAction)pay:(UIButton *)sender;

- (IBAction)balance:(UIButton *)sender;

- (IBAction)payrecord:(UIButton *)sender;

- (IBAction)userecord:(UIButton *)sender;

@end

@implementation cardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    [_offBtn setBackgroundImage:[UIImage imageNamed:@"radio-red"] forState:UIControlStateSelected];
    
    [_onBtn setBackgroundImage:[UIImage imageNamed:@"radio-red"] forState:UIControlStateSelected];
    
    _iconView.layer.cornerRadius = 3;
    _iconView.layer.masksToBounds = YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL isUse = [defaults boolForKey:@"usePassword"];
    if (isUse) {
        _onBtn.selected = YES;
        _offBtn.selected = NO;
    }else
    {
        _offBtn.selected = YES;
        _onBtn.selected = NO;
    }
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}



#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"我的会员卡";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


#pragma mark - xib

- (IBAction)switchBtn:(UIButton *)sender {
    
    
    if (sender.tag == 10) {
        NSString* payWord = [defaults objectForKey:@"paypassword"];
        if (payWord.length>0) {
            [defaults setBool:YES forKey:@"usePassword"];
            [defaults synchronize];
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请设置支付密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
    }else
    {
        [defaults setBool:NO forKey:@"usePassword"];
        [defaults synchronize];
    }
    
    sender.selected = YES;
    NSArray* arr = [_switchView subviews];
    for (UIButton* btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag != sender.tag) {
                btn.selected = NO;
            }
        }
    }
    
    
}

- (IBAction)explain:(UIButton *)sender {
    
    explainViewController* root = [[explainViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
}

- (IBAction)pay:(UIButton *)sender {
    
    
    balanceViewController* root = [[balanceViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
}

- (IBAction)balance:(UIButton *)sender {
    
    rechargeViewController* root = [[rechargeViewController alloc]init];
    [self.navigationController pushViewController:root animated:YES];
    
    
}

- (IBAction)payrecord:(UIButton *)sender {
    
    recordViewController* root = [[recordViewController alloc]init];
    root.recordType = WXCreditRecordPay;
    [self.navigationController pushViewController:root animated:YES];
    
}
- (IBAction)userecord:(UIButton *)sender {
    
    recordViewController* root = [[recordViewController alloc]init];
    root.recordType = WXCreditRecordUse;
    [self.navigationController pushViewController:root animated:YES];
    
}
@end
