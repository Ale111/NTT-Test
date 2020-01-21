//
//  ListViewController.h
//  ntt-test
//
//  Created by Alessandro Grigiante on 18/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListViewController : UITableViewController
@property (weak, nonatomic) NSMutableArray *usersArray;
@property (weak, nonatomic) NSString *user;
@property (weak, nonatomic) NSString *repo;
@end

NS_ASSUME_NONNULL_END
