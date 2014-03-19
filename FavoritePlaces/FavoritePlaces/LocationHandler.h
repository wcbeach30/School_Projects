//
//  LocationHandler.h
//  Simple Locator
//
//  Created by Clay on 1/28/14.
//  Copyright (c) 2014 Clay Beach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol LocationHandlerDelegate <NSObject>
@required
-(void) didUpdateToLocation:(CLLocation*)newLocation
               fromLocation:(CLLocation*)oldLocation;
@end
@interface LocationHandler : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property(nonatomic,strong) id<LocationHandlerDelegate> delegate;
+(id)getSharedInstance;
-(void)startUpdating;
-(void) stopUpdating;
@end
