//
//  tabbarViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/7/16.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "tabbarViewController.h"
#import "UIColor+hexColor.h"

@interface tabbarViewController ()
{
    UIButton* _selectBtn;
}

@end

@implementation tabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self createtabber];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createtabber
{
    
    //删除现有的tabBar
    CGRect rect = self.tabBar.frame;
    
    [self.tabBar removeFromSuperview];  //移除TabBarController自带的下部的条
    
    self.backView = [[UIView alloc]init];
    self.backView.frame = rect;
    
    self.backView.tag = 10000;
    self.backView.backgroundColor = [UIColor clearColor];
//    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backView];
    
    NSArray* images = @[@"shouye",@"fenlei",@"shanghu",@"wode",@"gengduo"];
    NSArray* selecteds = @[@"shouyeed",@"fenleied",@"shanghued",@"wodeed",@"gengduoed"];
    
    for (int i = 0 ; i<5; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x        = i * self.backView.frame.size.width / 5;
        button.frame     = CGRectMake(x, 0, self.backView.frame.size.width / 5, self.backView.frame.size.height);
        button.tag       = i+10;
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selecteds[i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(tapIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backView addSubview:button];
        if (0 == i) {
            
            button.selected = YES;
            _selectBtn      = button;
            
        }
        
        if (i == 3) {
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(x, 3, 0.5, self.backView.frame.size.height-3)];
        line.backgroundColor = [UIColor colorWithHexString:@"#C4C4C4"];
        [self.backView addSubview:line];

        }
        
    }
    
}

-(void)tapIndex:(UIButton*)sender
{
//    //1.先将之前选中的按钮设置为未选中
//    _selectBtn.selected = NO;
//    //2.再将当前按钮设置为选中
//    sender.selected = YES;
//    //3.最后把当前按钮赋值为之前选中的按钮
//    _selectBtn = sender;
    
    for (int i = 0 ; i<5; i++) {
        UIButton* btn = (UIButton*)[self.backView viewWithTag:10+i];
        if (btn.tag == sender.tag) {
            sender.selected = YES;
        }else
        {
            btn.selected = NO;
        }
    }
    
    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
    self.selectedIndex = sender.tag - 10;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
