//
//  addLocationViewController.h
//  FavoritePlaces
//
//  Created by Clay on 3/2/14.
//  Copyright (c) 2014 Clay Beach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationHandler.h"

@interface addLocationViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *locName;
@property (weak, nonatomic) IBOutlet UITextView *locDescription;


@property (weak, nonatomic) NSString *locImageUrl;
@property (strong, nonatomic) NSString *databasePath;
@property (weak, nonatomic) NSString *locLatitude;
@property (weak, nonatomic) NSString *locLongitude;

@property (nonatomic) sqlite3 *locationDB;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *saveData;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *useCameraRoll;
@property BOOL newPic;

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;


@end
