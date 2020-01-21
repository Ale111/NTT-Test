//
//  GitService.h
//  ntt-test
//
//  Created by Alessandro Grigiante on 18/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyChainService.h"

NS_ASSUME_NONNULL_BEGIN
@class GitService;




@interface GitService : NSObject
- (void)getRepoStargazers:(NSString*)queryString completionBlock:(void (^)(BOOL isCompletion)) completionHandler;
@property (strong, nonatomic) NSMutableArray *usersArray;
@property (strong, nonatomic) KeyChainService *keyService;

@end

NS_ASSUME_NONNULL_END
