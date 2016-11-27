class Token: CustomStringConvertible {

    let start: Position
    let end: Position
    let value: TokenValue

    init(value: TokenValue, from start: Position, to end: Position) {
        self.value = value
        self.start = start
        self.end = end
    }

    var description: String {
        return "Token(value: \(value), start: \(start), end: \(end))"
    }

}


enum TokenValue {

    // Numbers
    case integer(value: Int)
    case float(value: Float)

    // String-based
    case identifier(name: String)
    case string(value: String)

    // Logical operators
    case andOperator
    case orOperator
    case xorOperator
    case notOperator

    // Comparison operators
    case eqOperator
    case neqOperator
    case gtOperator
    case gteOperator
    case ltOperator
    case lteOperator

    // Arithmetic operators
    case plusOperator
    case minusOperator
    case multiplicationOperator
    case divisionOperator
    case moduloOperator

    // Control flow
    case ifCommand

}


internal struct Position {

    let row: Int
    let column: Int

}
