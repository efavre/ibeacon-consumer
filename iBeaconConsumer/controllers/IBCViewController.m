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
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@end

@implementation IBCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cards = [NSMutableArray arrayWithObjects:@3, @4, nil];
    [self populateCardsView];
    [self monitorIBeacons];
}

- (void)monitorIBeacons
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Livecode-Region"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)populateCardsView
{
    for (NSNumber *card in self.cards) {
        int tag = [card intValue];
        UIButton *button = (UIButton *)[self.view viewWithTag:tag];
        button.hidden = NO;
    }
}

#pragma mark - CLLocationManagerDelegate methods


- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    self.statusLabel.text = @"Quelqu'un vous donne une carte !";
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    self.statusLabel.text = @"";
    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
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
        [self.cards addObject:beacon.minor];
        [self populateCardsView];
    }
}

#pragma mark - User interactions

- (IBAction)giveCard:(id)sender
{
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.peripheralManager stopAdvertising];
    UIButton *cardButton = (UIButton *)sender;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:cardButton.tag identifier:@"MaRegion"];
    // Get the beacon data to advertise
    self.beaconData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (IBAction)stopGivingCard:(id)sender {
    [self.peripheralManager stopAdvertising];
    [self monitorIBeacons];
}

#pragma mark - CBPeripheralManagerDelegate

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        [self.peripheralManager startAdvertising:self.beaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        [self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        NSLog(@"not supported");
    }
}


@end
