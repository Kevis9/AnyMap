//
//  ViewController.m
//  STUMap2
//
//  Created by hwl on 2019/10/24.
//  Copyright © 2019 hwl. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationKit/BMKLocationComponent.h>
#import "SlideScrollView.h"
#import "StoryPaopaoView.h"
#import "CoreDataManager.h"
#import "SCBMKPointAnnotationSubClass.h"
#import <TZImagePickerController.h>

@interface ViewController ()<BMKLocationManagerDelegate,
                             BMKMapViewDelegate,
                             SlideScrollViewDelegate,
                             TZImagePickerControllerDelegate>

@property(nonatomic,strong) BMKMapView *mapView;

@property(nonatomic,strong) BMKUserLocation *userLocation;

@property(nonatomic,strong) BMKLocationManager *locationManager;

@property(nonatomic,strong) SlideScrollView *bottomSlideView;

@property(nonatomic,strong) SCBMKPointAnnotationSubClass *currentPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.mapView setZoomLevel:17];
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    
    [self.view addSubview:self.mapView];
    //[self.view addSubview:self.bottomSlideView];
    
    
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [self.mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [self.mapView viewWillDisappear];
}


#pragma mark - BMKMapViewDelegate

//线的视图
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]){
             BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
             //设置polylineView的画笔颜色为蓝色
             polylineView.strokeColor = [[UIColor alloc] initWithRed:19/255.0 green:107/255.0 blue:251/255.0 alpha:1.0];
             
             polylineView.lineWidth = 2;
             //圆点虚线，V5.0.0新增
    //        polylineView.lineDashType = kBMKLineDashTypeDot;
             //方块虚线，V5.0.0新增
    //       polylineView.lineDashType = kBMKLineDashTypeSquare;
             return polylineView;
        }
        return nil;
}

//点的视图,同时设置PaopaoView
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKPinAnnotationView* annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"标注"];
        
        annotationView.pinColor = BMKPinAnnotationColorRed;
        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
        annotationView.animatesDrop = NO;        //去掉掉落效果
        
        StoryPaopaoView *custompview = [[StoryPaopaoView alloc] init];
        custompview.frame = CGRectMake(0, 0, 120.0f, 70.0f);
        BMKActionPaopaoView *pview = [[BMKActionPaopaoView alloc] initWithCustomView:custompview];
        pview.backgroundColor = [UIColor lightGrayColor];
        pview.frame = custompview.frame;
        annotationView.paopaoView = pview;
        return annotationView;
    }
    return nil;
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    
    //长按之后底部的slideview会被更换
    if(self.bottomSlideView)
        [self.bottomSlideView removeFromSuperview];
    self.bottomSlideView = [[SlideScrollView alloc] initWithFrame:self.view.bounds];
    self.bottomSlideView.delegate = self;
    [self.view addSubview:self.bottomSlideView];
    
    //使用子类来记录该点的ID---结合Coredata
    SCBMKPointAnnotationSubClass* annotation = [[SCBMKPointAnnotationSubClass alloc]init];
    annotation.coordinate = coordinate;
    
    self.currentPoint = annotation;
    NSLog(@"+++++%p",self.currentPoint);
    [self.mapView addAnnotation:annotation];
    
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    self.currentPoint = (SCBMKPointAnnotationSubClass*)view.annotation;
    
    NSLog(@"+++++%p",self.currentPoint);
    
    NSManagedObjectID *ID = self.currentPoint.pointID;
    
    int flag=0;
    if(ID)
    {
       NSDictionary* dic = [[CoreDataManager sharedInstance] checkPointByObjectID:ID];
        NSLog(@"%@",dic);
        if(dic)
        {
            ((StoryPaopaoView*)view.paopaoView.subviews[0]).titleLabel.text = dic[@"title"];
            ((StoryPaopaoView*)view.paopaoView.subviews[0]).storyLabel.text = dic[@"content"];
//            [((StoryPaopaoView*)view.paopaoView.subviews[0]).titleLabel sizeToFit];
//            [((StoryPaopaoView*)view.paopaoView.subviews[0]).storyLabel sizeToFit];
//            
            self.bottomSlideView.StoryTextView.text = dic[@"content"];
            self.bottomSlideView.TitleTextView.text = dic[@"title"];
            flag=1;
        }
    }
    if(!flag)
    {
        ((StoryPaopaoView*)view.paopaoView.subviews[0]).titleLabel.text = self.bottomSlideView.TitleTextView.text;
        NSLog(@"%p",((StoryPaopaoView*)view.paopaoView.subviews[0]).titleLabel);
        ((StoryPaopaoView*)view.paopaoView.subviews[0]).storyLabel.text= self.bottomSlideView.StoryTextView.text;
        if(self.bottomSlideView.firstImg)
        {
            //如果不为空,则添加上去
            [((StoryPaopaoView*)view.paopaoView.subviews[0]).storyImgView setImage:self.bottomSlideView.firstImg];
        }
    }

}
#pragma mark - BMKLocationManagerDelegate

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    //NSLog(@"用户方向更新");

    self.userLocation.heading = heading;
    [self.mapView updateLocationData:self.userLocation];
}

- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    
    
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    
    CLLocationCoordinate2D cords[2]={0};
 
    //判断是否在亚洲区域
    if(self.userLocation.location.coordinate.latitude>53
       ||self.userLocation.location.coordinate.latitude<3
       ||self.userLocation.location.coordinate.longitude<73.3
       ||self.userLocation.location.coordinate.longitude>150)
          {
              self.userLocation.location = location.location;
              return;
          }
      
    cords[0] = self.userLocation.location.coordinate;
    cords[1] = location.location.coordinate;
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:cords count:2];
    [self.mapView addOverlay:polyline];
    
    self.userLocation.location = location.location;
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
}

#pragma mark -SlideView Delgate
- (void)addStoryPoint:(SlideScrollView *)slideview{
    //进行存储操作
    NSMutableDictionary *dic;
    dic = [[NSMutableDictionary alloc] init];
    [dic setValue:slideview.StoryTextView.text forKey:@"content"];
    [dic setValue:slideview.TitleTextView.text forKey:@"title"];
    [dic setValue:[NSNumber numberWithDouble:self.currentPoint.coordinate.latitude] forKey:@"latitude"];
    [dic setValue:[NSNumber numberWithDouble:self.currentPoint.coordinate.longitude] forKey:@"longitude"];
    [dic setValue:[NSDate date] forKey:@"createdtime"];
    //存储成功之后记录该点的ID
    self.currentPoint.pointID = [[CoreDataManager sharedInstance] createStoryPoint:dic];
    if(self.currentPoint.pointID)
    {
        NSLog(@"addStoryPoint----存储成功");
    }
    else
    {
        NSLog(@"addStoryPoint----存储失败");
    }
}

- (void)pickImgFinishedHandle:(CellPickImgCopleteblock)block{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.bottomSlideView.numOfImgs delegate:self];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"图片选择完啦!");
        if(block)
        {
            block(photos);
        }
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - Lazy loading
- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    }
    return _mapView;
}


@end
