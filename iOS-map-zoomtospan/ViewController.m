//
//  ViewController.m
//  iOS-map-zoomtospan
//
//  Created by 翁乐 on 17/01/2017.
//  Copyright © 2017 Amap. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface ViewController ()<MAMapViewDelegate>
{
    ///地图view
    MAMapView *_mapView;
}

@end

@implementation ViewController

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        
        annotationView.pinColor = [((MAPointAnnotation *)annotation).title isEqualToString:@"center"] ? MAPinAnnotationColorRed : MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapInitComplete:(MAMapView *)mapView
{
    ///添加中心点annotation
    MAPointAnnotation *centerPoint = [[MAPointAnnotation alloc] init];
    centerPoint.coordinate = CLLocationCoordinate2DMake(39.991577, 116.471634);
    centerPoint.title = @"center";
    
    [_mapView addAnnotation:centerPoint];
    _mapView.centerCoordinate = centerPoint.coordinate;
    
    ///添加其他annotation
    NSArray *annotations = [self annotations];
    
    [_mapView addAnnotations:annotations];
    
    [self showsAnnotations:annotations edgePadding:UIEdgeInsetsMake(40, 40, 40, 40) andMapView:_mapView];
}

/**
 * brief 根据传入的annotation来展现：保持中心点不变的情况下，展示所有传入annotation
 * @param annotations annotation
 * @param insets 填充框，用于让annotation不会靠在地图边缘显示
 * @param mapView 地图view
 */
- (void)showsAnnotations:(NSArray *)annotations edgePadding:(UIEdgeInsets)insets andMapView:(MAMapView *)mapView {
    
    MAMapRect rect = MAMapRectZero;
    
    for (MAPointAnnotation *annotation in annotations) {
        
        ///annotation相对于中心点的对角线坐标
        CLLocationCoordinate2D diagonalPoint = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude - (annotation.coordinate.latitude - mapView.centerCoordinate.latitude),mapView.centerCoordinate.longitude - (annotation.coordinate.longitude - mapView.centerCoordinate.longitude));
        
        MAMapPoint annotationMapPoint = MAMapPointForCoordinate(annotation.coordinate);
        MAMapPoint diagonalPointMapPoint = MAMapPointForCoordinate(diagonalPoint);
        
        ///根据annotation点和对角线点计算出对应的rect（相对于中心点）
        MAMapRect annotationRect = MAMapRectMake(MIN(annotationMapPoint.x, diagonalPointMapPoint.x), MIN(annotationMapPoint.y, diagonalPointMapPoint.y), ABS(annotationMapPoint.x - diagonalPointMapPoint.x), ABS(annotationMapPoint.y - diagonalPointMapPoint.y));
        
        rect = MAMapRectUnion(rect, annotationRect);
    }
    
    [mapView setVisibleMapRect:rect edgePadding:insets animated:YES];
}

/**
 * brief 初始化annotation
 * @return annotations
 */
- (NSMutableArray *)annotations {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    CLLocationCoordinate2D coordinates[10] = {
        {39.984311, 116.496396},
        {39.941418, 116.519399},
        {40.013767, 116.497426},
        {39.997726, 116.321302},
        {39.971946, 116.470304},
        {39.959315, 116.450734},
        {39.90482, 116.397176},
        {39.944051, 116.482663},
        {39.992991, 116.393399},
        {39.941418, 116.523862}};

    for (int i = 0; i < 10; i++) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = coordinates[i];
        annotation.title = [NSString stringWithFormat:@"%d",i];
        
        [annotations addObject:annotation];
    }
    
    return annotations;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    [AMapServices sharedServices].apiKey = @"";///您的key
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
}




@end
