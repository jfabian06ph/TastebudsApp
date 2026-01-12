//
//  RecipeResponse.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import Foundation

struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Identifiable, Decodable {
    let id: String
    let title: String
    let description: String?
    let servings: Int
    let ingredients: [String]
    let instructions: [String]
    let dietary: [Dietary]
    let imageLink: String?
}

enum Dietary: String, Decodable {
    case vegetarian
    case vegan
    case glutenFree
}
