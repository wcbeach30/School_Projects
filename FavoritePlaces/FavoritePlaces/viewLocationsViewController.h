//
//  viewLocationsViewController.h
//  FavoritePlaces
//
//  Created by Clay on 3/3/14.
//  Copyright (c) 2014 Clay Beach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface viewLocationsViewController : UITableViewController{
    NSMutableArray *thelocations;
    sqlite3 *locationsDB;
    
}
@property(nonatomic,retain) NSMutableArray *thelocations;

-(NSMutableArray *) locationsList;

@end
