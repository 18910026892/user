//
//  JLVenueMapViewController.h
//  Accompany
//
//  Created by GongXin on 16/3/9.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "StadiumCollectionModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface JLVenueMapViewController : BaseViewController
<BMKMapViewDelegate>

@property (nonatomic,strong)BMKMapView* mapView;
@property (strong,nonatomic)StadiumCollectionModel * VenueModel;

@property (nonatomic,strong)UIButton * backButton;

@end
