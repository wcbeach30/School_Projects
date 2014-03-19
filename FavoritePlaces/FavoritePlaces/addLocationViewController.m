//
//  addLocationViewController.m
//  FavoritePlaces
//
//  Created by Clay on 3/2/14.
//  Copyright (c) 2014 Clay Beach. All rights reserved.
//

#import "addLocationViewController.h"

@interface addLocationViewController() 

@end

@implementation addLocationViewController
@synthesize locName = _locName;
@synthesize locDescription = _locDescription;
@synthesize locImageUrl = _locImageUrl;
@synthesize latitudeLabel = _latitudeLabel;
@synthesize longitudeLabel = _longitudeLabel;
@synthesize locLatitude = _locLatitude;
@synthesize locLongitude = _locLongitude;
NSURL *imageURL;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    UITextView *textView = [[UITextView alloc] init];
    textView.delegate = self;
    [self.view addSubview:textView];
    
    
    //simple locater script
    [[LocationHandler getSharedInstance]setDelegate:self];
    [[LocationHandler getSharedInstance]startUpdating];

	// Do any additional setup after loading the view.
    
    [super viewDidLoad];
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"locations.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_locationDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS LOCATIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, LOCATIONNAME TEXT, LOCATIONDESCRIPTION TEXT, LOCATIONIMAGEURL TEXT, LATITUDE TEXT, LONGITUDE TEXT)";
            
            if (sqlite3_exec(_locationDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                _status.text = @"Failed to create table";
            }
            sqlite3_close(_locationDB);
        } else {
            _status.text = @"Failed to open/create database";
        }
    }
    
    // Do any additional setup after loading the view, typically from a nib.

}

//clear text of description box when clicked on
- (void) textViewDidBeginEditing:(UITextView *) textView {
    [textView setText:@""];
    
    
    //other awesome stuff here...
}

-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
    [_latitudeLabel setText:[NSString stringWithFormat:
                             @"%f",newLocation.coordinate.latitude]];
    [_longitudeLabel setText:[NSString stringWithFormat:
                              @"%f",newLocation.coordinate.longitude]];
    //may also need to add the date and time
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)validateInput{
    
    BOOL retvalue=YES;
    NSString *throwmessage;
    if ([_locName.text isEqualToString:@""] || _locName.text==nil )
        
    {
        throwmessage=@"Please Enter Location Name";
        retvalue=NO;
    }
    
    else if ([_locDescription.text isEqualToString:@"Description of location"] || _locDescription.text==nil ||[_locDescription.text isEqualToString:@""])
        
    {
        throwmessage=@"Please Enter A Description ";
        retvalue=NO;
    }
    
    else if ([_latitudeLabel.text isEqualToString:@""] || _latitudeLabel.text==nil )
        
    {
        throwmessage=@"Please Turn on location services ";
        retvalue=NO;
    }
    
    else if ([_longitudeLabel.text isEqualToString:@""] || _longitudeLabel.text==nil )
        
    {
        throwmessage=@"Please Turn on location services ";
        retvalue=NO;
    }
    
    else if (_imageView.image == nil)
        
    {
        throwmessage=@"Please select an image ";
        retvalue=NO;
    }

    
    
       if (retvalue==NO)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:throwmessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    return  retvalue;
    
}

- (IBAction)saveData:(id)sender {
    
    if ([self validateInput]) {
        
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_locationDB) == SQLITE_OK)
    {
        //self.locLatitude = [NSString [self.latitudeLabel.text]];
        //self.locLongitude = [NSString [self.longitudeLabel.text]];
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO LOCATIONS (LOCATIONNAME, LOCATIONDESCRIPTION, LOCATIONIMAGEURL, LATITUDE, LONGITUDE) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                               self.locName.text, self.locDescription.text, [imageURL absoluteString], self.latitudeLabel.text, self.longitudeLabel.text];
        
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_locationDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            self.status.text = @"Location added";
            self.locName.text = @"";
            self.locDescription.text = @"";
            //self.locImageUrl = @"";
            _imageView.image = nil;
            self.latitudeLabel.text = @"";
            self.longitudeLabel.text = @"";
            
        } else {
            self.status.text = @"Failed to add location";
        }
        sqlite3_finalize(statement);
        sqlite3_close(_locationDB);
       // [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
    } else{
       self.status.text = @"Location not added";
    }
    
}
    
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)useCameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newPic = NO;
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        UIImage *modifiedImage = [self squareImageWithImage:image scaledToSize:CGSizeMake(284, 484)];
        _imageView.image = modifiedImage;
        if (_newPic)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    
    //stores the image url then we use this in the SQL insert statement and convert it to text
    imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
   }

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //this will scale and crop.
    
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);//newSize is the size of the image view
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        //remember image is the frame, newsize is the actual picture
        delta = (ratio*image.size.width - ratio*image.size.height);
        //most of my pics are 4/3 or 1.33 * image width(640) - 4/3 * image height(480)
        offset = CGPointMake(delta/2, 0); //for the crop
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    //if there is no error: see resondsToSelector Docs
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);//dynamically draw in new rectangle and add the picture to it
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
