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
            } else if isAlpha(char) {
                tokenValue = try parseIdentifier()
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

    private func parseIdentifier() throws -> TokenValue {
        return .identifier(name: "poiana")
    }

    private func isDigit(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.decimalDigits.contains(char)
    }

    private func isValidNumberCharacter(_ char: UnicodeScalar) -> Bool {
        return isDigit(char) || char == "."
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

}
