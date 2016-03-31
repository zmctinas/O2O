//
//  searchViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/4/20.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "searchViewController.h"
#import "UIColor+hexColor.h"
#import "dataBase.h"
#import "cateModel.h"
#import "allGoodsViewController.h"

@interface searchViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,HTTPRequestDataDelegate>
{
    NSMutableArray* _tableSource;
    HTTPRequest* hotReq;
}

@property dataBase* searchBase;

@property(strong,nonatomic)UIImageView* searchImage;

@property(strong,nonatomic)NSMutableArray* historySource;

@property(strong,nonatomic)UITableView* tableView;

@property(strong,nonatomic)UIImageView* imageView;

@property(strong,nonatomic)UIBarButtonItem* rightItem;

@property(strong,nonatomic)UITextField* textField;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)deleteBtn:(UIButton *)sender;

- (IBAction)changeBtn:(UIButton *)sender;

- (IBAction)navBtn:(UIButton *)sender;

@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _searchBase = [[dataBase alloc]init];
    
    _historySource = [_searchBase select:@""];
    
    
    _tableSource = [[NSMutableArray alloc]init];
    
    hotReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    [hotReq requestWitUrl:HOT_IF andArgument:nil andType:WXHTTPRequestGet];
    
    [_oneBtn setTitleColor:[UIColor colorWithHexString:@"#FF638E"] forState:UIControlStateSelected];
    _oneBtn.selected = YES;
    [_twoBtn setTitleColor:[UIColor colorWithHexString:@"#FF638E"] forState:UIControlStateSelected];
    
    
    [_scrollView addSubview:self.tableView];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 10, 15)];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"head_finish"] forState:UIControlStateNormal];
    UIBarButtonItem* im = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIBarButtonItem* im1 = [[UIBarButtonItem alloc]initWithCustomView:self.searchImage];
    self.navigationItem.leftBarButtonItems = @[im,im1];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    self.changeBtn.hidden = YES;
    
    [self.textField setValue:[UIColor colorWithHexString:@"#808080"] forKeyPath:@"_placeholderLabel.textColor"];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = YES;
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView* view = (UIView*)[self.tabBarController.view viewWithTag:10000];
    view.hidden = NO;
}

-(void)backBtn:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HTTPRequestDataDelegate

-(void)request:(HTTPRequest *)request getMessage:(NSDictionary *)requestDic
{
   
    NSArray* goods = requestDic[@"goods"];
    [_tableSource removeAllObjects];
    for (NSDictionary* dic in goods) {
        cateModel* model = [[cateModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_tableSource addObject:model];
    }
    [_scrollView addSubview:self.imageView];
}

#pragma mark - getter

-(UIImageView*)searchImage
{
    if (_searchImage == nil) {
        _searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 180, 30)];
        _searchImage.image = [UIImage imageNamed:@"searchbar"];
        _searchImage.userInteractionEnabled = YES;
        [_searchImage addSubview:self.textField];
    }
    return  _searchImage;
}

-(UITextField*)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 145, 30)];
//        [_textField setBackground:[UIImage imageNamed:@"searchbar"]];
        _textField.placeholder = @"   输入商品名称";
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.delegate = self;
        _textField.textColor = [UIColor colorWithHexString:@"#949494"];
    }
    return _textField;
}

-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];;
        [button setFrame:CGRectMake(0, 5, 40, 25)];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchsearch:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _rightItem;
}

-(UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

-(UIImageView*)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
        _imageView.userInteractionEnabled = YES;
        NSInteger w=0,h=0;
        for (cateModel* model in _tableSource) {
            NSString* str = nil;
            if (model.comName.length>3) {
                str = [model.comName substringToIndex:3];
            }else
            {
                str = [model.comName substringToIndex:2];
            }
            UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
            [button setFrame:CGRectMake(10+w*(52+10), 10 + h*(30+10), 52, 30)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitleColor:[UIColor colorWithHexString:@"#414141"] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor colorWithHexString:@"#BFBFBF"].CGColor;
            button.layer.borderWidth = 0.3;
            [button setTitle:str forState:UIControlStateNormal];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            [button addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.tag = w+h*5;
            
            [_imageView addSubview:button];
            w++;
            if (w == 5) {
                w =0;
                h++;
            }
        }
        
    }
    
    return _imageView;
}

#pragma mark - private

-(void)soreKeyword
{
    for (NSString* str in _historySource) {
        if ([_textField.text isEqualToString:str]) {
            return;
        }
    }
    [_searchBase insert:_textField.text];
    
    [self selectKeyWord];
    
}

-(void)selectKeyWord
{
    [_historySource removeAllObjects];
    
    _historySource = [_searchBase select:@""];
    
    [_tableView reloadData];
}

-(void)touchBtn:(UIButton*)sender
{
    
    cateModel* model = _tableSource[sender.tag];
    _textField.text = model.comName;
    [self soreKeyword];
    allGoodsViewController* root = [[allGoodsViewController alloc]init];
    root.keyword = _textField.text ;
    [self.navigationController pushViewController:root animated:YES];
}

-(void)moveLabel:(NSInteger)index
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _lineLabel.frame;
        rect.origin.x = index* SCREEN_WIDTH /2 ;
        _lineLabel.frame = rect;
    }completion:^(BOOL finished) {
        
    }];
}

-(void)changeContent:(NSInteger)index
{
    switch (index) {
        case 0:
            self.deleteBtn.hidden = NO;
            self.changeBtn.hidden = YES;
            
            
            break;
        case 1:
            self.deleteBtn.hidden = YES;
            self.changeBtn.hidden = NO;
            
            break;
        
        default:
            break;
    }
}

-(void)touchsearch:(UIButton*)sender
{
    [self soreKeyword];
    
    allGoodsViewController* root = [[allGoodsViewController alloc]init];
//    root.keyword = [_textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    root.keyword = _textField.text;
    [self.navigationController pushViewController:root animated:YES];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historySource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"weixiao";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _historySource[indexPath.row];
    
    return cell;
}



#pragma mark  - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _textField.text = _historySource[indexPath.row];
    allGoodsViewController* root = [[allGoodsViewController alloc]init];
    root.keyword = _textField.text ;
    [self.navigationController pushViewController:root animated:YES];
}

#pragma mark - UITextFieldDelegate

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    textField.text = @"   ";
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        NSInteger num = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self moveLabel:num];
        [self changeContent:num];
    }
    
}

#pragma mark - xib

- (IBAction)deleteBtn:(UIButton *)sender {
    
    [_searchBase delete];
    
    [self selectKeyWord];
    
}

- (IBAction)changeBtn:(UIButton *)sender {
    
    hotReq = [[HTTPRequest alloc]initWithtag:1 andDelegate:self];
    [hotReq requestWitUrl:HOT_IF andArgument:nil andType:WXHTTPRequestGet];
    
}

- (IBAction)navBtn:(UIButton *)sender {
    
    sender.selected = YES;
    for (int i = 0 ; i<2; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:10+i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    
    NSInteger num = sender.tag - 10;
    [self moveLabel:num];
    [self changeContent:num];
    
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH* num, 0) animated:YES];
    
}
@end
