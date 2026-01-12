//
//  RecipeListView.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var selectedRecipe: Recipe?

    var body: some View {
        List(viewModel.recipes) { recipe in
            RecipeGridItemView(recipe: recipe)
                .listRowSeparator(.hidden)
                .listRowInsets(.horizontal, 16)
                .listRowBackground(Color.adaptiveAccent)
                .onTapGesture {
                selectedRecipe = recipe
            }
        }.listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.adaptiveAccent)
            .navigationTitle("My Flavor Files")
            .onAppear {
            Task { await viewModel.loadRecipes() }
        }.sheet(item: $selectedRecipe) { recipe in
            NavigationStack {
                RecipeDetailView(recipeId: recipe.id)
                    .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button { selectedRecipe = nil
                        } label: {
                            Image(systemName: "xmark")
                        }.accessibilityLabel("Close")
                    }
                }
            }
        }
    }
}
