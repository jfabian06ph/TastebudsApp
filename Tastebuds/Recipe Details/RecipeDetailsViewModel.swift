//
//  RecipeDetailsViewModel.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import Combine
import Foundation
import SwiftUI

@MainActor final class RecipeDetailViewModel: ObservableObject {
    // MARK: Data
    @Published var recipe: Recipe?
    @Published var isLoading: Bool = false
    @Published var checkedIngredients: Set<String> = []
    @Published var highlightedString: String? = nil
    @Published var allIngredientsChecked: Bool = false
    let recipeId: String

    // MARK: Repository
    private let service: RecipeDetailsRepository

    // MARK: Lifecycle
    init(recipeId: String, highlightedString: String? = nil, service: RecipeDetailsRepository? = nil) {
        self.recipeId = recipeId
        self.highlightedString = highlightedString
        self.service = service ?? RecipeDetailsRepository()
    }

    func loadRecipe() async {
        isLoading = true
        defer { isLoading = false }

        // Artificial delay for mock loading
        try? await Task.sleep(nanoseconds: 1000_000_000)

        recipe = await service.fetchRecipe(id: recipeId)
    }

    // MARK: Helper functions for Ingredients
    func toggleIngredient(_ ingredient: String) {
        if checkedIngredients.contains(ingredient) {
            checkedIngredients.remove(ingredient)
        } else {
            checkedIngredients.insert(ingredient)
        }

        guard let ingredients = recipe?.ingredients else { return }
        allIngredientsChecked = Set(checkedIngredients) == Set(ingredients)
    }

    func isIngredientChecked(_ ingredient: String) -> Bool {
        checkedIngredients.contains(ingredient)
    }

    // MARK: Helper functions for Instructions
    /// Returns AttributedString with highlight if `highlightedString` exists
    func highlightedInstruction(_ instruction: String) -> AttributedString {
        var attributed = AttributedString(instruction)
        if let highlight = highlightedString, !highlight.isEmpty {
            let ranges = instruction.lowercased().ranges(of: highlight.lowercased())
            for range in ranges {
                if let attributedRange = Range(range, in: attributed) {
                    attributed[attributedRange].foregroundColor = Color.darkOrange
                    attributed[attributedRange].font = Font.body.bold()
                }
            }
        }
        return attributed
    }
}
