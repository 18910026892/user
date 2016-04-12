//
//  JLVenueMapViewController.m
//  Accompany
//
//  Created by GongXin on 16/3/9.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLVenueMapViewController.h"

@interface JLVenueMapViewController ()
{
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKPolyline* colorfulPolyline;
    BMKArcline* arcline;
    BMKGroundOverlay* ground2;
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
}
@end
@implementation JLVenueMapViewController


-(BMKMapView*)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]init];
        _mapView.frame = CGRectMake(0, 64, kMainScreenWidth,kMainBoundsHeight-64);
        _mapView.delegate = self;
   
        CLLocationCoordinate2D coor;
        
        coor.latitude = self.VenueModel.latitude;
        coor.longitude = self.VenueModel.longitude;
        
        _mapView.centerCoordinate = coor;
        
        
        [_mapView setZoomLevel:18];
    }
    return _mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //添加内置覆盖物
   
    [self showBackButton:YES];
    
    [self setupViews];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavTitle: @"场馆地址"];
    
}
-(void)setupDatas
{
    
}
-(void)setupViews
{
    [self.view addSubview:self.mapView];
    //添加内置覆盖物
    [self addPointAnnotation];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


//添加标注
- (void)addPointAnnotation
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        
        coor.latitude = self.VenueModel.latitude;
        coor.longitude = self.VenueModel.longitude;

        pointAnnotation.coordinate = coor;
        pointAnnotation.title = @"test";
        pointAnnotation.subtitle = @"此Annotation可拖拽!";
    }
    [_mapView addAnnotation:pointAnnotation];
}


#pragma mark -
#pragma mark implement BMKMapViewDelegate

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:0.5];
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.5];
        circleView.lineWidth = 5.0;
        
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        if (overlay == colorfulPolyline) {
            polylineView.lineWidth = 5;
            /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
            polylineView.colors = [NSArray arrayWithObjects:
                                   [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5], nil];
        } else {
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 20.0;
            [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        }
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = (overlay == polygon2);
        return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    }
    return nil;
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
   
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
        }
        return annotationView;
       
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}


@end
