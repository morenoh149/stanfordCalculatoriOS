//
//  CalculatorBrain.h
//  Calculator
//
//  Created by harry moreno on 11/4/12.
//  Copyright (c) 2012 harry moreno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearMemory;

@end
