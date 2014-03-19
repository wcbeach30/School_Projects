//
//  Author.h
//  FirstTableProject
//
//  Created by Kevin Languedoc on 12/5/11.
//  Copyright (c) 2011 kCodebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject{
    NSString *name;
    NSString *des;
    NSString *locImageURL;
    NSString *locLatitude;
    NSString *locLongitude;
    NSString *locID;
}

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *des;
@property(nonatomic, copy) NSString *locImageURL;
@property(nonatomic, copy) NSString *locLatitude;
@property(nonatomic, copy) NSString *locLongitude;
@property(nonatomic, copy) NSString *locID;


@end
