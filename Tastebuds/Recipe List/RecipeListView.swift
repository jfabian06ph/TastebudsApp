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
            recipeRowContent(recipe)
        }.listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.adaptiveAccent)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
            ToolbarItem(placement: .principal) {
                Text("What’s Cooking?")
                    .font(.title2.bold())
                    .foregroundColor(.primaryBrandColor)
            }
        }.onAppear {
            Task { await viewModel.loadRecipes() }
        }.sheet(item: $selectedRecipe) { recipe in
            recipeDetailsView(recipe)
        }
    }
}

// MARK: Content View
extension RecipeListView {
    @ViewBuilder func recipeRowContent(_ recipe: Recipe) -> some View {
        RecipeGridItemView(recipe: recipe)
            .listRowSeparator(.hidden)
            .listRowInsets(.horizontal, 16)
            .listRowBackground(Color.adaptiveAccent)
            .onTapGesture {
            selectedRecipe = recipe
        }
    }
}

// MARK: Presented Views
extension RecipeListView {
    @ViewBuilder func recipeDetailsView(_ recipe: Recipe) -> some View {
        NavigationStack {
            RecipeDetailView(recipeId: recipe.id)
                .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedRecipe = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primaryBrandColor)
                            .frame(width: 24, height: 24)
                            .padding(8)
                    }.accessibilityLabel("Close")
                        .contentShape(Circle())
                }
            }
        }
    }
}

#Preview {
    RecipeListView()
        .padding()
}
