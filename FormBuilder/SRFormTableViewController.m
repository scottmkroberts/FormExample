//
//  SRFormTableViewController.m
//  FormBuilder
//
//  Created by Scott Roberts on 20/05/2014.
//  Copyright (c) 2014 scottr. All rights reserved.
//

#import "SRFormTableViewController.h"
#import "SRTimerPicker.h"
#import "SRFormSelectTableViewController.h"

typedef NS_ENUM(NSInteger, UITableViewCellType){
    UITableViewCellTypeDate,
    UITableViewCellTypeTime,
    UITableViewCellTypeDecimal,
    UITableViewCellTypeText,
    UITableViewCellTypeCustom,
    UITableViewCellTypeBool,
    UITableViewCellTypeSelect
};

typedef NS_ENUM(NSInteger, UIPickerType){
    UIPickerTypeDate,
    UIPickerTypeTime,
    UIPickerTypeCustom
};

// Data Constants
static NSString *kTitleKey = @"title";
static NSString *kValueKey = @"value";
static NSString *kTypeKey = @"type";

// General Cell Identifiers Constants
static NSString *kGeneralCellID = @"generalCellID";
static NSString *kDateCellID = @"dateCellID";
static NSString *kTimeCellID = @"timeCellID";
static NSString *kTextCellID = @"textCellID";
static NSString *kDecimalCellID = @"decimalCellID";
static NSString *kBoolCellID = @"boolCellID";
static NSString *kCustomCellID = @"customCellID";
static NSString *kSelectCellID = @"selectCellID";

// Picker Cell Indentifier Constants
static NSString *kDatePickerCellID = @"datePickerCellID";
static NSString *kTimePickerCellID = @"timePickerCellID";
static NSString *kCustomPickerCellID = @"customPickerCellID";

#define kDatePickerTag  98     // view tag identifiying the date picker view
#define kCustomPickerTag  99     // view tag identifiying the Custom picker view

#pragma mark - 

@interface SRFormTableViewController () <UITextFieldDelegate, SRTimerPickerDelegate>

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *timeFormatter;

@property (nonatomic) UITextField *textfield;
@property (nonatomic) BOOL keyboardIsShowing;

@property (nonatomic) UITableViewCell *selectedCell;

@property (nonatomic) UIPickerType pickerType;
@property (nonatomic) NSIndexPath *pickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;
@property (nonatomic) NSArray *tableData;
@end

#pragma mark -

@implementation SRFormTableViewController

#pragma mark - Inline Picker Helpers

- (BOOL)hasInlinePicker{
    return (self.pickerIndexPath != nil);
}

- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlinePicker] && self.pickerIndexPath.row == indexPath.row);
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *pickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    
    if(self.pickerType == UIPickerTypeDate || self.pickerType == UIPickerTypeTime){
        UIDatePicker *checkDatePicker = (UIDatePicker *)[pickerCell viewWithTag:kDatePickerTag];
        hasDatePicker = (checkDatePicker != nil);
    }else if(self.pickerType == UIPickerTypeCustom){
        SRTimerPicker *checkCustomPicker =  (SRTimerPicker *)[pickerCell viewWithTag:kCustomPickerTag];
        hasDatePicker = (checkCustomPicker != nil);
    }
    
    return hasDatePicker;
}

#pragma mark - Update Pickers

- (void)updateDatePicker{
    if (self.pickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            NSDictionary *itemData = self.tableData[self.pickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kValueKey] animated:NO];
        }
    }
}

