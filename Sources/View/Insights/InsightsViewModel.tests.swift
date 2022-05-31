import XCTest
import Combine

@testable import TechChallenge

final class InsightsViewModelTests: XCTestCase {

    private var sut: InsightsViewModel?
    private var repository: RepositoryProtocolMock?

    private var cancellables: Set<AnyCancellable> = []

    private lazy var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    @MainActor
    override func setUp() {
        let repository = RepositoryProtocolMock()
        sut = InsightsViewModel(repository: repository)
        self.repository = repository
    }

    override func tearDown() {
        sut = nil
        repository = nil
        cancellables.cancel()
        cancellables.removeAll()
    }

}

extension InsightsViewModelTests {

    @MainActor
    func test_whenManyTransactionsTwoCategory_thenListOfCategoriesIsCorrect() throws {
        let inputTransactions: [TransactionModel] = [
            .sample(category: .health, amount: 12.01),
            .sample(category: .health, amount: 9),
            .sample(category: .food, amount: 2)
        ]
        let amountSummaryHealth = inputTransactions.filter { $0.category == .health }.map { $0.amount }.reduce(0, +)
        let amountSummaryFood = inputTransactions.filter { $0.category == .food }.map { $0.amount }.reduce(0, +)

        let expectedSummaryHealth = amountFormatter.string(for: amountSummaryHealth)
        let expectedSummaryFood = amountFormatter.string(for: amountSummaryFood)
        let expectedRowsCount = 2

        repository?.pinnedTransactionsReturnValue = inputTransactions

        let expectation = XCTestExpectation(description: #function)

        sut?.$categoriesSummaryModels
            .dropFirst(1)
            .sink { value in
                XCTAssertEqual(value.count, expectedRowsCount)
                XCTAssertEqual(value.first?.amount, expectedSummaryHealth)
                XCTAssertEqual(value.first?.titleKey, "category-health")
                XCTAssertEqual(value.last?.amount, expectedSummaryFood)
                XCTAssertEqual(value.last?.titleKey, "category-food")

                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut?.viewDidAppear()
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_whenNoTransactions_thenListOfCategoriesIsCorrect() throws {
        let inputTransactions: [TransactionModel] = []

        let expectedRowsCount = 0

        repository?.pinnedTransactionsReturnValue = inputTransactions

        let expectation = XCTestExpectation(description: #function)

        sut?.$categoriesSummaryModels
            .dropFirst(1)
            .sink { value in
                XCTAssertEqual(value.count, expectedRowsCount)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut?.viewDidAppear()
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_whenOneTransaction_thenRingModelsIsCorrect() throws {
        let inputTransactions: [TransactionModel] = [
            .sample(category: .health, amount: 42)
        ]

        let expectedModelsCount = 1
        let expectedStartAngle = 0.0
        let expectedRatio = 1.0

        repository?.pinnedTransactionsReturnValue = inputTransactions

        let expectation = XCTestExpectation(description: #function)

        sut?.$ringModels
            .dropFirst(1)
            .sink { value in
                XCTAssertEqual(value.count, expectedModelsCount)
                XCTAssertEqual(value.first?.startAngle, expectedStartAngle)
                XCTAssertEqual(value.first?.ratio, expectedRatio)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut?.viewDidAppear()
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_whenNoTransaction_thenRingModelsIsCorrect() throws {
        let inputTransactions: [TransactionModel] = []

        let expectedModelsCount = 0

        repository?.pinnedTransactionsReturnValue = inputTransactions

        let expectation = XCTestExpectation(description: #function)

        sut?.$ringModels
            .dropFirst(1)
            .sink { value in
                XCTAssertEqual(value.count, expectedModelsCount)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut?.viewDidAppear()
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_whenThreeTransaction_thenRingModelsIsCorrect() throws {
        let inputTransactions: [TransactionModel] = [
            .sample(category: .health, amount: 40),
            .sample(category: .food, amount: 10),
            .sample(category: .food, amount: 50)
        ]

        let expectedModelsCount = 2

        let expectedStartAngle = 0.0
        let expectedRatio = 0.6
        let expectedTitle = "60%"

        let expectedStartAngle2 = 0.6
        let expectedRatio2 = 0.4
        let expectedTitle2 = "40%"

        repository?.pinnedTransactionsReturnValue = inputTransactions

        let expectation = XCTestExpectation(description: #function)

        sut?.$ringModels
            .dropFirst(1)
            .sink { value in
                XCTAssertEqual(value.count, expectedModelsCount)
                XCTAssertEqual(value.first?.startAngle, expectedStartAngle)
                XCTAssertEqual(value.first?.ratio, expectedRatio)
                XCTAssertEqual(value.first?.title, expectedTitle)

                XCTAssertEqual(value.last?.startAngle, expectedStartAngle2)
                XCTAssertEqual(value.last?.ratio, expectedRatio2)
                XCTAssertEqual(value.last?.title, expectedTitle2)

                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut?.viewDidAppear()
        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_whenThreeTransactionWithSmallFraction_thenRingModelsIsCorrect() throws {
        let inputTransactions: [TransactionModel] = [
            .sample(category: .health, amount: 0.12),
            .sample(category: .food, amount: 123),
            .sample(category: .food, amount: 500)
        ]

        let expectedModelsCount = 2

        let expectedStartAngle = 0.0
        let expectedRatio = 0.99
        let expectedTitle = "100%"

        let expectedStartAngle2 = 0.99
        let expectedRatio2 = 0.1
        let expectedTitle2 = "<1%"

        repository?.pinnedTransactionsReturnValue = inputTransactions

        let expectation = XCTestExpectation(description: #function)

        sut?.$ringModels
            .dropFirst(1)
            .sink { value in
                XCTAssertEqual(value.count, expectedModelsCount)
                XCTAssertEqual(value.first?.startAngle, expectedStartAngle)
                XCTAssertTrue(value.first?.ratio ?? 0 > expectedRatio)
                XCTAssertEqual(value.first?.title, expectedTitle)

                XCTAssertTrue(value.last?.startAngle ?? 100 > expectedStartAngle2)
                XCTAssertTrue(value.last?.ratio ?? 1 < expectedRatio2)
                XCTAssertEqual(value.last?.title, expectedTitle2)

                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut?.viewDidAppear()
        wait(for: [expectation], timeout: 1)
    }

}
