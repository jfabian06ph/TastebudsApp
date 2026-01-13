//
//  RecipeListViewModel.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI
import Foundation
import Combine

@MainActor final class RecipeListViewModel: ObservableObject {
    // MARK: - Data
    @Published private(set) var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var isShowingEmptyState = false

    // MARK: - Search & Filters
    @Published var searchQuery = ""
    @Published var dietaryFilter: Filter?
    @Published var servingsFilter: Filter?
    @Published var ingredientsFilter: IngredientFilter?
    @Published var selectedServings: Int? = nil
    @Published var selectedDiets: Set<Dietary> = []

    // MARK: - Repository
    private let service: RecipeListRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(service: RecipeListRepository? = nil) {
        self.service = service ?? RecipeListRepository()
        setupDebouncer()
    }

    func loadRecipes() async {
        isLoading = true
        defer { isLoading = false }

        guard let response = await service.fetchRecipes() else {
            recipes = []
            filteredRecipes = []
            return
        }
        recipes = response
        loadAgrregationValues()
    }

    func loadAgrregationValues() {
        dietaryFilter = Filter(type: .dietary, selectionType: .multiple, options: [
                .init(id: "vegetarian", title: "Vegetarian", isSelected: false),
                .init(id: "vegan", title: "Vegan", isSelected: false),
                .init(id: "glutenFree", title: "Gluten Free", isSelected: false)
        ])

        servingsFilter = Filter(type: .servings, selectionType: .single, options: [
                .init(id: "2", title: "2 servings", isSelected: false),
                .init(id: "4", title: "4 servings", isSelected: false),
                .init(id: "6", title: "6 servings", isSelected: false)
        ])

        ingredientsFilter = IngredientFilter(
            included: [
                IngredientOption(id: "chili", name: "Chili", isSelected: false),
                IngredientOption(id: "garlic", name: "Garlic", isSelected: false),
                IngredientOption(id: "onion", name: "Onion", isSelected: false)
            ],
            excluded: [
                IngredientOption(id: "milk", name: "Milk", isSelected: false),
                IngredientOption(id: "eggs", name: "Eggs", isSelected: false)
            ])
    }
}

// MARK: - Filters and Search
extension RecipeListViewModel {
    func setupDebouncer() {
        Publishers.CombineLatest4(
            $searchQuery
                .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
                .removeDuplicates(),
            $selectedDiets.removeDuplicates(),
            $selectedServings.removeDuplicates(),
            $ingredientsFilter.removeDuplicates()
        ).receive(on: RunLoop.main)
            .sink { [weak self] _, _, _, _ in
            self?.applyFilters()
        }.store(in: &cancellables)
    }

    @MainActor func applyFilters() {
        filteredRecipes = recipes.filter { recipe in
            let matchesSearch =
                searchQuery.isEmpty ||
                recipe.title.localizedCaseInsensitiveContains(searchQuery) ||
                recipe.instructions.contains {
                $0.localizedCaseInsensitiveContains(searchQuery)
            }

            let matchesDietary = selectedDiets.isEmpty || recipe.dietary.contains { selectedDiets.contains($0) }

            let matchesServings = selectedServings == nil || recipe.servings == selectedServings

            var matchesIngredients = true
            if let ingredientFilter = ingredientsFilter {
                let recipeIngredients = recipe.ingredients

                let includedIngredients = ingredientFilter.included.filter(\.isSelected).map(\.name)
                if !includedIngredients.isEmpty {
                    let matches = includedIngredients.contains { ingredient in
                        let rec = recipeIngredients
                        let doesContain = rec.contains { $0.localizedCaseInsensitiveContains(ingredient) }
                        return doesContain
                    }
                    matchesIngredients = matches
                }

                let excludedIngredients = ingredientFilter.excluded.filter(\.isSelected).map(\.name)
                if !excludedIngredients.isEmpty {
                    matchesIngredients = !excludedIngredients.contains { ingredient in
                        recipeIngredients.contains { $0.localizedCaseInsensitiveContains(ingredient) }
                    }
                }
            }
            return matchesSearch && matchesDietary && matchesServings && matchesIngredients
        }
        isShowingEmptyState = filteredRecipes.isEmpty
    }

    func handleFilterUpdate(filterType: FilterType, options: [FilterOption]) {
        switch filterType {
        case .servings:
            servingsFilter?.options = options
            selectedServings = options.first(where: \.isSelected).flatMap { Int($0.id) }
        case .dietary:
            dietaryFilter?.options = options
            selectedDiets = Set(options.filter { $0.isSelected }.compactMap { Dietary(rawValue: $0.id) })
        default:
            break
        }
        applyFilters()
    }

    var hasActiveFilters: Bool {
        let hasServings = selectedServings != nil
        let hasDiet = !selectedDiets.isEmpty
        let hasIngredients = (ingredientsFilter?.included.contains(where: \.isSelected) ?? false) ||
                             (ingredientsFilter?.excluded.contains(where: \.isSelected) ?? false)
        return hasServings || hasDiet || hasIngredients
    }

    func clearFilters() {
        selectedServings = nil
        selectedDiets = []
        loadAgrregationValues()
        applyFilters()
        isShowingEmptyState = false
    }
}

// MARK: - Text Snippets
extension RecipeListViewModel {
    func snippet(for recipe: Recipe) -> String? {
        guard !searchQuery.isEmpty else { return nil }
        return recipe.instructions.first { $0.localizedCaseInsensitiveContains(searchQuery) }
    }

    var hasSnippet: Bool {
        !searchQuery.isEmpty
    }
}

// MARK: - Helper functions for Ingredient Filter
extension RecipeListViewModel {
    var selectedIngredientsCount: Int {
        guard let filter = ingredientsFilter else { return 0 }
        let included = filter.included.filter(\.isSelected).count
        let excluded = filter.excluded.filter(\.isSelected).count
        return included + excluded
    }

    var hasSelectedIngredients: Bool {
        selectedIngredientsCount > 0
    }
}
