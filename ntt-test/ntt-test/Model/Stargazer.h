//
//  Stargazer.h
//  ntt-test
//
//  Created by Alessandro Grigiante on 19/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Stargazer : NSObject

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *html_url;
@property (nonatomic, strong) NSString *iconFileName;
@property (nonatomic, strong) UIImage  *iconImage;

@end

