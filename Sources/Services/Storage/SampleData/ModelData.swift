import Foundation

struct ModelData {

    private static let accountNames = ["Online Savings", "Checking Account", "Credit Card"]
    
    private static var randomAccountName: String {
        accountNames.randomElement() ?? "Unknown"
    }
    
    static let sampleTransactions: [TransactionModel] = [
        TransactionModel(
            id: 1,
            name: "Movie Night",
            category: .entertainment,
            amount: 82.99,
            date: Date(string: "2021-03-05")!,
            accountName: randomAccountName,
            provider: .timeWarner,
            isPinned: false
        ),
        TransactionModel(
            id: 2,
            name: "Jeans",
            category: .shopping,
            amount: 54.60,
            date: Date(string: "2021-04-25")!,
            accountName: randomAccountName,
            provider: .jCrew,
            isPinned: true
        ),
        TransactionModel(
            id: 3,
            name: "Salad Mix",
            category: .food,
            amount: 25.32,
            date: Date(string: "2021-04-15")!,
            accountName: randomAccountName,
            provider: .wendys,
            isPinned: false
        ),
        TransactionModel(
            id: 4,
            name: "Lunch Special",
            category: .food,
            amount: 10.36,
            date: Date(string: "2021-04-12")!,
            accountName: randomAccountName,
            provider: .burgerKing,
            isPinned: false
        ),
        TransactionModel(
            id: 5,
            name: "Airport ride",
            category: .travel,
            amount: 54.28,
            date: Date(string: "2021-04-02")!,
            accountName: randomAccountName,
            provider: .uber,
            isPinned: false
        ),
        TransactionModel(
            id: 6,
            name: "Monthly Best Seller",
            category: .shopping,
            amount: 6.51,
            date: Date(string: "2021-04-22")!,
            accountName: randomAccountName,
            provider: .amazon,
            isPinned: false
        ),
        TransactionModel(
            id: 7,
            name: "Triple Spice Souce",
            category: .food,
            amount: 12.76,
            date: Date(string: "2021-04-22")!,
            accountName: randomAccountName,
            provider: .traderJoes,
            isPinned: false
        ),
        TransactionModel(
            id: 8,
            name: "Meds",
            category: .health,
            amount: 21.53,
            date: Date(string: "2021-04-04")!,
            accountName: randomAccountName,
            provider: .cvs,
            isPinned: false
        ),
        TransactionModel(
            id: 9,
            name: "Potato Snack",
            category: .food,
            amount: 15.95,
            date: Date(string: "2021-04-19")!,
            accountName: randomAccountName,
            provider: .wawa,
            isPinned: false
        ),
        TransactionModel(
            id: 10,
            name: "Refuel",
            category: .travel,
            amount: 44.22,
            date: Date(string: "2021-04-21")!,
            accountName: randomAccountName,
            provider: .exxonmobil,
            isPinned: false
        ),
        TransactionModel(
            id: 11,
            name: "Matcha Latte",
            category: .food,
            amount: 9.89,
            date: Date(string: "2021-04-27")!,
            accountName: randomAccountName,
            provider: .starbucks,
            isPinned: false
        ),
        TransactionModel(
            id: 12,
            name: "Riders Cap",
            category: .shopping,
            amount: 16.89,
            date: Date(string: "2021-04-26")!,
            accountName: randomAccountName,
            provider: .jCrew,
            isPinned: false
        ),
        TransactionModel(
            id: 13,
            name: "Outbound Trip",
            category: .travel,
            amount: 116.78,
            date: Date(string: "2021-04-30")!,
            accountName: randomAccountName,
            provider: .americanAirlines,
            isPinned: false
        )
    ]
}

private extension Date {
    var formatted: String {
        printingFormatter.string(from: self)
    }

    init?(string: String) {
        guard let date = readingFormatter.date(from: string) else {
            return nil
        }
        self = date
    }
}

private let readingFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")!
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

private let printingFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")!
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateStyle = .medium
    return formatter
}()
