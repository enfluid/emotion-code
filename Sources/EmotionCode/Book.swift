import Foundation

// MARK: Book

struct Book {

    struct Chapter {
        let title: String
        let subtitle: String?
        let fileURL: URL
        let audioURL: URL?
    }

    let chapters: [Chapter]

}
