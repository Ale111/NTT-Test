//
//  IconService.h
//  ntt-test
//
//  Created by Alessandro Grigiante on 20/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kAppIconSize 40
#define kIconCachePath [NSString pathWithComponents:@[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"ntttest"]]


@class Stargazer;

@interface IconService : NSObject

@property (nonatomic, strong) Stargazer *stargazer;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end

NS_ASSUME_NONNULL_END
