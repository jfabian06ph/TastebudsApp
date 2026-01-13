//
//  RecipeDetailsView.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI
import Foundation
import SDWebImageSwiftUI
import SSToastMessage

struct RecipeDetailView: View {
    // MARK: Data
    @StateObject private var viewModel: RecipeDetailViewModel
    @State var showToast = false
    @State private var chefsNote: String = ""

    // MARK: Lifecycle
    init(recipeId: String, highlightedString: String? = nil) {
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(recipeId: recipeId, highlightedString: highlightedString))
    }

    var body: some View {
        NavigationStack {
            content()
                .background(Color.adaptiveAccent)
                .task {
                await viewModel.loadRecipe()
            }.navigationBarTitleDisplayMode(.inline)
                .onAppear {
                loadNote()
            }.onChange(of: chefsNote) { _, _ in
                saveNote()
            }
        }
    }
}

// MARK: View contents
extension RecipeDetailView {
    @ViewBuilder func header() -> some View {
        ZStack(alignment: .bottomLeading) {
            if let imageLink = viewModel.recipe?.imageLink, let url = URL(string: imageLink) {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            } else {
                Image("webImagePlaceholder")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            }

            // View gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            ).frame(height: 180)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

            // Text content
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.recipe?.title ?? "")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .lineLimit(1)

                if let description = viewModel.recipe?.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .padding(.bottom, 8)
                }

                if let servingSuggestion = viewModel.recipe?.servings {
                    Text("Serving suggestion: \(servingSuggestion)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Text("Dietary attributes: \(viewModel.recipe?.dietary.map { $0.rawValue.capitalized }.joined(separator: ", ") ?? "None")")
                    .font(.caption)
                    .foregroundColor(.white)
                    .font(.caption)
                    .foregroundColor(.white)
            }.padding(12)
        }.frame(height: 180)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
    }

    @ViewBuilder func content() -> some View {
        if viewModel.isLoading {
            progressRowContent()
        } else {
            List {
                header()
                ingredientsSection()
                instructionSection()
                chefsNoteSection()
            }.listStyle(.plain)
                .present(isPresented: $viewModel.allIngredientsChecked, type: .toast, position: .bottom, horizontalPadding: 20) {
                bottomToastView()
            }
        }
    }
    
    @ViewBuilder func progressRowContent() -> some View {
        VStack(spacing: 16) {
            Text("Fetching flavors… 🍅🧄🥕🥘")
                .font(.headline)
                .foregroundColor(.primary)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding(.top, 12)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.adaptiveAccent)
    }

    @ViewBuilder func ingredientsSection() -> some View {
        Section {
            ForEach(viewModel.recipe?.ingredients ?? [], id: \.self) { ingredient in
                Button {
                    viewModel.toggleIngredient(ingredient)
                } label: {
                    HStack {
                        Image(systemName: viewModel.checkedIngredients.contains(ingredient) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(viewModel.checkedIngredients.contains(ingredient) ? .darkOrange : .primaryBrandColor)
                        Text(ingredient)
                            .strikethrough(viewModel.checkedIngredients.contains(ingredient))
                            .foregroundColor(viewModel.checkedIngredients.contains(ingredient) ? .secondary : .primary)
                    }.contentShape(Rectangle())
                }.buttonStyle(.plain)
                    .listRowBackground(Color.adaptiveAccent)
            }
        } header: {
            VStack(alignment: .leading, spacing: 4) {
                Text("Ingredients")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Tap the items to keep track of what’s ready")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.background(Color.adaptiveAccent)
        }
    }

    func bottomToastView() -> some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundColor(.yellow)
                Text("Nice! All your ingredients are set.\nLet's get cookin', shall we? 🥄🥗")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }.padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(Color.successToastBackgroundColor)
            .cornerRadius(12)
            .shadow(radius: 4)
    }

    @ViewBuilder func instructionSection() -> some View {
        Section {
            ForEach(Array(viewModel.recipe?.instructions.enumerated() ?? [].enumerated()), id: \.offset) { index, instruction in
                HStack(alignment: .top, spacing: 8) {
                    // Number in circle
                    ZStack {
                        Circle()
                            .fill(Color.darkOrange)
                            .frame(width: 24, height: 24)
                        Text("\(index + 1)")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }

                    // Instruction text
                    Text(viewModel.highlightedInstruction(instruction))
                        .multilineTextAlignment(.leading)
                }.padding(.vertical, 2)
                    .listRowBackground(Color.adaptiveAccent)
            }
        } header: {
            Text("Cooking instructions")
                .font(.headline)
                .foregroundColor(.primary)
                .background(Color.adaptiveAccent)
        }
    }

    @ViewBuilder func chefsNoteSection() -> some View {
        Section {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $chefsNote)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .foregroundColor(.primary)
                    .padding(12)
                    .font(.body)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primaryBrandColor.opacity(0.7), lineWidth: 1))

                if chefsNote.isEmpty {
                    Text("Chef’s thoughts go here… 👩‍🍳📝")
                        .foregroundColor(.gray)
                        .padding(16)
                }
            }.frame(minHeight: 120)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        } header: {
            Text("Chef’s note")
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}

// MARK: View actions
extension RecipeDetailView {
    // MARK: - Simple Persistence
    private func loadNote() {
        let key = "chefsNote_\(viewModel.recipeId)"
        chefsNote = UserDefaults.standard.string(forKey: key) ?? ""
    }

    private func saveNote() {
        let key = "chefsNote_\(viewModel.recipeId)"
        UserDefaults.standard.set(chefsNote, forKey: key)
    }
}

#Preview {
    RecipeDetailView(recipeId: "1")
        .padding()
}
