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
        VStack(spacing: 0) {
            filterChips()
            if viewModel.isShowingEmptyState {
                emptyState()
            }
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
                if viewModel.hasActiveFilters {
                    Button {
                        viewModel.clearFilters()
                    } label: {
                        Label("Clear", systemImage: "xmark.circle.fill")
                            .labelStyle(IconOnlyLabelStyle())
                            .foregroundColor(.primaryBrandColor)
                    }
                }

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
            }.padding(.horizontal, 16)
                .padding(.vertical, 8)
        }.listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .background(Color.adaptiveAccent)
    }

    @ViewBuilder func emptyState() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.primaryBrandColor)
            Text("Oops! Nothing to show here…")
                .font(.headline)
                .foregroundColor(.primaryBrandColor)
            Text("Try adjusting your filters or search to find some tasty recipes! 🍳🥗")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primaryBrandColor)
                .padding(.horizontal, 32)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.adaptiveAccent)
    }
}

// MARK: Presented Views
extension RecipeListView {
    @ViewBuilder func recipeDetailsView(_ recipe: Recipe) -> some View {
        RecipeDetailView(recipeId: recipe.id, highlightedString: viewModel.hasSnippet ? viewModel.searchQuery : nil)
    }
}

#Preview {
    RecipeListView()
        .padding()
}
