enum ParserError: Error {
    case unexpectedEndOfInput
    case unexpectedCharacter
    case unknownToken(rawValue: String)
}