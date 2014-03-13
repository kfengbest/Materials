//
//  ListPageViewController.m
//  Materials
//
//  Created by Kaven Feng on 3/13/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import "ListPageViewController.h"
#import "CellInListPage.h"

@interface ListPageViewController ()

@end

@implementation ListPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* MyCellID = @"CellInListPage";
    CellInListPage* newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MyCellID
                                                                                   forIndexPath:indexPath];
    return newCell;
}

@end
