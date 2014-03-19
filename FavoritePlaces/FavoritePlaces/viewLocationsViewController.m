//
//  viewLocationsViewController.m
//  FavoritePlaces
//
//  Created by Clay on 3/3/14.
//  Copyright (c) 2014 Clay Beach. All rights reserved.
//

#import "viewLocationsViewController.h"
#import "Location.h"
#import "imageTableViewCell.h"
#import "detailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>



@interface viewLocationsViewController ()
@property(nonatomic, strong) NSArray *assets;
@end

@implementation viewLocationsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self locationsList];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    NSLog(@"Deleted row.");
    sqlite3_stmt    *statement;
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    //NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"locations.db"];
    
    NSArray *dbPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dbPath[0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"locations.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    
    long rowCount = indexPath.row;
    Location *myLocation = [self.thelocations objectAtIndex:rowCount];

    if (sqlite3_open(dbpath, &locationsDB) == SQLITE_OK)
    {
        //self.locLatitude = [NSString [self.latitudeLabel.text]];
        //self.locLongitude = [NSString [self.longitudeLabel.text]];
        NSString *deleteSQL = [NSString stringWithFormat: @"DELETE FROM LOCATIONS WHERE (ID) = ( \"%@\")", myLocation.locID];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(locationsDB, delete_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            [self locationsList];
            [self.tableView reloadData];
            
        } else {
            //[self.tableView reloadData];
        }
        sqlite3_finalize(statement);
        sqlite3_close(locationsDB);
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


//Start loading the image using the image path


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.thelocations count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationsCell";
   
    imageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[imageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    long rowCount = indexPath.row;
    
    Location *myLocation = [self.thelocations objectAtIndex:rowCount];
    
     ///////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
    if ( myLocation.locImageURL != nil && [myLocation.locImageURL hasPrefix:@"ass"])
    {
        NSLog(@"photo loaded from assets library");
        //testing ALAssestLibrary
        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset)
        {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            CGImageRef imageRef = [representation fullResolutionImage];
            UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
            
            
            
            cell.titleLabel.text = myLocation.name;
            cell.descriptionLabel.text = myLocation.des;
            cell.thumbImage.image = image;
            
        };
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
            
            NSLog(@"FAILED! due to error in domain %@ with error code %d", error.domain, error.code);
            // This sample will abort since a shipping product MUST do something besides logging a
            // message. A real app needs to inform the user appropriately.
            abort();
        };
        
        //Convert path to an NSUrl
        NSURL *url = [NSURL URLWithString: myLocation.locImageURL];
        
        
        // Get the asset for the asset URL to create a screen image.
        [assetsLibrary assetForURL:url resultBlock:resultsBlock failureBlock:failureBlock];
            }
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showLocation"]) {
        detailViewController *detailviewcontroller = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        long row = [myIndexPath row];
        
        // create an array to send to detail view
        Location *myLocation = [self.thelocations objectAtIndex:row];
        NSString *locname = [myLocation name];
        NSString *locdescription = [myLocation des];
        NSString *locimage = [myLocation locImageURL];
        NSString *latitude = [myLocation locLatitude];
        NSString *longitude = [myLocation locLongitude];
        NSMutableArray *locationArray = [[NSMutableArray alloc] initWithObjects:locname, locdescription, locimage,latitude, longitude, nil];
        
    
        
        detailviewcontroller.detailModal = locationArray;
        
        
        
    }
}


-(NSMutableArray *) locationsList{
        _thelocations = [[NSMutableArray alloc] initWithCapacity:10];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        //NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"locations.db"];
        
        NSArray *dbPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = dbPath[0];
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"locations.db"]];
        const char *dPath = [databasePath UTF8String];
        
        BOOL success = [fileMgr fileExistsAtPath:databasePath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open(dPath, &locationsDB) == SQLITE_OK))
        {
            NSLog(@"An error has occured: %s", sqlite3_errmsg(locationsDB));
            success = FALSE;
        }
        
        
        const char *sql = "SELECT * FROM  LOCATIONS";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(locationsDB, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:(prepare)  %s", sqlite3_errmsg(locationsDB));
        }else{
            Location *myLocation;
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                myLocation = [[Location alloc] init];
                myLocation.locID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
                myLocation.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
                myLocation.des = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)];
                myLocation.locImageURL = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
                myLocation.locLatitude = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
                myLocation.locLongitude = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
                [self.thelocations addObject:myLocation];
                                myLocation=nil;
            }
                    }
        sqlite3_finalize(sqlStatement);
        
    }
    @catch (NSException *exception) {
        NSLog(@"Problem with prepare statement catch:  %s", sqlite3_errmsg(locationsDB));
    }
    @finally {
        
        sqlite3_close(locationsDB);
        return self.thelocations;
    }
}
@end
