//
//  ContentViewController.m
//  AstroSign
//
//  Created by Olga on 2014-03-31.
//
//


/**  © 2014, Olga K. All Rights Reserved.
 *
 *  This file is part of the AstroSign project.
 *  You may use this file only for your personal, and non-commercial use.
 *  You may not modify or use the contents of this file for any purpose (other
 *  than as specified above) without the express written consent of the author.
 *  You may not reproduce, republish, post, transmit, publicly display,
 *  publicly perform, or distribute in print or electronically any of the contents
 *  of this file without express consent of rightful owner.
 *  This notice must be retained in all files and may not be removed.
 *  This License is subject to change at any time without notice/warning.
 *
 *						Author : Olga K.
 *						Contact: Olga.K@live.ca
 */

#import "ContentViewController.h"
#import "SignInfo.h"
#import "ImageCell.h"
#import "Utilities.h"

@interface ContentViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) Utilities* utility;

@property (nonatomic, strong) NSArray* signs;
@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) UIDatePicker* datePicker;
@end

@implementation ContentViewController
-(Utilities*) utility
{
    if (!_utility)
    {
        _utility = [[Utilities alloc] init];
    }
    return _utility;
}

-(UIDatePicker*) datePicker
{
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] init];
        CGRect datePickerBounds = CGRectMake(0, self.view.bounds.size.height - 180, [_datePicker sizeThatFits: CGSizeZero].width, 200);
        
        [_datePicker setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
        [_datePicker setDatePickerMode: UIDatePickerModeDate];
        [_datePicker addTarget: self action: nil forControlEvents: UIControlEventValueChanged];
        
        [_datePicker setFrame: datePickerBounds];
        [_datePicker setBackgroundColor: [UIColor whiteColor]];
    }
    return _datePicker;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (IBAction)onAboutClicked:(UIBarButtonItem *)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"About" message:@"This application was developed by Olga K, Brandon T, Marwa J.\n\n Horoscope data obtained from:\n http://my.horoscope.com/astrology/" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (IBAction)onHelpClicked:(UIBarButtonItem *)sender
{
    [self.view addSubview: self.datePicker];
    
    UITapGestureRecognizer* TapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDateSelected:)];
    
    [TapGestureRecognize setNumberOfTapsRequired: 1];
    [self.view addGestureRecognizer: TapGestureRecognize];
    [self.navigationItem.rightBarButtonItem setEnabled: false];
}

- (IBAction)onDateSelected:(UIGestureRecognizer *)sender
{
    [self.navigationItem.rightBarButtonItem setEnabled: true];
    [self.view removeGestureRecognizer: sender];
    [self.datePicker removeFromSuperview];

    NSDate* date = self.datePicker.date;
    NSString* index = [NSString stringWithFormat: @"%d", [self.utility getSignByDate: date]];
    [self performSegueWithIdentifier:@"SignInfo" sender: index];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.images = [self.utility LoadHoroscopeImages];
    self.signs = [self.utility Horoscopes];
    
    UIBarButtonItem* AboutButton = [[UIBarButtonItem alloc] initWithTitle: @"About" style:UIBarButtonItemStyleBordered target: self action: @selector(onAboutClicked:)];
    
    UIBarButtonItem* HelpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(onHelpClicked:)];
    
    self.navigationItem.leftBarButtonItem = AboutButton;
    self.navigationItem.rightBarButtonItem = HelpButton;
    self.navigationItem.title = @"AstroSign";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.signs count];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell* cell = [cv dequeueReusableCellWithReuseIdentifier:@"ContentCell" forIndexPath:indexPath];
    cell.imageView.image = self.images[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* index = [NSString stringWithFormat: @"%d", indexPath.item];
    [self performSegueWithIdentifier:@"SignInfo" sender: index];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SignInfo"])
    {
        if ([segue.destinationViewController isKindOfClass:[SignInfo class]])
        {
            SignInfo* svc = segue.destinationViewController;
            
            NSInteger index = [sender integerValue];
            
            [svc setLabelText: self.signs[index]];
            [svc setImage: self.images[index]];
        }
    }
}

@end
