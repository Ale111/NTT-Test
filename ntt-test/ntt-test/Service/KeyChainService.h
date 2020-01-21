//
//  KeyChainService.h
//  ntt-test
//
//  Created by Alessandro Grigiante on 20/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAppSecKey @"3c36be450565d1c923d0d24947989b32"

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainService : NSObject
- (BOOL)saveSafeJson:(id)object forKey:(NSString *)key;
- (id)loadSafeJson:(NSString *)key;
- (BOOL)deleteSafeJson:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
