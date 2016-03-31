//
//  evaluateViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/5/5.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "evaluateViewController.h"
#import "insertImage.h"


@interface evaluateViewController ()<HTTPRequestDataDelegate,UITextViewDelegate>
{
    HTTPRequest* commentReq;
    NSUserDefaults* defaults;
    NSString* messages;
}

@property (weak, nonatomic) IBOutlet insertImage *imagePicker;

@property (weak, nonatomic) IBOutlet commentStar *star;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet insertImage *imagecontent;

- (IBAction)addComment:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong,nonatomic)UILabel* label;

@end

@implementation evaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagePicker.delegate = self;
    
    self.navigationItem.titleView = self.label;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self initmessage];
    
    [self.scrollView setContentSize:CGSizeMake(0, 460)];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}

#pragma mark - private

-(void)initmessage
{
    if (_selectType == 1) {
        _salePrice.text =_model.salesprice;
        _nameLabel.text = _model.title;
        _descriptionLabel.text = _model.attrstrs;
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,_model.picurl];
        [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    }else
    {
        _salePrice.text =_couModel.salesprice;
        _nameLabel.text = _couModel.comName;
        _descriptionLabel.text = _couModel.descriptions;
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,_couModel.smallPic];
        [_iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loding1"]];
    }
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    NSString* message = requestDic[@"message"];
    if ([message isEqualToString:@"1"]) {
        messages = @"评论成功";
        [self showalert];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([message isEqualToString:@"2"])
    {
        messages = @"评论失败";
        [self showalert];
    }else if ([message isEqualToString:@"3"])
    {
        messages = @"内容不可为空";
        [self showalert];
    }
}

-(void)showalert
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messages delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}


#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"订单评论";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark - xib

- (IBAction)addComment:(UIButton *)sender {
    
    NSString* uid = [defaults objectForKey:@"uid"];
    
    if (_star.currentStar<=0) {
        messages = @"请评价星级";
        [self showalert];
        return;
    }
    
    NSString* pictures = @"";
    
    for (int i = 0 ;i< _imagePicker.images.count;i++) {
        UIImage* image = _imagePicker.images[i];
        if (i>0) {
            pictures = [NSString stringWithFormat:@"%@,",pictures];
        }
        NSString* str = [UIImageJPEGRepresentation(image,0.4) base64EncodedStringWithOptions:0];
        pictures = [pictures stringByAppendingString:str];
    }
    
    commentReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    
    NSString* gid = nil;
    NSString* orderid = nil;
    NSString* ordernum = nil;
    NSDictionary* dic = nil;
    if (_couModel) {
        gid = _couModel.goods_id;
        orderid = _couModel.groupcoupon;
        dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",gid,@"gid",_textView.text,@"content",[NSNumber numberWithInteger:_star.currentStar],@"score",orderid,@"ordernum",pictures,@"pictures", nil];
    }else
    {
        gid = _model.gid;
        orderid = _model.id;
        ordernum = _model.ordernum;
        dic = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",gid,@"gid",_textView.text,@"content",[NSNumber numberWithInteger:_star.currentStar],@"score",ordernum,@"ordernum",pictures,@"pictures", nil];
    }
    
    [commentReq requestWitUrl:ADDCOMMENT_IF andArgument:dic andType:WXHTTPRequestPost];
    
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


@end
