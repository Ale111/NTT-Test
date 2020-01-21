//
//  GitService.m
//  ntt-test
//
//  Created by Alessandro Grigiante on 18/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import "GitService.h"
#import "GitApi.h"
#import "Stargazer.h"


@interface GitService()

@end

@implementation GitService

@synthesize usersArray;


- (instancetype)init {
    self = [super init];
    if (self) {
        self.usersArray = [[NSMutableArray alloc] init];
        self.keyService = [[KeyChainService alloc] init];
    }
    return self;
}

- (void)getRepoStargazers:(NSString*)queryString completionBlock:(void (^)(BOOL isCompletion)) completionHandler {
    
    NSString *fullQueryString = [NSString stringWithFormat:@"%@/%@/%@/%@",kGitBaseURL, kGitQueryPath, queryString, kApiQueryTypePath];
    NSMutableURLRequest *request = [ NSMutableURLRequest requestWithURL:[NSURL URLWithString: fullQueryString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completionHandler(NO);
            return;
        }
        
        // handle HTTP errors here
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                completionHandler(NO);
                return;
            } else {
                // Saving the Json in a safe way by KeyChain
                [self.keyService saveSafeJson:data forKey:kAppSecKey];
                
                if ([self fetchJSON:data]) {
                    completionHandler(YES);
                } else {
                    completionHandler(NO);
                    return;
                }
            }
        }
        
        }] resume];

}

// fetch the JSON and store in Stargazer class
- (BOOL) fetchJSON:(NSData *)data {

    NSError *error = nil;
    Stargazer *stargazer = nil;
    
@autoreleasepool {
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    // parse the JSON and store in array
    [self.usersArray removeAllObjects];
    for (NSDictionary* item in jsonArray) {
        stargazer = nil;
        stargazer = [[Stargazer alloc] init];
        stargazer.login = item[@"login"];
        stargazer.html_url = item[@"html_url"];
        stargazer.avatar_url = item[@"avatar_url"];
        
        
        [self.usersArray addObject:stargazer];
    }
  }
    if (error == nil) {
        return YES;
    } else {
        return NO;
    }
    
}
@end
