//
//  detailViewController.m
//  FavoritePlaces
//
//  Created by Clay on 3/15/14.
//  Copyright (c) 2014 Clay Beach. All rights reserved.
//

#import "detailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface detailViewController ()

@end

@implementation detailViewController

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
	// Do any additional setup after loading the view.
    
    _locationName.text = _detailModal[0];
    _locationDescription.text = _detailModal[1];
    NSString *imagePath = _detailModal[2];
    _longitude.text = _detailModal[3];
    _latitude.text = _detailModal[4];
    
    ////HERE IS WHERE I WILL PUT THE ALASSETS LIBRARY TO DISPLAY THE IMAGE////
    if ( imagePath != nil && [imagePath hasPrefix:@"ass"])
    {
        NSLog(@"photo loaded from assets library");
        //testing ALAssestLibrary
        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset)
        {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            CGImageRef imageRef = [representation fullResolutionImage];
            UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
            
            _locationImage.image = image;
            
        
        };
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
            
            NSLog(@"FAILED! due to error in domain %@ with error code %d", error.domain, error.code);
            // This sample will abort since a shipping product MUST do something besides logging a
            // message. A real app needs to inform the user appropriately.
            abort();
        };
        
        //Convert path to an NSUrl
        NSURL *url = [NSURL URLWithString: imagePath];
        
        
        // Get the asset for the asset URL to create a screen image.
        [assetsLibrary assetForURL:url resultBlock:resultsBlock failureBlock:failureBlock];
    }

    ////END OF THE ALASSETS LIBRARY CODE
    //_locationImage.image = _detailModal[2];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
