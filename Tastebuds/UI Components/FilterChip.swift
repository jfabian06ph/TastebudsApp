//
//  FilterChip.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/13/26.
//
import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let selectedCount: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(displayTitle)
                    .font(.caption.bold())
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }.padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule()
                    .stroke(isSelected ? Color.primaryBrandColor : Color.filterChipUnselectedStateColor, lineWidth: 1))
                .foregroundColor(isSelected ? Color.primaryBrandColor : Color.filterChipUnselectedStateColor)
        }.buttonStyle(.plain)
    }

    private var displayTitle: String {
        if isSelected, let count = selectedCount, count > 0 {
            return "\(title): \(count) selected"
        } else {
            return title
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        FilterChip(title: "Category",
                   isSelected: false,
                   selectedCount: nil,
                   action: { })

        FilterChip(title: "Category",
                   isSelected: true,
                   selectedCount: 3,
                   action: { })

        FilterChip(title: "Price",
                   isSelected: true,
                   selectedCount: nil,
                   action: { })
    }.padding()
}
