//
//  ListViewController.m
//  ntt-test
//
//  Created by Alessandro Grigiante on 18/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "Stargazer.h"
#import "IconService.h"

@interface ListViewController ()

@end

@implementation ListViewController

NSMutableDictionary *imageDownloadsInProgress;

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.title = [NSString stringWithFormat:@"Stargazers @ repo %@", self.repo];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.usersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Stargazer *sg = self.usersArray[indexPath.row];
    [cell.textLabel setText: sg.login];
    
    // Only load cached images; defer new downloads until scrolling ends
    if (sg.iconImage == nil)
    {
        NSArray *icoFileArray = [sg.avatar_url.lastPathComponent componentsSeparatedByString:@"?"];
        sg.iconFileName = [NSString stringWithFormat:@"%@.jpg", icoFileArray[0]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[kIconCachePath stringByAppendingPathComponent:sg.iconFileName]]) {
            [cell.imageView setImage:[UIImage imageNamed:@"placeholder"]];
            [self startIconDownload:tableView userRecord:sg forIndexPath:indexPath];
        }else{
            cell.imageView.image = sg.iconImage = [UIImage imageWithContentsOfFile:[kIconCachePath stringByAppendingPathComponent:sg.iconFileName]];
        }
    }else{
        cell.imageView.image = sg.iconImage;
    }
    
    return cell;
}


#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Stargazer *sg = self.usersArray[indexPath.row];
    [self performSegueWithIdentifier:@"gotoDetail" sender:sg.html_url];
    
}

#pragma mark - Table cell image support

- (void)startIconDownload:(UITableView *)tableView userRecord:(Stargazer *)userRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconService *iconService = (imageDownloadsInProgress)[indexPath];
    if (iconService == nil) {
        iconService = [[IconService alloc] init];
        iconService.stargazer = userRecord;
        [iconService setCompletionHandler:^{
            
            UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = userRecord.iconImage;
            [imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (imageDownloadsInProgress)[indexPath] = iconService;
        [iconService startDownload];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"gotoDetail"]) {
        
        DetailViewController *controller = segue.destinationViewController;
        controller.userHtmlUrl = (NSString *)sender;
       
    }
}

@end
