//
//  StartViewController.m
//  ntt-test
//
//  Created by Alessandro Grigiante on 18/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import "StartViewController.h"
#import "ListViewController.h"
#import "GitService.h"
#import "IconService.h"


@interface StartViewController ()

@property (strong, nonatomic) GitService *service;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *repo;


// IB outlets
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *repoTextField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation StartViewController



#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = NULL;
    if (![[NSFileManager defaultManager] fileExistsAtPath:kIconCachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:kIconCachePath withIntermediateDirectories:NO attributes:nil error:&error];
        if(error) {
            NSLog(@"ERROR! --> UNABLE TO CREATE ICONS CACHE DIRECTORY %@", error.localizedDescription);
        }
    }
    
    self.service = [[GitService alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _goButton.enabled = YES;
    [_spinner stopAnimating];
    
}

#pragma mark - Actions
- (IBAction)goAction:(UIButton *)sender {
    
    if ((_userTextField.text.length > 0) && (_repoTextField.text.length > 0) ){
        _user = _userTextField.text;
        _repo = _repoTextField.text;
        
        [_spinner startAnimating];
        sender.enabled = NO;
        [self performQuery:[NSString stringWithFormat:@"%@/%@", _user, _repo]];
    }
}

- (IBAction)retriveJsonAction:(UIButton *)sender {
    
    NSData *jsonData = [self.service.keyService loadSafeJson:kAppSecKey];
    if (jsonData != nil) {
        [self displayMessage:@"Secured Json" message:@"Successfully retrived!"];
        NSLog(@"Secured Json retrived --> %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    } else {
        [self displayMessage:@"Secured Json" message:@"Not found!"];
    }
    
}

- (IBAction)cleanJsonAction:(UIButton *)sender {
    
    [self.service.keyService deleteSafeJson:kAppSecKey];
}

- (void) performQuery:(NSString*)queryTxt {
    
    [self.service getRepoStargazers:queryTxt completionBlock:^(BOOL isCompletion) {
        if (isCompletion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
                [self performSegueWithIdentifier:@"gotoList" sender:self];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
                [self.goButton setEnabled:YES];
                [self displayMessage:@"Invalid request." message:@"No stargazer found!"];
            });
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"gotoList"]) {
        
        ListViewController *controller = segue.destinationViewController;
        controller.usersArray = self.service.usersArray;
        controller.user = self.user;
        controller.repo = self.repo;
    }
    
}


#pragma mark - Alert display message
- (void)displayMessage:(NSString *)aTitle message:(NSString *)message{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:aTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle: @"Cancel"
                                           style:UIAlertActionStyleDestructive
                                           handler:^(UIAlertAction *_Nonnull action) {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                           }]];
    alert.message = message;
    alert.popoverPresentationController.sourceView = self.view;
    [self presentViewController:alert animated:YES completion:nil];
}

@end
