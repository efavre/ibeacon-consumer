//
//  DCAppDelegate.m
//  iBeaconConsumer
//
//  Created by Eric Favre on 31/03/2014.
//  Copyright (c) 2014 Eric. All rights reserved.
//

#import "IBCAppDelegate.h"
#import "IBCConstant.h"

@implementation IBCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self startMonitoring];
    return YES;
}

- (void)startMonitoring
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Livecode-Region"];
    region.notifyEntryStateOnDisplay = YES;
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        [self.locationManager startMonitoringForRegion:region];
    }
    else
    {
        NSLog(@"This device does not support monitoring beacon regions");
    }
}

#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self notifyEnteredRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [self notifyExitedRegion];
}

#pragma mark - Local Notifications

- (void)notifyEnteredRegion
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Quelqu'un vous donne une carte !";
    notification.alertAction = @"Open";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)notifyExitedRegion
{

}


@end
