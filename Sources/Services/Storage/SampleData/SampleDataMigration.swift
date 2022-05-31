import CoreData

final class SampleDataMigration {

    static func start(using context: NSManagedObjectContext) {
        guard doesDatabaseContainsData(in: context) == false else {
            return
        }

        let cats = createCategories(using: context)
        createTransactions(for: cats)
    }

}

private extension SampleDataMigration {

    static func doesDatabaseContainsData(in context: NSManagedObjectContext) -> Bool {
        let request = CategoryDBDto.fetchRequest()
        return context.performAndWait {
            return (try? context.count(for: request)) ?? 1 != 0
        }
    }

    static func createTransactions(for categories: [CategoryDBDto]) {
        guard let context = categories.first?.managedObjectContext else {
            return assertionFailure()
        }

        context.perform {
            ModelData.sampleTransactions.forEach { transaction in
                let dbModel = NSEntityDescription.insertNewObject(
                    forEntityName: "TransactionDBDto",
                    into: context
                ) as? TransactionDBDto

                dbModel?.accountName = transaction.accountName
                dbModel?.amount = transaction.amount
                dbModel?.date = transaction.date
                dbModel?.transactionId = Int64(transaction.id)
                dbModel?.name = transaction.name
                dbModel?.provider = transaction.provider?.rawValue
                dbModel?.category = categories.first(
                    where: { $0.name ==  transaction.category.rawValue }
                )
            }

            do {
                try context.save()
            } catch {
                assertionFailure()
            }
        }
    }

    static func createCategories(using context: NSManagedObjectContext) -> [CategoryDBDto] {
        let names = TransactionModel.Category.allCases.map { $0.rawValue }

        return context.performAndWait {
            var result = [CategoryDBDto]()
            names.forEach { name in
                if name != "all" {
                    if let dbModel = NSEntityDescription.insertNewObject(
                        forEntityName: "CategoryDBDto",
                        into: context
                    ) as? CategoryDBDto {
                        dbModel.name = name
                        result.append(dbModel)
                    }
                }
            }
            do {
                try context.save()

            } catch {
                assertionFailure()
            }

            return result
        }
    }

}
