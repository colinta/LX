/*
 *  LXHeader.h
 *  LXCommand
 *
 *  Created by Colin Thomas-Arnold on 10月9日2006年.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 *
 */

typedef enum
{
    argumentsOp, //(function)(args)
    codeBlockOp, //(function)(args){codeBlock}
    exponentOp, //5^2, 5**2 => 25
    exponentScanOp, //used to scan the form 5^5^-5 => 5 ^ (5 ^ -5); has lower precedence than exponentOp
    negateOp, // -5

    seriesOp, //1::5 => {1,2,3,4,5}
    rangeOp, //{1,2,3}[0] => 1
    dotOp, //varName.varName or varName->varName

    modulusOp, //i % 5
    multiplicationOp, // 5*5, 5×5 => 25
    divisionOp, // 25 / 5, 25÷5 => 5
    additionOp, //5+5 => 10
    subtractionOp, //5-5 => 0

    notOp, //!true => false
    andOp, //true && false => false
    orOp,  //true || false => true

    equalOp, //0==false => true
    notEqualOp, //-1 != '-1' => false
    notIdenticalOp, //-1 !== '-1' => true
    ltOp, // 1 < 2 => true
    gtOp, // 1 > 2 => false
    ltEqualOp, // 2 <= 2 => true
    gtEqualOp, // 2 >= 2 => true

    bitwiseAndOp, //1 & 3 => 1  (01 & 11 => 01)
    bitwiseNotOp, //~5 => 2 (~101 => 010)
    bitwiseOrOp, // 1 | 3 => 3  (01 | 11 => 11)
    bitwiseXorOp, //1 ^| 3 => 2 (01 ^| 11 => 10)
    shiftLeftOp, //5 << 1 => 10 (101 << 1 => 1010)
    shiftRightOp, // 10 >> 1 => 5 (1010 >> 1 => 101)

    conditionalOp, //true ? eitherOp
    eitherOp, //trueCondition : falseCondition

    assignOp, // x = sin(i) => x is assigned to the current value of sin(i)
    modulusAssignOp, // x %= 5
    exponentAssignOp, // x ^= 5
    additionAssignOp, // x += 5
    subtractionAssignOp, // x -= 5
    multiplicationAssignOp, // x *= 5, x ×= 5
    divisionAssignOp, // x /= 5, x ÷ 5
    assignScanOp, // x /= 5, x ÷ 5

    preIncrementOp, // ++x
    postIncrementOp, // x++
    preDecrementOp, // --x
    postDecrementOp, // x--

    closeParenthesesOp, // )
    closeCurlyOp, // }
    closeBracketOp, // ]
    nextArgOp, // 1,2
    eolOp, // \n, ;
    noOp  // huh.
} lxoperator;

typedef enum
{
//basic types
    numberType,
    stringType,
    vectorType,

//advanced types
    objectType,
    pairType,
    dataType,
    functionType,

//others
    placeholderType,
    errorType,
    noType
} lxtype;

typedef enum
{
    opExpected,
    valExpected,
    syntaxError
} lxerrorType;
