//
//  RecipeDetailsRepository.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import Foundation

final class RecipeDetailsRepository {
    func fetchRecipe(id: String) async -> Recipe? {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(RecipeResponse.self, from: data)
        else { return nil }
        return decoded.recipes.first { $0.id == id }
    }
}

