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
                tokenValue = try parseSymbolPrefixedToken()
            }
            let endPosition = characterStream.currentPosition

            return Token(value: tokenValue, from: startPosition, to: endPosition)
        }

        throw ParserError.unexpectedEndOfInput
    }

    private func parseNumber() throws -> TokenValue {
        var rawValue: String = ""

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

            rawValue.append(Character(char))
            characterStream.advancePosition()
        }

        if (isFractional) {
            return .float(value: Float(rawValue)!)
        } else {
            return .integer(value: Int(rawValue)!)
        }
    }

    private func parseLetterPrefixedToken() throws -> TokenValue {
        var rawValue: String = ""

        let char = try! characterStream.peekNextCharacter()

        // The first character MUST be a letter
        guard isLetter(char) else {
            throw ParserError.unexpectedCharacter
        }

        rawValue.append(Character(char))
        characterStream.advancePosition()

        // Subsequent characters can be letters or numbers
        while characterStream.hasCharactersAvailable {
            let char = try! characterStream.peekNextCharacter()

            guard isAlphanumeric(char) else {
                throw ParserError.unexpectedCharacter
            }

            if isWhitespaceOrNewline(char) {
                break
            }

            rawValue.append(Character(char))
            characterStream.advancePosition()
        }

        switch rawValue.lowercased() {
        // Logical operators
        case "and": return .andOperator
        case "or": return .orOperator
        case "xor": return .xorOperator
        case "not": return .notOperator
        default: return .identifier(name: rawValue)
        }
    }

    private func parseSymbolPrefixedToken() throws -> TokenValue {
        var rawValue: String = ""

        let char = try! characterStream.peekNextCharacter()

        if char == "\"" {
            return try parseStringToken()
        }

        rawValue.append(Character(char))
        characterStream.advancePosition()

        while characterStream.hasCharactersAvailable {
            let char = try! characterStream.peekNextCharacter()

            if isWhitespaceOrNewline(char) {
                break
            }

            rawValue.append(Character(char))
            characterStream.advancePosition()
        }

        switch rawValue {
        // Boolean operators
        case ">": return .gtOperator
        case ">=": return .gteOperator
        case "<": return .ltOperator
        case "<=": return .lteOperator
        case "<>": return .neqOperator
        case "=": return .eqOperator

        // Arithmetic operators
        case "+": return .plusOperator
        case "-": return .minusOperator
        case "/": return .divisionOperator
        case "*": return .multiplicationOperator
        case "%": return .moduloOperator
        default: throw ParserError.unknownToken(rawValue: rawValue)
        }
    }

    private func parseStringToken() throws -> TokenValue {
        return .string(value: "poiana")
    }

    private func isDigit(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.decimalDigits.contains(char)
    }

    private func isValidNumberCharacter(_ char: UnicodeScalar) -> Bool {
        return isDigit(char) || char == "."
    }

    private func isAlphanumeric(_ char: UnicodeScalar) -> Bool {
        return CharacterSet.alphanumerics.contains(char)
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