-(void)updateCustomPicker{
    
    if (self.pickerIndexPath != nil)
    {
        UITableViewCell *associatedCustomPickerCell = [self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
        
        SRTimerPicker *targetedCustomPicker = (SRTimerPicker *)[associatedCustomPickerCell viewWithTag:kCustomPickerTag];
        
        if (targetedCustomPicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            NSDictionary *itemData = self.tableData[self.pickerIndexPath.row - 1];
            NSString *value = [itemData valueForKey:kValueKey];
            NSArray *listItems = [value componentsSeparatedByString:@":"];
            float Hours = [[listItems objectAtIndex:0] floatValue];
            float Minutes = [[listItems objectAtIndex:1] floatValue];
            float Seconds = [[listItems objectAtIndex:2] floatValue];

            
            [targetedCustomPicker selectRow:Hours inComponent:0 animated:YES];
            [targetedCustomPicker selectRow:Minutes inComponent:1 animated:YES];
            [targetedCustomPicker selectRow:Seconds inComponent:2 animated:YES];

        }
    }
    
}

#pragma mark - Data

-(NSNumber *)numberWithType:(UITableViewCellType)cellType{
    return [NSNumber numberWithInteger:cellType];
}

-(NSArray *)setupDemoData{
    
    NSDictionary *itemOne = @{ kTitleKey : @"Date Example",
                                kValueKey : [NSDate date],
                                kTypeKey : [self numberWithType:UITableViewCellTypeDate] };
    
    NSDictionary *itemTwo = @{ kTitleKey : @"Text Example" ,
                                kValueKey : @"test",
                                kTypeKey : [self numberWithType:UITableViewCellTypeText] };
    
    NSDictionary *itemThree = @{ kTitleKey : @"Decimal Example",
                                 kValueKey : @"0.0",
                                 kTypeKey : [self numberWithType:UITableViewCellTypeDecimal] };
    
    NSDictionary *itemFour = @{ kTitleKey : @"Time Example",
                                kValueKey : [NSDate date],
                                kTypeKey : [self numberWithType:UITableViewCellTypeTime] };

    NSDictionary *itemFive = @{ kTitleKey : @"Custom Example",
                                kValueKey :@"01:50:00",
                                kTypeKey : [self numberWithType:UITableViewCellTypeCustom] };

    NSDictionary *itemSix = @{ kTitleKey : @"BOOL Example",
                               kValueKey : [NSNumber numberWithBool:YES],
                               kTypeKey : [self numberWithType:UITableViewCellTypeBool] };
    
//    NSDictionary *itemSeven = @{ kTitleKey : @"Select Example",
//                                  kValueKey : @"Item 1",
//                                  kTypeKey : [self numberWithType:UITableViewCellTypeSelect] };
    
    
    return @[itemOne, itemTwo, itemThree, itemFour, itemFive, itemSix];
}

#pragma mark - 
#pragma mark init

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
    
    self.title = @"Form";
    self.pickerCellRowHeight = 160;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableData = [self setupDemoData];
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"HH:mm:ss"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];

    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
}

#pragma mark - Locale

- (void)localeChanged:(NSNotification *)notif
{
    [self.tableView reloadData];
}

#pragma mark - Cell Identifier helpers

-(NSString *)cellIdentifierForForPickerType:(UIPickerType)pickerType{
    
    if(pickerType == UIPickerTypeDate){
        return kDatePickerCellID;
    }else if(pickerType == UIPickerTypeTime){
        return kTimePickerCellID;
    }else if(pickerType == UIPickerTypeCustom){
        return kCustomPickerCellID;
    }else{
        return @"";
    }
    
}

