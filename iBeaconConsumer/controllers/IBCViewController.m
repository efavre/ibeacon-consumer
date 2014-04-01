//
//  DCViewController.m
//  iBeaconConsumer
//
//  Created by Eric Favre on 31/03/2014.
//  Copyright (c) 2014 Eric. All rights reserved.
//

#import "IBCViewController.h"
#import "IBCConstant.h"

@interface IBCViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation IBCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self monitorIBeacons];
}

- (void)monitorIBeacons
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Livecode-Region"];
    [self.locationManager startMonitoringForRegion:beaconRegion];
}

#pragma mark - CLLocationManagerDelegate methods


- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    self.statusLabel.text = @"Bienvenue dans la région !";
    self.view.backgroundColor = [UIColor greenColor];
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    self.statusLabel.text = @"A bientôt !";
    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    for (CLBeacon *beacon in beacons)
    {
        
        NSString *proximity = nil;
        proximity = (beacon.proximity == CLProximityImmediate ? @"immediate" : (beacon.proximity == CLProximityNear ? @"near" : (beacon.proximity == CLProximityFar ? @"far" : @"unknown")));
        self.proximityLabel.text = proximity;
        self.rssiLabel.text = [NSString stringWithFormat:@"%ld",(long)beacon.rssi];
        self.majorLabel.text = [NSString stringWithFormat:@"%@",beacon.major];
        self.minorLabel.text = [NSString stringWithFormat:@"%@",beacon.minor];
    }
}

@end
