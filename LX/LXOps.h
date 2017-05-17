/*
 *  LXOps.h
 *  LXCommand
 *
 *  Created by Colin Thomas-Arnold on 2/26/07.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "LXOperator.h"

@interface LXOpAddition : LXOperator { }
@end
@interface LXOpAnd : LXOperator { }
@end
@interface LXOpBitwiseAnd : LXOperator { }
@end
@interface LXOpBitwiseNot : LXOperator { }
@end
@interface LXOpBitwiseOr : LXOperator { }
@end
@interface LXOpBitwiseXor : LXOperator { }
@end
@interface LXOpConditional : LXOperator { }
@end
@interface LXOpDivision : LXOperator { }
@end
@interface LXOpEither : LXOperator { }
@end
@interface LXOpEqual : LXOperator { }
@end
@interface LXOpExponent : LXOperator { }
@end
@interface LXOpGreaterThan : LXOperator { }
@end
@interface LXOpGreaterThanEqual : LXOperator { }
@end
@interface LXOpIdentical : LXOperator { }
@end
@interface LXOpLessThan : LXOperator { }
@end
@interface LXOpLessThanEqual : LXOperator { }
@end
@interface LXOpModulus : LXOperator { }
@end
@interface LXOpMultiplication : LXOperator { }
@end
@interface LXOpNegate : LXOperator { }
@end
@interface LXOpNot : LXOperator { }
@end
@interface LXOpNotEqual : LXOperator { }
@end
@interface LXOpNotIdentical : LXOperator { }
@end
@interface LXOpOr : LXOperator { }
@end
@interface LXOpSeries : LXOperator { }
@end
@interface LXOpShiftLeft : LXOperator { }
@end
@interface LXOpShiftRight : LXOperator { }
@end
@interface LXOpSubtraction : LXOperator { }
@end

//variable operators
@interface LXOpVariable : LXOperator { LXValue *args; LXValue *code; }
- (void) setArguments:(LXValue*) value;
- (void) setCodeBlock:(LXValue*) value;
@end
//dot and range inherit the ability to "mask" as placeholders
@interface LXOpDot : LXOpVariable { }
@end
@interface LXOpRange : LXOpVariable { }
- (LXValue*) index:(NSInteger)index in:(LXValue*)a;
- (LXValue*) key:(NSString*)key in:(LXValue*)a;
- (LXValue*) copy:(LXValue*)a using:(LXValue*)b;
@end

//assignment operators
@interface LXOpAssign : LXOperator { LXOperator *performOp; }
@end
//notice these inherit from LXOpAssign, not LXOperator directly.  they all get the LXOperator *performOp member.
@interface LXOpModulusAssign : LXOpAssign { }
@end
@interface LXOpExponentAssign : LXOpAssign { }
@end
@interface LXOpAdditionAssign : LXOpAssign { }
@end
@interface LXOpSubtractionAssign : LXOpAssign { }
@end
@interface LXOpMultiplicationAssign : LXOpAssign { }
@end
@interface LXOpDivisionAssign : LXOpAssign { }
@end
@interface LXOpPreIncrement : LXOpAssign { }
@end
@interface LXOpPostIncrement : LXOpAssign { }
@end
@interface LXOpPreDecrement : LXOpAssign { }
@end
@interface LXOpPostDecrement : LXOpAssign { }
@end
