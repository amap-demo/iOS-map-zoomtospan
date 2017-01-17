本工程主要介绍了 高德地图iOS SDK 3D版本 实现通过缩放保证地图上自定义内容（模拟为点）均展现在视野范围内, 并且地图中心点不被改变
## 前述 ##

- [高德官方网站申请key](http://id.amap.com/?ref=http%3A%2F%2Fapi.amap.com%2Fkey%2F).
- 阅读[开发指南](http://lbs.amap.com/api/ios-sdk/summary/).
- 工程基于iOS 3D地图SDK实现

## 功能描述 ##
通过缩放保证地图上自定义内容（模拟为点）均展现在视野范围内, 并且地图中心点不被改变

## 核心类/接口 ##
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| MAMapView	| setVisibleMapRect | 设置地图显示范围 | ---- |

## 核心难点 ##

objective-c:

``` objc
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

```

swift:

``` swift
/// 根据传入的annotation来展现：保持中心点不变的情况下，展示所有传入annotation
///
/// - Parameters:
///   - annotations: annotation
///   - insets: 填充框，用于让annotation不会靠在地图边缘显示
///   - mapView: 地图view
func showsAnnotations(_ annotations:Array<MAPointAnnotation>, edgePadding insets:UIEdgeInsets, andMapView mapView:MAMapView!) {
    var rect:MAMapRect = MAMapRectZero

    for annotation:MAPointAnnotation in annotations {
        let diagonalPoint:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude - (annotation.coordinate.latitude - mapView.centerCoordinate.latitude),mapView.centerCoordinate.longitude - (annotation.coordinate.longitude - mapView.centerCoordinate.longitude))

        let annotationMapPoint: MAMapPoint = MAMapPointForCoordinate(annotation.coordinate)
        let diagonalPointMapPoint: MAMapPoint = MAMapPointForCoordinate(diagonalPoint)

        let annotationRect:MAMapRect = MAMapRectMake(min(annotationMapPoint.x, diagonalPointMapPoint.x), min(annotationMapPoint.y, diagonalPointMapPoint.y), abs(annotationMapPoint.x - diagonalPointMapPoint.x), abs(annotationMapPoint.y - diagonalPointMapPoint.y));

        rect = MAMapRectUnion(rect, annotationRect)
    }

    mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
}

```
