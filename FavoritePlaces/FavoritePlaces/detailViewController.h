//
//  detailViewController.h
//  FavoritePlaces
//
//  Created by Clay on 3/15/14.
//  Copyright (c) 2014 Clay Beach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface detailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *locationName;
@property (strong, nonatomic) IBOutlet UILabel *locationDescription;
@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *latitude;

@property (nonatomic) sqlite3 *locationDB;

@property (strong, nonatomic) NSArray *detailModal;
@end
