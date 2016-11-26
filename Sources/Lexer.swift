import Foundation

class Token {

}


class Lexer {

    private let stream: BufferedCharacterStream

    init(_ input: InputStream) {
        self.stream = BufferedCharacterStream(input)
    }

    var hasMoreTokens: Bool {

    }

    func getNextToken() -> Token {

    }

    func close() {
        stream.close()
    }

}


enum LexerError: Error {
    case endOfInput
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
        return pos != length || input.hasBytesAvailable
    }

    func getNextCharacter() -> Character {
        if pos == length && input.hasBytesAvailable {
            try! readFromStream()
        }

        let value = buffer[pos]
        pos += 1

        return Character(UnicodeScalar(value))
    }

    private func readFromStream() throws {
        if !input.hasBytesAvailable {
            throw LexerError.endOfInput
        }
        length = input.read(&buffer, maxLength: BufferedCharacterStream.MaxBufferLength)
        pos = 0
    }

    func close() {
        input.close()
    }

}
