//
//  KeyChainService.m
//  ntt-test
//
//  Created by Alessandro Grigiante on 20/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import "KeyChainService.h"
#import <Security/Security.h>

@implementation KeyChainService

- (BOOL)checkStatus:(OSStatus)status {
    return status == noErr;
}

- (NSMutableDictionary *)keychainQueryForKey:(NSString *)key {
    return [@{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
              (__bridge id)kSecAttrService : key,
              (__bridge id)kSecAttrAccount : key,
              (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock
              } mutableCopy];
}

- (BOOL)saveSafeJson:(id)object forKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    // Deleting previous object with this key, because SecItemUpdate is more complicated.
    [self deleteSafeJson:key];
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:NO error:0] forKey:(__bridge id)kSecValueData];
    return [self checkStatus:SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL)];
}

- (id)loadSafeJson:(NSString *)key {
    id object = nil;
    
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if ([self checkStatus:SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData)]) {
        @try {
            object = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSData class] fromData:(__bridge NSData *)keyData error:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"Unarchiving for key %@ failed with exception %@", key, exception.name);
            object = nil;
        }
        @finally {}
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return object;
}


- (BOOL)deleteSafeJson:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    return [self checkStatus:SecItemDelete((__bridge CFDictionaryRef)keychainQuery)];
}
@end
