//
//  addressManageViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/25.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "addressManageViewController.h"
#import "adressModel.h"
#import "UIColor+hexColor.h"


@interface addressManageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    NSDictionary* _tabledic;
    NSString* _province;
    NSString* _city;
    NSString* _district;
    NSInteger offset;
    HTTPRequest* shengReq;
    HTTPRequest* shiReq;
    HTTPRequest* xianReq;
    HTTPRequest* addressReq;
    NSMutableArray* shengSource;
    NSMutableArray* shiSource;
    NSMutableArray* xianSource;
    
    adressModel* _provinceModel;
    adressModel* _cityModel;
    adressModel* _districtModel;
    
    NSString* messages;
}

@property (weak, nonatomic) IBOutlet UIImageView *provinceBackView;

@property (weak, nonatomic) IBOutlet UIImageView *cityBackView;

@property (weak, nonatomic) IBOutlet UIImageView *distantBackView;

- (IBAction)touchBackView:(id)sender;

@property(strong,nonatomic)UILabel* label;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITableView *provinceView;

@property (weak, nonatomic) IBOutlet UITableView *cityView;

@property (weak, nonatomic) IBOutlet UITableView *districtView;

@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property (weak, nonatomic) IBOutlet UIButton *districtBtn;

@property (weak, nonatomic) IBOutlet UITextView *detialView;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet UITextField *postcodeFeild;

- (IBAction)selectBtn:(UIButton *)sender;

- (IBAction)saveBtn:(UIButton *)sender;


@end

@implementation addressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.label;
    
    _scrollView.contentSize = CGSizeMake(0, 504);
    
    [_provinceBtn setBackgroundImage:[UIImage imageNamed:@"xiaowei2"] forState:UIControlStateSelected];
    [_cityBtn setBackgroundImage:[UIImage imageNamed:@"xiaowei2"] forState:UIControlStateSelected];
    [_districtBtn setBackgroundImage:[UIImage imageNamed:@"xiaowei2"] forState:UIControlStateSelected];
    
    [self changwaiguan];
    
    
    
//    _tabledic = @{@"山东省":@{@"威海市":@[@"荣成市",@"崖西镇",@"崖头镇",@"成山镇",@"埠柳镇",@"城乡镇"],
//                           @"青岛市":@[@"青岛1",@"青岛2",@"青岛3",@"青岛4"]},
//                  @"辽宁省":@{@"大连市":@[@"甘井子",@"高新园区",@"软件园",@"星海广场",@"星海公园",@"滨海路"],
//                           @"沈阳市":@[@"和平区",@"沈河区",@"大东区",@"皇姑区"]},
//                  @"黑龙江省":@{@"哈尔滨":@[@"南岗区",@"道里区",@"道外区",@"香坊区",@"松北区",@"平房区"],
//                            @"齐齐哈尔":@[@"龙沙区",@"铁锋区",@"建华区",@"昂昂溪区"]}};
    
    shengSource = [[NSMutableArray alloc]init];
    shiSource = [[NSMutableArray alloc]init];
    xianSource = [[NSMutableArray alloc]init];
    
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

