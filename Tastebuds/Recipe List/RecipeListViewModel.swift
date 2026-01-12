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
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var selectedDietary: Dietary?
    @Published var isLoading: Bool = false

    private let service: RecipeListRepository

    init(service: RecipeListRepository? = nil) {
        self.service = service ?? RecipeListRepository()
    }

    func loadRecipes() async {
        defer { isLoading = false }
        isLoading = true
        
        guard let response = await service.fetchRecipes() else {
            // Add empty view here
            return
        }
        self.recipes = response
    }

    var filteredRecipes: [Recipe] {
        recipes
            .filter { recipe in
                searchText.isEmpty ||
                recipe.title.localizedCaseInsensitiveContains(searchText)
            }
//            .filter { recipe in
//                guard let selectedDietary else { return true }
//                recipe.dietary.contains(selectedDietary)
//            }
    }
}
