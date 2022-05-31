import XCTest
import Combine

@testable import TechChallenge

final class FloatingSummaryViewModelTests: XCTestCase {

    private var sut: FloatingSummaryViewModel?
    private var interactor: TransactionListInteractorProtocolMock?

    private var cancellables: Set<AnyCancellable> = []

    private lazy var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    @MainActor
    override func setUp() {
        let interactor = TransactionListInteractorProtocolMock()
        interactor.transactions = CurrentValueSubject<[TransactionModel], Never>([])
        sut = FloatingSummaryViewModel(interactor: interactor)
        self.interactor = interactor
    }

    override func tearDown() {
        sut = nil
        interactor = nil
        cancellables.cancel()
        cancellables.removeAll()
    }

}

extension FloatingSummaryViewModelTests {

    @MainActor
    func test_whenTransactionsIsEmpty_thenOutputIsCorrect() throws {
        let inputTransactions: [TransactionModel] = []
        let amountSummary = 0
        let expected = amountFormatter.string(for: amountSummary)

        let expectation = XCTestExpectation(description: #function)

        sut?.$amount
            .dropFirst(2)
            .sink { value in
                XCTAssertEqual(value, expected)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        interactor?.transactions.send(inputTransactions)
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_whenInputTwo_thenSummaryIsCorrect() throws {
        let inputTransactions: [TransactionModel] = [
            .sample(amount: 12.01),
            .sample(amount: 9)
        ]
        let amountSummary = inputTransactions.map { $0.amount }.reduce(0, +)
        let expected = amountFormatter.string(for: amountSummary)

        let expectation = XCTestExpectation(description: #function)

        sut?.$amount
            .dropFirst(2)
            .sink { value in
                XCTAssertEqual(value, expected)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        interactor?.transactions.send(inputTransactions)
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_whenInputTwoCategories_thenResultingCategoryIsCorrect() throws {
        let inputTransactions: [TransactionModel] = [
            .sample(category: .health),
            .sample(category: .entertainment)
        ]
        let expected = TransactionModel.Category.all.toDisplayModel()
        let expectation = XCTestExpectation(description: #function)

        sut?.$category
            .dropFirst(2)
            .sink { value in
                XCTAssertEqual(value, expected)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        interactor?.transactions.send(inputTransactions)
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_whenInputTwoSameCategories_thenResultingCategoryIsCorrect() throws {
        let inputTransactions: [TransactionModel] = [
            .sample(category: .entertainment),
            .sample(category: .entertainment)
        ]
        let expected = TransactionModel.Category.entertainment.toDisplayModel()
        let expectation = XCTestExpectation(description: #function)

        sut?.$category
            .dropFirst(2)
            .sink { value in
                XCTAssertEqual(value, expected)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        interactor?.transactions.send(inputTransactions)
        wait(for: [expectation], timeout: 1)
    }

}

extension CategoryView.Model: Equatable {

    public static func == (lhs: CategoryView.Model, rhs: CategoryView.Model) -> Bool {
        lhs.id == rhs.id
    }

}
