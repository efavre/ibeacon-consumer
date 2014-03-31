//
//  DCViewController.h
//  iBeaconConsumer
//
//  Created by Eric Favre on 31/03/2014.
//  Copyright (c) 2014 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IBCViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;

@end
