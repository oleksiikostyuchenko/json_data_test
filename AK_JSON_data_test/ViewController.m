//
//  ViewController.m
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/20/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import "ViewController.h"
#import "AKLoaderController.h"
#import "AKDataBaseController.h"
#import "AKFilterController.h"
#import "AKAppointmentModel.h"
#import "AKAppointmentTypeModel.h"
#import "AKUserModel.h"
#import "NSDate+AKNSDateExtension.h"

@interface ViewController () <UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) __block NSArray *apptsArray;
@property (nonatomic, strong) __block NSArray *apptsTypesArray;
@property (nonatomic, strong) __block NSArray *usersArray;
@property (nonatomic, strong) IBOutlet UITableView *theApptsTableView;
@property (nonatomic, strong) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) AKDataBaseController *dbLoader;
@property (nonatomic, strong) AKFilterController *filterController;
@property (nonatomic, strong) AKLoaderController *loaderController;
@property (nonatomic, strong) __block UIActivityIndicatorView
	*activityIndicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.dbLoader = [AKDataBaseController new];
	self.filterController = [AKFilterController new];

	UISwitch *theSwitch = [UISwitch new];
	[theSwitch addTarget:self action:@selector(switchToggled:)
		forControlEvents: UIControlEventValueChanged];
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]
		initWithCustomView:theSwitch];
	self.navigationItem.leftBarButtonItem = leftItem;
	self.title = @"Appointments";

	self.searchTextField.delegate = self;
	self.searchTextField.placeholder = @"search";

	self.loaderController = [AKLoaderController new];

	self.activityIndicatorView = [[UIActivityIndicatorView
		alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicatorView.center = self.view.center;
	[self.view addSubview:self.activityIndicatorView];
	[self.view bringSubviewToFront:self.activityIndicatorView];
	[self.activityIndicatorView startAnimating];

	[self.loaderController loadAppointmentsWithCompletion:^(NSError *error) {
		[self.activityIndicatorView stopAnimating];
		[self.dbLoader loadAllEntetiesFromDBWithCompletion:^(NSArray *aAppts,
			NSArray *aApptsTypes, NSArray *aUsers) {
			self.apptsArray = aAppts;
			self.apptsTypesArray = aApptsTypes;
			self.usersArray = aUsers;
			[self.theApptsTableView reloadData];
		}];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];	
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView
		dequeueReusableCellWithIdentifier:CellIdentifier];
	cell.textLabel.font = [UIFont systemFontOfSize:15.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
			initWithStyle:UITableViewCellStyleSubtitle
		reuseIdentifier:CellIdentifier];
	}

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	AKAppointmentModel *theApptmentModel = self.apptsArray[indexPath.row];
	AKAppointmentTypeModel *theApptmentTypeModel = nil;
	AKUserModel *theUserModel = nil;

	for (AKAppointmentTypeModel *theModel in self.apptsTypesArray) {
		if (theApptmentModel.appointmentType ==
			theModel.appointmentID) {
			theApptmentTypeModel = theModel;
		}
	}
	for (AKUserModel *theModel in self.usersArray) {
		if (theApptmentModel.relatedUserID == theModel.userID) {
			theUserModel = theModel;
		}
	}

	cell.textLabel.text = [theApptmentTypeModel appointmentType];
	if (theApptmentModel.isConfirmed) {
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];;
	}
	cell.detailTextLabel.text =
	[NSString stringWithFormat:@"%@ %@ Start: %@ Finish : %@",
		theUserModel.name,
		theUserModel.surname ,
		[NSDate stringWithDate:[self.apptsArray[indexPath.row]
			appointmentStartDate]],
	    [NSDate stringWithDate:[self.apptsArray[indexPath.row]
			appointmentEndDate]]];

	[self.loaderController loadImageWithURL:[NSURL
		URLWithString:theUserModel.userPictureURL]
		completion:^(NSError *error, UIImage *image) {
			dispatch_async(dispatch_get_main_queue(), ^{
				cell.imageView.image = image;
				[cell setNeedsLayout];
			});		
	}];

	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
	numberOfRowsInSection:(NSInteger)section {
	return [self.apptsArray count];
}

#pragma mark - Actions

- (void)searchForTerm:(NSString *)aSearchTerm {
	self.apptsArray = [self.filterController
		searchForApptsForUsersWithSearchValue:aSearchTerm
		inApptsArray:self.apptsArray usersArray:self.usersArray];
	[self.theApptsTableView reloadData];
}


#pragma mark - UISwitch

- (void) switchToggled:(id)sender {
	UISwitch *mySwitch = (UISwitch *)sender;
	if ([mySwitch isOn]) {
		self.apptsArray = [self.filterController
			showOnlyConfirmedAppointmentsForApptsArray:self.apptsArray];
		[self.theApptsTableView reloadData];
	} else {
		[self.dbLoader loadAllEntetiesFromDBWithCompletion:^(NSArray *aAppts,
			NSArray *aApptsTypes, NSArray *aUsers) {
			self.apptsArray = aAppts;
			[self.theApptsTableView reloadData];
		}];		
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
	[textField resignFirstResponder];
	[self searchForTerm:textField.text];
	return YES;
}

@end
