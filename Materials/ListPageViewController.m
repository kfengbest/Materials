//
//  ListPageViewController.m
//  Materials
//
//  Created by Kaven Feng on 3/13/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import "ListPageViewController.h"

#import"MKNetworkKit.h"
#import "XMLReader/XMLReader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MaterialDetailsViewController.h"

#define kCountPerPage 10


@interface ListPageViewController ()
{
    NSMutableArray* materials;
    UIActivityIndicatorView* indicator;
    PWLoadMoreTableFooterView *_loadMoreFooterView;
	BOOL _datasourceIsLoading;
    int _currentPageIndex;
}

@end

@implementation ListPageViewController
@synthesize classification, totalSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init variables.
    _currentPageIndex = 0;
    materials = [[NSMutableArray alloc] init];

    // config indicator.
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    indicator.backgroundColor = [UIColor grayColor];
    indicator.alpha = 0.9;
    indicator.layer.cornerRadius = 6;
    indicator.layer.masksToBounds = YES;
    [self.view addSubview:indicator];
    
    //config the load more view
    if (_loadMoreFooterView == nil) {
		
		PWLoadMoreTableFooterView *view = [[PWLoadMoreTableFooterView alloc] init];
		view.delegate = self;
		_loadMoreFooterView = view;
		
	}
    self.tableView.tableFooterView = _loadMoreFooterView;
    
    //config navigation item
    NSString* name = self.classification;
    NSRange range = [name rangeOfString:@"Autodesk.Material Classifications."];
    if (range.location != NSNotFound) {
        name = [name substringFromIndex:range.length];
    }
    self.navigationItem.title = name;

    // load material data from cloud
    [self pwLoadMore];
}

- (void) loadData : (int) pageIndex
{
    /*
    http://exchange.services-staging.autodesk.com/Search/restapi/v1/contents?q=compoCategoryL2:%22Autodesk.Material%20Classifications.Fabric%22&facet=true&facet.field=compoCategoryL2&facet.field=compoCategoryL3&start=0&rows=20&detail=2&sort=name_sort%20asc&fq=%2Bcategory:(adsk.2.1.1%20adsk.2.1.2)&access_token=GC---Y0DMq0bzUwoyIAagT6qG1L9kHI
  
    */
    
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"exchange.services-staging.autodesk.com" customHeaderFields:nil];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    NSString* qValue = [NSString stringWithFormat:@"%@:\"%@\"",@"compoCategoryL2", self.classification];
    NSString *strStart = [NSString stringWithFormat:@"%d",pageIndex * kCountPerPage];
    NSString *strRows = [NSString stringWithFormat:@"%d",kCountPerPage];
    
    [dic setObject: qValue forKey:@"q"];
    [dic setObject: @"true" forKey:@"facet"];
    [dic setObject: @"compoCategoryL2" forKey:@"facet.field"];
    [dic setObject: strStart forKey:@"start"];
    [dic setObject: strRows forKey:@"rows"];
    [dic setObject: @"2" forKey:@"detail"];
    [dic setObject: @"name_sort asc" forKey:@"sort"];
    [dic setObject: @"GC---Y0DMq0bzUwoyIAagT6qG1L9kHI" forKey:@"access_token"];
    
    MKNetworkOperation *op = [engine operationWithPath:@"/Search/restapi/v1/contents" params:dic httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSData* data = [operation responseData];
        NSError *error = nil;
        
        NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        
        if (dict != NULL && [dict count] == 1) {
            NSDictionary* listDic = [dict objectForKey:@"list"];
            if (listDic != NULL) {
                
                NSString* strSize = [listDic objectForKey:@"size"];
                NSInteger nSize = [strSize integerValue];
                if (nSize == 1) {
                    NSDictionary* item = [listDic objectForKey:@"content"];
                    [materials addObject:item];
                } else if(nSize > 1){
                    NSArray* contentArray = [listDic objectForKey:@"content"];
                    [materials addObjectsFromArray:contentArray];
                }
                
                
                [self doneLoadingTableViewData];
            }
        }
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {

        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [materials count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellInListPage";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* item  = materials[indexPath.row];
    NSString* strImageUri = [[[item objectForKey:@"images"] objectForKey:@"image"] objectForKey:@"uri"];
    NSString* strAuthedUri = [NSString stringWithFormat:@"%@%@", strImageUri, @"?access_token=GC---Y0DMq0bzUwoyIAagT6qG1L9kHI"];
    
    cell.textLabel.text = [[item objectForKey:@"title"] objectForKey:@"text"];
    cell.detailTextLabel.text = [[item objectForKey:@"description"] objectForKey:@"text"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:strAuthedUri] placeholderImage: [UIImage imageNamed:@"LoadingPlaceHolder.png" ]];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"List2DetailSegue"])
    {
        MaterialDetailsViewController *detailViewController = [segue destinationViewController];
        NSIndexPath* indexPath = (NSIndexPath*)[self.tableView indexPathsForSelectedRows][0];
        NSDictionary* item  = materials[indexPath.row];
        detailViewController.contentId = [item objectForKey:@"contentId"];
    }
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	[_loadMoreFooterView pwLoadMoreTableDataSourceDidFinishedLoading];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark PWLoadMoreTableFooterDelegate Methods

- (void)pwLoadMore {
    //just make sure when loading more, DO NOT try to refresh your data
    //Especially when you do your work asynchronously
    //Unless you are pretty sure what you are doing
    //When you are refreshing your data, you will not be able to load more if you have pwLoadMoreTableDataSourceIsLoading and config it right
    _datasourceIsLoading = YES;
    [self loadData:_currentPageIndex];
    _currentPageIndex++;
	_datasourceIsLoading = NO;
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}


- (BOOL)pwLoadMoreTableDataSourceIsLoading {
    return _datasourceIsLoading;
}
- (BOOL)pwLoadMoreTableDataSourceAllLoaded {
    return self.totalSize <= _currentPageIndex * kCountPerPage;
}
@end
