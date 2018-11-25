import FluentPostgreSQL
import Foundation

// 1
final class AcronymCategoryPivot: PostgreSQLUUIDPivot,
ModifiablePivot {
    // 2
    var id: UUID?
    // 3
    var acronymID: Acronym.ID
    var categoryID: Category.ID
    
    // 4
    typealias Left = Acronym
    typealias Right = Category
    // 5
    static let leftIDKey: LeftIDKey = \.acronymID
    static let rightIDKey: RightIDKey = \.categoryID
    
    // 6
    init(_ acronym: Acronym, _ category: Category) throws {
        self.acronymID = try acronym.requireID()
        self.categoryID = try category.requireID()
    }
}


extension AcronymCategoryPivot: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.acronymID, to: \Acronym.id, onDelete: .cascade)
            builder.reference(from: \.categoryID, to: \Category.id, onDelete: .cascade)
        }
    }
}
