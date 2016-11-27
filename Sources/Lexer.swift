import Foundation

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
    case moduleOperator

    // Control flow
    case ifCommand
}


class Token {

    let value: TokenValue

    init(value: TokenValue) {
        self.value = value
    }

}


enum LexerError: Error {
    case unexpectedEndOfInput
    case unknownCharacter(char: UnicodeScalar)
    case unexpectedCharacter
}


class Lexer {

    private let input: BufferedCharacterStream

    init(_ input: InputStream) {
        self.input = BufferedCharacterStream(input)
        input.open()
    }

    var hasMoreTokens: Bool {
        return input.hasCharactersAvailable
    }

    func getNextToken() throws -> TokenValue {
        while input.hasCharactersAvailable {
            let char = try! input.peekNextCharacter()
            if isDigit(char) {
                return try parseNumber()
            } else if isAlpha(char) {
                return try parseIdentifier()
            } else if isWhitespaceOrNewline(char) {
                // Ignore whitespaces and newlines
                input.advancePosition()
            }
        }

        throw LexerError.unexpectedEndOfInput
    }

    private func parseNumber() throws -> TokenValue {
        var number: String = ""

        var isFractional = false
        while input.hasCharactersAvailable {
            let char = try! input.peekNextCharacter()

            if isWhitespaceOrNewline(char) {
                break
            }

            guard isValidNumberCharacter(char) else {
                throw LexerError.unexpectedCharacter
            }

            if char == "." {
                isFractional = true
            }

            number.append(Character(char))
            input.advancePosition()
        }

        if (isFractional) {
            return .float(value: Float(number)!)
        } else {
            return .integer(value: Int(number)!)
        }
    }

    private func isValidNumberCharacter(_ char: UnicodeScalar) -> Bool {
        return isDigit(char) || char == "."
    }

    private func parseIdentifier() throws -> TokenValue {
        return .identifier(name: "poiana")
    }

    private func isDigit(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.decimalDigits.contains(char)
    }

    private func isAlpha(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.letters.contains(char)
    }

    private func isWhitespaceOrNewline(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.whitespacesAndNewlines.contains(char)
    }

    private func isWhitespace(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.whitespacesAndNewlines.contains(char)
    }

    private func isNewline(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.newlines.contains(char)
    }

    func close() {
        input.close()
    }

}


private class BufferedCharacterStream {

    private static let MaxBufferLength: Int = 1024

    private let input: InputStream

    private var buffer: [UInt8] = Array(repeating: 0, count: MaxBufferLength)
    private var pos: Int
    private var length: Int

    init(_ input: InputStream) {
        self.input = input
        self.pos = 0
        self.length = 0
    }

    var hasCharactersAvailable: Bool {
        return pos < length || input.hasBytesAvailable
    }

    func getNextCharacter() throws -> UnicodeScalar {
        let char = try peekNextCharacter()
        pos += 1
        return char
    }

    func peekNextCharacter() throws -> UnicodeScalar {
        if pos >= length {
            try readFromStream()
        }

        let value = buffer[pos]

        return UnicodeScalar(value)
    }

    func advancePosition() {
        pos += 1
    }

    private func readFromStream() throws {
        guard input.hasBytesAvailable else {
            throw LexerError.unexpectedEndOfInput
        }
        length = input.read(&buffer, maxLength: BufferedCharacterStream.MaxBufferLength)
        pos = 0
    }

    func close() {
        input.close()
    }

}
