//
//  IconService.m
//  ntt-test
//
//  Created by Alessandro Grigiante on 20/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import "IconService.h"
#import "Stargazer.h"

@interface IconService ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end


#pragma mark -

@implementation IconService

- (void)startDownload
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.stargazer.avatar_url]];
    
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            
            // Set appIcon and clear temporary data/image
            UIImage *image = [[UIImage alloc] initWithData:data];
        
            if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
            {
                CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [image drawInRect:imageRect];
                self.stargazer.iconImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else
            {
                self.stargazer.iconImage = image;
            }

            NSData *binaryImageData = UIImageJPEGRepresentation(image, 90.0f);
            NSArray *icoFileArray = [self.stargazer.avatar_url.lastPathComponent componentsSeparatedByString:@"?"];
            NSString *iconFileName = [NSString stringWithFormat:@"%@.jpg", icoFileArray[0]];

            [binaryImageData writeToFile:[kIconCachePath stringByAppendingPathComponent:iconFileName] atomically:YES];
            self.stargazer.iconFileName = iconFileName;
            
            // call out completion handler to tell that icon is ready for display
            if (self.completionHandler != nil)
            {
                self.completionHandler();
            }
        }];
    }];
    
    [self.sessionTask resume];
}

- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}



@end