-(void)changwaiguan
{
    _provinceView.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _provinceView.layer.borderWidth = 1;
    _cityView.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _cityView.layer.borderWidth = 1;
    _districtView.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _districtView.layer.borderWidth = 1;
    _provinceBackView.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _provinceBackView.layer.borderWidth = 1;
    _cityBackView.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _cityBackView.layer.borderWidth = 1;
    _distantBackView.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _distantBackView.layer.borderWidth = 1;
    _detialView.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _detialView.layer.borderWidth = 1;
    _nameField.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _nameField.layer.borderWidth = 1;
    _phoneField.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _phoneField.layer.borderWidth = 1;
    _postcodeFeild.layer.borderColor = [UIColor colorWithHexString:@"#ACACAC"].CGColor;
    _postcodeFeild.layer.borderWidth = 1;
    
    _cityBtn.enabled = NO;
    _districtBtn.enabled = NO;
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
    
    if (request == shengReq) {
        NSArray* area = requestDic[@"area"];
        [shengSource removeAllObjects];
        for (NSDictionary* dic in area) {
            adressModel* model = [[adressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [shengSource addObject:model];
        }
        [_provinceView reloadData];
    }else if (request == shiReq)
    {
        NSArray* area = requestDic[@"area"];
        [shiSource removeAllObjects];
        for (NSDictionary* dic in area) {
            adressModel* model = [[adressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [shiSource addObject:model];
        }
        [_cityView reloadData];
    }else if (request == xianReq)
    {
        NSArray* area = requestDic[@"area"];
        [xianSource removeAllObjects];
        for (NSDictionary* dic in area) {
            adressModel* model = [[adressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [xianSource addObject:model];
        }
        [_districtView reloadData];
    }else
    {
        NSString* message = requestDic[@"message"];
        if ([message isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"插入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    
}

#pragma mark - getter

-(UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _label.text = @"新建收货地址";
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

#pragma mark - private

-(void)showalert
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messages delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}

-(void)changeView:(UITextField*)textField
{
    offset = _scrollView.center.y - textField.center.y - 80;
    CGRect backFrame = _scrollView.frame;
    backFrame.origin.y +=offset ;
    self.scrollView.frame = backFrame;
}

-(void)setBtnTitle:(NSInteger)index
{
    
    switch (index) {
        case 0:
            [_provinceBtn setTitle:_province forState:UIControlStateNormal];
            
        case 1:
            [_cityBtn setTitle:_city forState:UIControlStateNormal];
            
        case 2:
            [_districtBtn setTitle:_district forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }

}

-(void)showtableview:(NSInteger)index
{
    NSArray* arr = [self.backView subviews];
    if (index == 0) {
        if (shengReq == nil) {
            shengReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
            
            [shengReq requestWitUrl:SHENG_IF andArgument:nil andType:WXHTTPRequestGet];
        }
    }else if (index == 1)
    {
        if (shiReq == nil) {
            shiReq = [[HTTPRequest alloc]initWithtag:2 andDelegate:self];
            [shiReq requestWitUrl:SHI andArgument:[NSDictionary dictionaryWithObjectsAndKeys:_provinceModel.id,@"id", nil] andType:WXHTTPRequestGet];
        }
    }else if (index == 2)
    {
        if (xianReq == nil) {
            xianReq = [[HTTPRequest alloc]initWithtag:2 andDelegate:self];
            [xianReq requestWitUrl:XIAN_IF andArgument:[NSDictionary dictionaryWithObjectsAndKeys:_cityModel.id,@"id", nil] andType:WXHTTPRequestGet];
        }
    }
    
    for (id tb in arr) {
        if ([tb isKindOfClass:[UITableView class]]) {
            UITableView* table = (UITableView*)tb;
            if (table.tag != index+20) {
                table.hidden = YES;
            }
            
        }
        if ([tb isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton*)tb;
            if (btn.tag != index+10) {
                btn.selected = NO;
            }
        }
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _provinceView) {
        return [shengSource count];
    }else if (tableView == _cityView)
    {
        
        return [shiSource count];
    }else
    {
        
        return [xianSource count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"weixiao";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    adressModel* model = nil;
    if (tableView == _provinceView) {
        model = shengSource[indexPath.row];
        
        
    }else if (tableView == _cityView)
    {
        model = shiSource[indexPath.row];
        
    }else
    {
        model = xianSource[indexPath.row];
        
    }
    
    cell.textLabel.text = model.classname;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _provinceView) {
        
        _provinceModel = shengSource[indexPath.row];
        _province = _provinceModel.classname;
        _cityModel = nil;
        _city = @"请选择市";
        _district = @"请选择区";
        _districtBtn.enabled = NO;
        _cityBtn.enabled = YES;
        
    }else if (tableView == _cityView)
    {
        
        _cityModel = shiSource[indexPath.row];
        _districtModel = nil;
        _city = _cityModel.classname;
        _district = @"请选择区";
        _districtBtn.enabled = YES;
        
    }else
    {
        _districtModel = xianSource[indexPath.row];
        _district = _districtModel.classname;
        
    }
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:tableView.tag - 10];
    [self setBtnTitle:btn.tag - 10];
    [self selectBtn:btn];
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self performSelector:@selector(changeView:) withObject:textField afterDelay:0.1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - xib

- (IBAction)selectBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    UITableView* tableView = (UITableView*)[self.view viewWithTag:sender.tag + 10];
    tableView.hidden = !sender.selected;
    
    if (sender.selected) {
        [self showtableview:sender.tag - 10];
    }
    
}

- (IBAction)saveBtn:(UIButton *)sender {
    
    NSString* regex = @"1[0-9]{10}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch =[pred evaluateWithObject:_phoneField.text];
    
    if (_provinceModel == nil) {
        messages = @"请选择省";
        [self showalert];
        return;
    }else if (_cityModel == nil)
    {
        messages = @"请选择市";
        [self showalert];
        return;
    }else if (_districtModel == nil)
    {
        messages = @"请选择区";
        [self showalert];
        return;
    }else if (_detialView.text.length<1)
    {
        messages = @"请填写详细地址";
        [self showalert];
        return;
    }else if (_nameField.text.length<1)
    {
        messages = @"请填写收件人";
        [self showalert];
        return;
    }else if (!isMatch)
    {
        messages = @"请填写正确的手机号";
        [self showalert];
        return;
    }else if (_postcodeFeild.text.length<1)
    {
        messages = @"请填写邮编";
        [self showalert];
        return;
    }

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* uid = [defaults objectForKey:@"uid"];
    addressReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:_provinceModel.id,@"sheng_id",_cityModel.id,@"shi_id",_districtModel.id,@"xian_id",_phoneField.text,@"phone",_nameField.text,@"rec_name",_postcodeFeild.text,@"zipcode",uid,@"uid",_detialView.text,@"cur_address", nil];
    
    [addressReq requestWitUrl:ADDADDRESS_IF andArgument:dic andType:WXHTTPRequestGet];
    
}
- (IBAction)touchBackView:(id)sender {
    
    [_nameField resignFirstResponder];
    [_phoneField resignFirstResponder];
    [_postcodeFeild resignFirstResponder];
    [_detialView resignFirstResponder];
    
}
@end
