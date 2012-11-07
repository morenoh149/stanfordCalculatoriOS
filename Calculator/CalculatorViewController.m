//
//  CalculatorViewController.m
//  Calculator
//
//  Created by harry moreno on 11/1/12.
//  Copyright (c) 2012 harry moreno. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic)  NSMutableArray *historyArray;
- (void)addHistory:(NSString *)event;
@end

@implementation CalculatorViewController
int count = 0;
- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}
- (NSMutableArray *)historyArray {
    if (!_historyArray){
        _historyArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _historyArray;
}
// adds a decimal to display, allows leading with decimal
- (IBAction)decimalPressed {
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound && self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:@"."];
    } else {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}
// returns calculator to initial state
- (IBAction)clearPressed {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.display.text = @"";
    self.historyArray = [[NSMutableArray alloc] initWithCapacity:5];
    count = 0;
    self.historyLabel.text = [self.historyArray componentsJoinedByString:@" "];
    [self.brain clearMemory];
}
// Abstract out adding to history, need to keep finite # of items
- (void)addHistory:(NSString *)event {
    count++;
    if (count >= 8) {
        count = 7;
        [self.historyArray removeObjectAtIndex:0];
        [self.historyArray addObject:event];
    } else {
        [self.historyArray addObject:event];
    }
    NSLog(@"%@", [self.historyArray componentsJoinedByString:@" "]);
    self.historyLabel.text = [self.historyArray componentsJoinedByString:@" "];
}
// adds digit pressed to the display
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}
// push whatever is in the display to brain, update historyArray
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self addHistory:[self.display.text stringByAppendingString:@" "]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
// for functions we always perform the function on whatever is in the display
- (IBAction)functionPressed:(UIButton *)sender {
    [self enterPressed];
    NSString *function = sender.currentTitle;
    NSLog(@"function is: %@", function);
    double result = [self.brain performOperation:function];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self addHistory:[NSString stringWithFormat:@"%@ ", function]];
}
// for operations we provoke an enterPressed if we are in the middle
// of entering a number
- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self addHistory:[NSString stringWithFormat:@"%@ ", operation]];
}
@end