//
//  ViewController.swift
//  iOS-map-zoomtospan-swift
//
//  Created by 翁乐 on 17/01/2017.
//  Copyright © 2017 Amap. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MAMapViewDelegate {
    var _mapView:MAMapView!

    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self){
            let pointReuseIndetifier:String = "pointReuseIndetifier"
            let annotationView:MAPinAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            
            let title:String = (annotation as! MAPointAnnotation).title
            annotationView.pinColor = title == "center" ? .red : .purple
            
            return annotationView
        }
        
        return nil
    }
    
    func mapInitComplete(_ mapView: MAMapView!) {
        ///添加中心点annotation
        let centerPoint:MAPointAnnotation = MAPointAnnotation()
        centerPoint.coordinate = CLLocationCoordinate2DMake(39.991577, 116.471634)
        centerPoint.title = "center"
        
        _mapView.addAnnotation(centerPoint)
        _mapView.centerCoordinate = centerPoint.coordinate
        
        ///添加其他annotation
        let annotations:Array<MAPointAnnotation> = getAnnotations()
        _mapView.addAnnotations(annotations)
        
        showsAnnotations(annotations, edgePadding: UIEdgeInsetsMake(40, 40, 40, 40), andMapView: _mapView)
    }
    
    
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
    
    
    /// 初始化annotation
    ///
    /// - Returns: annotations
    func getAnnotations() -> Array<MAPointAnnotation> {
        var annotations = Array<MAPointAnnotation>()
        
        let coordinates:[CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 39.984311, longitude: 116.496396),
            CLLocationCoordinate2D(latitude: 39.941418, longitude: 116.519399),
            CLLocationCoordinate2D(latitude: 40.013767, longitude: 116.497426),
            CLLocationCoordinate2D(latitude: 39.997726, longitude: 116.321302),
            CLLocationCoordinate2D(latitude: 39.971946, longitude: 116.470304),
            CLLocationCoordinate2D(latitude: 39.959315, longitude: 116.450734),
            CLLocationCoordinate2D(latitude: 39.90482, longitude: 116.397176),
            CLLocationCoordinate2D(latitude: 39.944051, longitude: 116.482663),
            CLLocationCoordinate2D(latitude: 39.992991, longitude: 116.393399),
            CLLocationCoordinate2D(latitude: 39.941418, longitude: 116.523862)]
        
        for i in 0..<10 {
            let annotation:MAPointAnnotation = MAPointAnnotation()
            annotation.coordinate = coordinates[i]
            annotation.title = String.init(format: "%d", i)
            
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = "" ///您的key
        
        _mapView = MAMapView(frame: view.bounds)
        _mapView.delegate = self
        
        view.addSubview(_mapView)
        // Do any additional setup after loading the view, typically from a nib.
    }

}