-(NSString *)cellIdentifierForCellType:(NSInteger)celltype{
    
    if(celltype == UITableViewCellTypeDate){
        return kDateCellID;
    }else if(celltype == UITableViewCellTypeText){
        return  kTextCellID;
    }else if(celltype== UITableViewCellTypeDecimal){
        return  kDecimalCellID;
    }else if(celltype == UITableViewCellTypeTime){
        return  kTimeCellID;
    }else if(celltype == UITableViewCellTypeBool){
        return  kBoolCellID;
    }else if(celltype == UITableViewCellTypeCustom){
        return  kCustomCellID;
    }else if(celltype == UITableViewCellTypeSelect){
        return  kSelectCellID;
    }else{
        return kGeneralCellID;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if([self hasInlinePicker]){
        return self.tableData.count + 1;
    }
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    NSString *cellID = kGeneralCellID;
    NSInteger modelRow = indexPath.row;
    if(self.pickerIndexPath != nil && self.pickerIndexPath.row < indexPath.row){
        modelRow --;
    }
    
    NSDictionary *tableDataDict;

    if ([self indexPathHasPicker:indexPath]){
        cellID  =[self cellIdentifierForForPickerType:self.pickerType];
    }else{
        tableDataDict = [self.tableData objectAtIndex:modelRow];
        cellID = [self cellIdentifierForCellType:[[tableDataDict valueForKey:kTypeKey] intValue]];
    }

   
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
    
    
        if ([cellID isEqualToString:kTextCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.text = [tableDataDict valueForKey:kTitleKey];
            cell.detailTextLabel.text = [tableDataDict valueForKey:kValueKey];
            cell.detailTextLabel.hidden = NO;
        }else if ([cellID isEqualToString:kDecimalCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.text = [tableDataDict valueForKey:kTitleKey];
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.01f", [[tableDataDict valueForKey:kValueKey] doubleValue]];
        }else if ([cellID isEqualToString:kDateCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.text = [tableDataDict valueForKey:kTitleKey];
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[tableDataDict valueForKey:kValueKey]];;
        }else if ([cellID isEqualToString:kTimeCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.text = [tableDataDict valueForKey:kTitleKey];
            cell.detailTextLabel.text = [self.timeFormatter stringFromDate:[tableDataDict valueForKey:kValueKey]];
        }else if ([cellID isEqualToString:kBoolCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.textLabel.text = [tableDataDict valueForKey:kTitleKey];
            
            CGRect detailCellFrame = CGRectMake(CGRectGetWidth(cell.contentView.frame) - 65,
                                                5,
                                                50,
                                                CGRectGetHeight(cell.contentView.frame));

            UISwitch *boolSwitch = [[UISwitch alloc] initWithFrame:detailCellFrame];
            //boolSwitch.on = [[tableDataDict valueForKey:kValueKey] boolValue];
            [cell.contentView addSubview:boolSwitch];
            

        }else if ([cellID isEqualToString:kCustomCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.text = [tableDataDict valueForKey:kTitleKey];
            cell.detailTextLabel.text = [tableDataDict valueForKey:kValueKey];
        }else if ([cellID isEqualToString:kSelectCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.text = [tableDataDict valueForKey:kTitleKey];
            cell.detailTextLabel.text = [tableDataDict valueForKey:kValueKey];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        
        
        //Pickers
        if ([cellID isEqualToString:kDatePickerCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.tag = kDatePickerTag;
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:datePicker];
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }else if ([cellID isEqualToString:kTimePickerCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.tag = kDatePickerTag;
            datePicker.datePickerMode = UIDatePickerModeTime;
            [datePicker addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:datePicker];
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }else if ([cellID isEqualToString:kCustomPickerCellID]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            SRTimerPicker *customPicker = [[SRTimerPicker alloc] init];
            customPicker.tag = kCustomPickerTag;
            customPicker.customPickerDelegate = self;
            [cell.contentView addSubview:customPicker];
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }



        
    }

    
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self resignKeyboard];
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.selectedCell.reuseIdentifier == kTextCellID){
        [self toggleTextFieldForCellWithKeyboardtype:UIKeyboardTypeAlphabet];
    }else if (self.selectedCell.reuseIdentifier == kDecimalCellID){
        [self toggleTextFieldForCellWithKeyboardtype:UIKeyboardTypeDecimalPad];
    }else if (self.selectedCell.reuseIdentifier == kSelectCellID){
        [self toggleSelectViewController];
    }else if (self.selectedCell.reuseIdentifier == kDateCellID){
        self.pickerType = UIPickerTypeDate;
        [self displayInlinePickerForRowAtIndexPath:indexPath];
    }else if (self.selectedCell.reuseIdentifier == kTimeCellID){
        self.pickerType = UIPickerTypeTime;
        [self displayInlinePickerForRowAtIndexPath:indexPath];
    }else if (self.selectedCell.reuseIdentifier == kCustomCellID){
        self.pickerType = UIPickerTypeCustom;
        [self displayInlinePickerForRowAtIndexPath:indexPath];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark - togglers

-(void)toggleSelectViewController{
    //
}

-(void)displayInlinePickerForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;
    
    if ([self hasInlinePicker])
    {
        before = self.pickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.pickerIndexPath.row - 1 == indexPath.row);

    // remove any date picker cell if it exists
    if ([self hasInlinePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.pickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.pickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self togglePickerForSelectedIndexPath:indexPathToReveal];
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
        NSLog(@"picker index path = %li", (long)self.pickerIndexPath.row);
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [self.tableView endUpdates];
    
    if(self.pickerType == UIPickerTypeDate || self.pickerType == UIPickerTypeTime){
        [self updateDatePicker];
    }
    
    if(self.pickerType == UIPickerTypeCustom){
        [self updateCustomPicker];
    }

    
}

-(void)removePicker{
    
    [self.tableView beginUpdates];

    if ([self hasInlinePicker]){
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.pickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.pickerIndexPath = nil;
    }

    [self.tableView endUpdates];

}


-(void)togglePickerForSelectedIndexPath:(NSIndexPath *)indexPath{

    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
   
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
    
}

-(void)toggleTextFieldForCellWithKeyboardtype:(UIKeyboardType)keyboardType{
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES]; // Fix to make sure cell is not highlighted
    
    if(self.textfield){
        [self.textfield removeFromSuperview];
        self.textfield = nil;
    }
    
    [self removePicker];
    
    CGRect detailCellFrame = CGRectMake(CGRectGetWidth(self.selectedCell.contentView.frame) - 120,
                                        0,
                                        120,
                                         CGRectGetHeight(self.selectedCell.contentView.frame));
    
    self.textfield = [[UITextField alloc] initWithFrame:detailCellFrame];
    self.textfield.delegate = self;
    self.textfield.textAlignment = NSTextAlignmentRight;
    self.textfield.keyboardType = keyboardType;
    [self.textfield setText:self.selectedCell.detailTextLabel.text];
    [self.textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.selectedCell.detailTextLabel.hidden = YES;
    //self.textfield.backgroundColor = [UIColor redColor];
    [self.selectedCell.contentView addSubview:self.textfield];
    [self.textfield becomeFirstResponder];

}


#pragma mark - Text field action

-(IBAction)textFieldDidChange:(UITextField *)textField{
    [self.selectedCell.detailTextLabel setText:textField.text];
}

-(void)keyboardDidShow{
    self.keyboardIsShowing = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignKeyboard];
    return NO;
}

-(void)resignKeyboard{
    
    if(self.keyboardIsShowing){
        [self.textfield resignFirstResponder];
        [self.textfield removeFromSuperview];
        self.keyboardIsShowing = NO;
        self.textfield = nil;
    }
    self.selectedCell.detailTextLabel.hidden = NO;

}

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField{
    
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
   
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    flexibleSpace.width = 280;
    
    UIBarButtonItem *donebutton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems:@[flexibleSpace, donebutton]];
    textField.inputAccessoryView = keyboardToolBar;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    return YES;
}

#pragma mark - Custom Picker Delegate

-(void)didSelectNewTime:(NSString *)time{
 
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlinePicker]){
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.pickerIndexPath.row - 1 inSection:0];
    }
    else{
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    
    NSMutableDictionary *itemData = self.tableData[targetedCellIndexPath.row];
    [itemData setValue:time forKey:kValueKey];
    
    cell.detailTextLabel.text = time;

}

#pragma mark - Date Action

- (IBAction)dateAction:(id)sender{

    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlinePicker]){
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.pickerIndexPath.row - 1 inSection:0];
    }
    else{
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = self.tableData[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kValueKey];
    
    // update the cell's date string
    if(self.pickerType == UIPickerTypeDate){
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    }else if(self.pickerType == UIPickerTypeTime){
        cell.detailTextLabel.text = [self.timeFormatter stringFromDate:targetedDatePicker.date];
    }

    
}



@end
