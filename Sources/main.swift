import Foundation

print("BASIC Swift - (C) Guido Rota 2016")

let parser = Parser()

repeat {
    guard let line = readLine(), line.characters.count > 0 else {
        continue
    }

    parser.parse(InputStream(data: line.data(using: .utf8)!))

    print("Got line")
} while true
