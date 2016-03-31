//
//  WXMapViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/7/1.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "WXMapViewController.h"

@interface WXMapViewController ()<AMapSearchDelegate>

@end

@implementation WXMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商家定位";
    
    _tableSource = [[NSMutableArray alloc]init];
    
    [MAMapServices sharedServices].apiKey = apikey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64,CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [_mapView setZoomLevel:16.0 animated:YES];
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc]initWithSearchKey:@"c587b217b0751ce1ff02a9a03f71308b" Delegate:self];
    //构造 AMapReGeocodeSearchRequest 对象,location 为必选项,radius 为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:_latitude.floatValue longitude:_longitude.floatValue];
    regeoRequest.radius = 1000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
    
    
    // Do any additional setup after loading the view from its nib.
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


//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil) {
        //处理搜索结果
//        NSString *result =[NSString stringWithFormat:@"ReGeocode: %@",response.regeocode];
//        NSLog(@"ReGeo: %@", result);
        for (AMapPOI* poi in response.regeocode.pois) {
            
            demoModel* model = [[demoModel alloc]init];
            model.name = poi.name;
            model.address = poi.address;
            model.jingdu = poi.location.longitude;
            model.weidu = poi.location.latitude;
            [_tableSource addObject:model];
            
        }
        
        [self createAnnotation];
        
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES; //设置气泡可以弹出,默认为 NO annotationView.animatesDrop = YES; //设置标注动画显示,默认为 NO
        annotationView.draggable = YES; //设置标注可以拖动,默认为 NO annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil; }

-(void)createAnnotation
{
    demoModel* model = _tableSource[0];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(model.weidu, model.jingdu) animated:YES];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(model.weidu, model.jingdu);
    pointAnnotation.title = model.name;
    pointAnnotation.subtitle = model.address;
    [_mapView addAnnotation:pointAnnotation];

//    for (demoModel* model in _tableSource) {
//        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//        pointAnnotation.coordinate = CLLocationCoordinate2DMake(model.weidu, model.jingdu);
//        pointAnnotation.title = model.name;
//        pointAnnotation.subtitle = model.address;
//        [_mapView addAnnotation:pointAnnotation];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
