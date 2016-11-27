import Foundation

internal class Lexer {

    private let characterStream: CharacterStream

    init(_ input: InputStream) {
        self.characterStream = CharacterStream(input)
    }

    var hasMoreTokens: Bool {
        return characterStream.hasCharactersAvailable
    }

    func getNextToken() throws -> Token {
        while characterStream.hasCharactersAvailable {
            let char = try! characterStream.peekNextCharacter()

            if isWhitespaceOrNewline(char) {
                characterStream.advancePosition()
                continue
            }

            let startPosition = characterStream.currentPosition
            var tokenValue: TokenValue
            if isDigit(char) {
                tokenValue = try parseNumber()
            } else if isLetter(char) {
                tokenValue = try parseLetterPrefixedToken()
            } else {
                throw ParserError.unexpectedCharacter
            }
            let endPosition = characterStream.currentPosition

            return Token(value: tokenValue, from: startPosition, to: endPosition)
        }

        throw ParserError.unexpectedEndOfInput
    }

    private func parseNumber() throws -> TokenValue {
        var number: String = ""

        var isFractional = false
        while characterStream.hasCharactersAvailable {
            let char = try! characterStream.peekNextCharacter()

            if isWhitespaceOrNewline(char) {
                break
            }

            guard isValidNumberCharacter(char) else {
                throw ParserError.unexpectedCharacter
            }

            if char == "." {
                isFractional = true
            }

            number.append(Character(char))
            characterStream.advancePosition()
        }

        if (isFractional) {
            return .float(value: Float(number)!)
        } else {
            return .integer(value: Int(number)!)
        }
    }

    private func parseLetterPrefixedToken() throws -> TokenValue {
        var value: String = ""

        while characterStream.hasCharactersAvailable {
            let char = try! characterStream.peekNextCharacter()

            guard isLetter(char) else {
                throw ParserError.unexpectedCharacter
            }

            value.append(Character(char))
            characterStream.advancePosition()
        }

        switch value.lowercased() {
        case "and": return .andOperator
        case "or": return .orOperator
        case "xor": return .xorOperator
        case "not": return .notOperator
        default: return .identifier(name: value)
        }
    }

    private func isDigit(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.decimalDigits.contains(char)
    }

    private func isValidNumberCharacter(_ char: UnicodeScalar) -> Bool {
        return isDigit(char) || char == "."
    }

    private func isLetter(_ char: UnicodeScalar) -> Bool {
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

}
