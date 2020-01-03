/*
 todos:
    ifstmt
    gaurdstmt
    variableDecl
    optionalBindingCondition
    TuplePattern
 */

/*
 ifstmt
    if
    [conditionElementList]
        conditionElement
            optionalBindingCondition // let a = b
    codeBlock
        codeBlockList
    else?
    codeBlock|ifstmt
 */

/*
 gaurdstmt
    gaurd
    [conditionElementList]
    else
    codeBlock
 codeBlock
 */

/*
 variableDecl
    let
    [PatternBindingList]
        PatternBinding a = b
            IDPattern|TuplePattern
            InitClause
        PatternBinding c = d
            IDPattern
            InitClause
 */

/*
 TuplePattern
    (
    [TuplePatternElementList]
        TuplePatternElement
            IDPattern
    )
 */
