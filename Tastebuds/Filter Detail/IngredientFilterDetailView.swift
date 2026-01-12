//
//  IngredientFilterDetailView.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/13/26.
//

import SwiftUI

struct IngredientFilterDetailView: View {
    //MARK: Data
    @State var filter: IngredientFilter
    var onSave: (IngredientFilter) -> Void

    var body: some View {
        List {
            includedIngredientsSection()
            excludedIngredientsSection()
            clearButton()
        }.scrollContentBackground(.hidden)
            .background(Color.adaptiveAccent)
            .navigationTitle("Ingredients")
            .onChange(of: filter.excluded) { oldValue, newValue in
            resetExcludeFilter(newValue)
        }.onChange(of: filter.included) { oldValue, newValue in
            resetIncludeFilter(newValue)
        }.toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    onSave(filter)
                }
            }
        }
    }
}

// MARK: View contents
extension IngredientFilterDetailView {
    private func includedIngredientsSection() -> some View {
        Section {
            ForEach($filter.included) { $ingredient in
                Toggle(ingredient.name, isOn: $ingredient.isSelected)
                    .listRowBackground(Color.cardBackgroundColor)
            }
        } header: {
            Text("Include")
                .font(.headline)
                .foregroundColor(.primary)
                .background(Color.adaptiveAccent)
        }
    }
    
    private func excludedIngredientsSection() -> some View {
        Section {
            ForEach($filter.excluded) { $ingredient in
                Toggle(ingredient.name, isOn: $ingredient.isSelected)
                    .listRowBackground(Color.cardBackgroundColor)
            }
        } header: {
            Text("Exclude")
                .font(.headline)
                .foregroundColor(.primary)
                .background(Color.adaptiveAccent)
        }
    }
    
    private func clearButton() -> some View {
        Section {
            HStack(alignment: .center) {
                Spacer()
                Button {
                    for i in filter.included.indices {
                        filter.included[i].isSelected = false
                    }
                    for i in filter.excluded.indices {
                        filter.excluded[i].isSelected = false
                    }
                } label: {
                    Label("Clear all selections", systemImage: "trash")
                        .font(.headline)
                        .foregroundColor(.primaryBrandColor)
                }.tint(.primaryBrandColor)
                Spacer()
            }.listRowBackground(Color.cardBackgroundColor)
        }
    }
}

// MARK: View actions
extension IngredientFilterDetailView {
    func resetIncludeFilter(_ option: [IngredientOption]) {
        if option.map({ $0.isSelected }).contains(true) {
            for i in filter.included.indices {
                filter.included[i].isSelected = false
            }
        }
    }
    
    func resetExcludeFilter(_ option: [IngredientOption]) {
        if option.map({ $0.isSelected }).contains(true) {
            for i in filter.excluded.indices {
                filter.excluded[i].isSelected = false
            }
        }
    }
}
