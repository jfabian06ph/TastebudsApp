//
//  RecipeDetailsViewModel.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import Combine

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: Recipe?
    @Published var isLoading: Bool = false
    @Published var checkedIngredients: Set<String> = []

    private let service: RecipeDetailsRepository
    private let recipeId: String

    init(recipeId: String, service: RecipeDetailsRepository? = nil) {
        self.recipeId = recipeId
        self.service = service ?? RecipeDetailsRepository()
    }

    func loadRecipe() async {
        isLoading = true
        defer { isLoading = false }

        // Artificial delay for mock loading
        try? await Task.sleep(nanoseconds: 1000_000_000)

        recipe = await service.fetchRecipe(id: recipeId)
    }

    func toggleIngredient(_ ingredient: String) {
        if checkedIngredients.contains(ingredient) {
            checkedIngredients.remove(ingredient)
        } else {
            checkedIngredients.insert(ingredient)
        }
    }

    func isIngredientChecked(_ ingredient: String) -> Bool {
        checkedIngredients.contains(ingredient)
    }
}
