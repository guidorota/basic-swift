import Foundation

internal class CharacterStream {

    private static let BufferCapacity: Int = 1024

    private let input: InputStream

    // Buffer information
    private var buffer: [UInt8] = Array(repeating: 0, count: BufferCapacity)
    private var bufferIndex: Int
    private var bufferLength: Int

    // Current position in the input text
    private var currentRow: Int = 0
    private var currentColumn: Int = 0

    init(_ input: InputStream) {
        self.input = input
        self.bufferIndex = 0
        self.bufferLength = 0
    }

    var hasCharactersAvailable: Bool {
        return bufferIndex < bufferLength || input.hasBytesAvailable
    }

    var currentPosition: Position {
        return Position(row: currentRow, column: currentColumn)
    }

    func getNextCharacter() throws -> UnicodeScalar {
        let char = try peekNextCharacter()
        advancePosition()
        return char
    }

    func peekNextCharacter() throws -> UnicodeScalar {
        if bufferIndex >= bufferLength {
            try readFromStream()
        }

        let value = buffer[bufferIndex]

        return UnicodeScalar(value)
    }

    func advancePosition() {
        let char = try! peekNextCharacter()
        if CharacterSet.newlines.contains(char) {
            currentRow += 1
            currentColumn = 1
        } else {
            currentColumn += 1
        }

        bufferIndex += 1
    }

    private func readFromStream() throws {
        guard input.hasBytesAvailable else {
            throw ParserError.unexpectedEndOfInput
        }

        bufferLength = input.read(&buffer, maxLength: CharacterStream.BufferCapacity)
        bufferIndex = 0
    }

}

