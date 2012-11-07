//
//  CalculatorBrain.m
//  Calculator
//
//  Created by harry moreno on 11/4/12.
//  Copyright (c) 2012 harry moreno. All rights reserved.
//

#import "CalculatorBrain.h"
#import "math.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain
// operandStack getter must initialize the stack
- (NSMutableArray *) operandStack {
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}
- (void)clearMemory {
    self.operandStack = [[NSMutableArray alloc] init];
}
- (void)pushOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double)popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) {
        [self.operandStack removeLastObject];
    }
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation {
    double result = 0;
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) {
            result = [self popOperand] / divisor;
        } else {
            result = 0;
        }
    } else if ([operation isEqualToString:@"sin"]) {
        double number = [self popOperand];
        result = sin(number*M_PI/180.0);
        //NSLog(@"result is: %g", result);
    } else if ([operation isEqualToString:@"cos"]) {
        double number = [self popOperand];
        result = cos(number*M_PI/180.0);
    } else if ([operation isEqualToString:@"sqrt"]) {
        double number = [self popOperand];
        result = sqrt(number);
    } else if ([operation isEqualToString:@"ln"]) {
        double number = [self popOperand];
        result = log(number);
    } else if ([operation isEqualToString:@"PI"]) {
        result = M_PI;
    }
    [self pushOperand:result];
    return result;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"stack = %@", self.operandStack];
}
@end
