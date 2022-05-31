import Foundation
#if canImport(XCTest)
@testable import TechChallenge
#endif

extension TransactionModel {

    static func sample(
        id: Int = 1,
        name: String = "Movie Night",
        category: Category = .entertainment,
        amount: Double = 12.53,
        date: Date = Date(),
        accountName: String = "Personal",
        provider: Provider? = .timeWarner,
        isPinned: Bool = true
    ) -> TransactionModel {
        TransactionModel(
            id: id,
            name: name,
            category: category,
            amount: amount,
            date: date,
            accountName: accountName,
            provider: provider,
            isPinned: isPinned
        )
    }

}
