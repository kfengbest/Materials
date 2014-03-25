//
//  MaterialDetailsViewController.h
//  Materials
//
//  Created by Kaven Feng on 3/5/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)onSegmentChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCtrl;
@property (nonatomic,strong)NSString* contentId;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *LibraryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@end
