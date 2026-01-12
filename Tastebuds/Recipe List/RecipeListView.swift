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
    @State private var activeFilter: Filter?
    @State private var activeIngredientFilter: IngredientFilter?

    var body: some View {
        filterChips()
        List(viewModel.filteredRecipes) { recipe in
            VStack(alignment: .leading, spacing: 4) {
                recipeRowContent(recipe)
                instructionSnippet(recipe)
            }.listRowSeparator(.hidden)
                .listRowBackground(Color.adaptiveAccent)
        }.listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.adaptiveAccent)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
            ToolbarItem(placement: .principal) {
                navigationTitle()
            }
        }.onAppear {
            Task { await viewModel.loadRecipes() }
        }.searchable(
            text: $viewModel.searchQuery,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search recipes or cooking instructions"
        ).sheet(item: $selectedRecipe) { recipe in
            recipeDetailsView(recipe)
        }.sheet(item: $activeFilter) { filter in
            NavigationStack {
                FilterDetailView(filter: filter) { updatedOptions in
                    viewModel.handleFilterUpdate(filterType: filter.type, options: updatedOptions)
                    activeFilter = nil
                }
            }
        }.sheet(item: $activeIngredientFilter) { filter in
            NavigationStack {
                IngredientFilterDetailView(filter: filter) { updatedFilter in
                    viewModel.ingredientsFilter = updatedFilter
                    activeIngredientFilter = nil
                }
            }
        }
    }
}

// MARK: Content View
extension RecipeListView {
    @ViewBuilder func navigationTitle() -> some View {
        Text("What’s Cooking?")
            .font(.title2.bold())
            .foregroundColor(.primaryBrandColor)
    }

    @ViewBuilder func recipeRowContent(_ recipe: Recipe) -> some View {
        RecipeGridItemView(recipe: recipe)
            .listRowSeparator(.hidden)
            .listRowInsets(.horizontal, 16)
            .listRowBackground(Color.adaptiveAccent)
            .onTapGesture {
            selectedRecipe = recipe
        }
    }

    @ViewBuilder func instructionSnippet(_ recipe: Recipe) -> some View {
        if viewModel.hasSnippet, let snippet = viewModel.snippet(for: recipe) {
            Text("\(snippet)… ")
                .foregroundColor(.primary)
                .lineLimit(2)
            Text("See more")
                .foregroundColor(.primaryBrandColor)
                .bold()
        }
    }

    @ViewBuilder private func filterChips() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "Dietary",
                           isSelected: viewModel.dietaryFilter?.options.contains(where: \.isSelected) ?? false,
                           selectedCount: viewModel.dietaryFilter?.options.filter({ $0.isSelected }).count) {
                    activeFilter = viewModel.dietaryFilter
                }

                FilterChip(title: "Servings",
                           isSelected: viewModel.servingsFilter?.options.contains(where: \.isSelected) ?? false,
                           selectedCount: viewModel.servingsFilter?.options.filter({ $0.isSelected }).count) {
                    activeFilter = viewModel.servingsFilter
                }

                let includedCount = viewModel.ingredientsFilter?.included.filter(\.isSelected).count ?? 0
                let excludedCount = viewModel.ingredientsFilter?.excluded.filter(\.isSelected).count ?? 0
                let totalCount = includedCount + excludedCount

                FilterChip(title: "Ingredients", isSelected: totalCount > 0, selectedCount: totalCount) {
                    activeIngredientFilter = viewModel.ingredientsFilter
                }

                if viewModel.hasActiveFilters {
                    Button("Clear") {
                        viewModel.clearFilters()
                    }.font(.caption.bold())
                        .foregroundColor(.secondary)
                }
            }.padding(.horizontal, 16)
                .padding(.vertical, 8)
        }.listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .background(Color.adaptiveAccent)
    }
}

// MARK: Presented Views
extension RecipeListView {
    @ViewBuilder func recipeDetailsView(_ recipe: Recipe) -> some View {
        NavigationStack {
            RecipeDetailView(recipeId: recipe.id, highlightedString: viewModel.hasSnippet ? viewModel.searchQuery : nil)
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
