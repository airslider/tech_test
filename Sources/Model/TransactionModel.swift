import Foundation
import SwiftUI

struct TransactionModel {

    enum Category: String, CaseIterable {
        case all
        case food
        case health
        case entertainment
        case shopping
        case travel
    }
    
    enum Provider: String {
        case amazon
        case americanAirlines
        case burgerKing
        case cvs
        case exxonmobil
        case jCrew
        case starbucks
        case timeWarner
        case traderJoes
        case uber
        case wawa
        case wendys
    }
    
    let id: Int
    let name: String
    let category: Category
    let amount: Double
    let date: Date
    let accountName: String
    let provider: Provider?
    let isPinned: Bool
}

extension TransactionModel: Identifiable { }

extension TransactionModel.Category: Identifiable {

    var id: String {
        rawValue
    }

}

extension TransactionModel.Category {

    static subscript(index: Int) -> Self? {
        guard
            index >= 0 &&
            index < TransactionModel.Category.allCases.count
        else {
            return nil
        }
        
        return TransactionModel.Category.allCases[index]
    }

}

extension TransactionModel.Category {

    var color: Color {
        switch self {
        case .food:
            return .green

        case .health:
            return .pink

        case .entertainment:
            return .orange

        case .shopping:
            return .blue

        case .travel:
            return .purple

        case .all:
            return  .black
        }
    }

}
