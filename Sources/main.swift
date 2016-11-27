import Foundation

let prompt = "> "
let parser = Parser()

print("BASIC Swift - (C) Guido Rota 2016")

repeat {
    print(prompt, terminator: "")

    guard let line = readLine(), line.characters.count > 0 else {
        continue
    }

    parser.parse(InputStream(data: line.data(using: .utf8)!))
} while true
