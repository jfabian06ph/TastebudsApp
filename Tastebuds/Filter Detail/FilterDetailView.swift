//
//  FilterDetailView.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/13/26.
//
import SwiftUI

struct FilterDetailView: View {
    // MARK: Environment Object
    @Environment(\.dismiss) private var dismiss

    // MARK: Data
    @State private var options: [FilterOption] = []
    let filter: Filter
    let onSave: ([FilterOption]) -> Void

    // MARK: Lifecycle
    init(filter: Filter, onSave: @escaping ([FilterOption]) -> Void) {
        self.filter = filter
        self.onSave = onSave
    }

    var body: some View {
        List {
            ForEach($options.indices, id: \.self) { index in
                filterValueRow(for: index)
            }
            clearButton()
        }.scrollContentBackground(.hidden)
            .background(Color.adaptiveAccent)
            .navigationTitle(filter.type.title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onSave(options)
                    }
                }
        }.onAppear {
            options = filter.options
        }

    }
}

// MARK: View contents
extension FilterDetailView {
    private func filterValueRow(for index: Int) -> some View {
        let option = options[index]
        return HStack {
            Text(option.title)
            Spacer()
            if option.isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.primaryBrandColor)
            }
        }.contentShape(Rectangle())
            .onTapGesture {
            toggle(index)
        }.listRowBackground(Color.cardBackgroundColor)
    }
    
    private func clearButton() -> some View {
        Section {
            HStack(alignment: .center) {
                Spacer()
                Button {
                    for i in options.indices {
                        options[i].isSelected = false
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
extension FilterDetailView {
    private func toggle(_ index: Int) {
        if filter.allowsMultipleSelection {
            options[index].isSelected.toggle()
        } else {
            for i in options.indices {
                options[i].isSelected = (i == index)
            }
        }
    }
}
