//
//  FilterModel.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/13/26.
//

import Foundation

enum FilterSelectionType {
    case single
    case multiple
}

enum FilterType: String, Identifiable, CaseIterable {
    case servings
    case dietary
    case ingredients

    var id: String { rawValue }

    var title: String {
        switch self {
        case .servings:
            return "Servings"
        case .dietary:
            return "Dietary"
        case .ingredients:
            return "Ingredients"
        }
    }
}

struct Filter: Identifiable {
    let type: FilterType
    var id: FilterType { type }
    let selectionType: FilterSelectionType
    var options: [FilterOption]
    var allowsMultipleSelection: Bool {
        selectionType == .multiple
    }
}

struct FilterOption: Identifiable, Hashable {
    let id: String
    let title: String
    var isSelected: Bool
}

struct IngredientFilter: Identifiable, Equatable {
    var id = UUID()
    var included: [IngredientOption]
    var excluded: [IngredientOption]

    static func == (lhs: IngredientFilter, rhs: IngredientFilter) -> Bool {
        lhs.included == rhs.included && lhs.excluded == rhs.excluded
    }
}

struct IngredientOption: Identifiable, Equatable {
    let id: String
    let name: String
    var isSelected: Bool
}
