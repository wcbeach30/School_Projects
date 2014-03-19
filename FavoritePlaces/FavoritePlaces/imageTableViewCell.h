//
//  imageTableViewCell.h
//  FavoritePlaces
//
//  Created by Clay on 3/11/14.
//  Copyright (c) 2014 Clay Beach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbImage;


@end
