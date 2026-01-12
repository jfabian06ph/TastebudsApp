//
//  RecipeListRepository.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import Foundation

final class RecipeListRepository {
    func fetchRecipes() async -> [Recipe]? {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decoded.recipes
        } catch {
            return nil
        }
    }
}
