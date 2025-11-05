import SwiftUI
import UIKit

@available(iOS 15.0, *)
public struct SelectorView<Item: Equatable & Identifiable>: View {
    
    // MARK: - Properties
    
    let allItems: [Item]
    
    @State var selectedItem: Item?
    
    let title: String
    
    let titleBlock: (Item) -> String
    
    let iconBlock: ((Item) -> String?)?
    
    let leftIconBlock: ((Item) -> String?)?
    
    let onSelection: (Item) -> Void
    
    let searchFilter: ((Item, String) -> Bool)?
    
    let searchPlaceholder: String
    
    let selectedRowColor: Color
    
    // MARK: - State
    
    @State private var searchText: String = ""
    
    // MARK: - Computed Properties
    
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return allItems
        }
        
        if let searchFilter {
            return allItems.filter { searchFilter($0, searchText) }
        }
        
        return allItems.filter {
            titleBlock($0).lowercased().contains(searchText.lowercased())
        }
    }
    
    public init(
        items: [Item],
        selected: Item? = nil,
        title: String,
        titleBlock: @escaping (Item) -> String,
        iconBlock: ((Item) -> String?)? = nil,
        leftIconBlock: ((Item) -> String?)? = nil,
        searchFilter: ((Item, String) -> Bool)? = nil,
        searchPlaceholder: String? = nil,
        selectedRowColor: Color? = nil,
        onSelection: @escaping (Item) -> Void
    ) {
        self.allItems = items
        self.selectedItem = selected
        self.title = title
        self.titleBlock = titleBlock
        self.iconBlock = iconBlock
        self.leftIconBlock = leftIconBlock
        self.searchFilter = searchFilter
        self.searchPlaceholder = searchPlaceholder ?? __("search")
        self.selectedRowColor = selectedRowColor ?? .blue
        self.onSelection = onSelection
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if filteredItems.isEmpty {
                    emptyStateView
                } else {
                    itemsList
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: searchPlaceholder)
        }
    }
    
    // MARK: - Subviews
    
    private var itemsList: some View {
        List(filteredItems) { item in
            let isSelected = item == selectedItem
            SelectorRow(
                title: titleBlock(item),
                iconName: iconBlock?(item),
                leftIconName: leftIconBlock?(item),
                isSelected: isSelected,
                selectedRowColor: selectedRowColor
            )
            .onTapGesture {
                selectedItem = item
                onSelection(item)
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(__("noResults"))
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - SelectorRow

private struct SelectorRow: View {
    let title: String
    let iconName: String?
    let leftIconName: String?
    let isSelected: Bool
    let selectedRowColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            if let leftIconName {
                imageFor(leftIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.secondary)
            }
            
            if let iconName {
                imageFor(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(selectedRowColor)
                    .font(.body.weight(.semibold))
            }
        }
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
        .listRowBackground(isSelected ? selectedRowColor.opacity(0.1) : Color.clear)
    }
}

// MARK: - Preview Helpers
struct PreviewItem: Equatable, Identifiable {
    let id: Int
    let name: String
    let iconName: String?
    
    static func == (lhs: PreviewItem, rhs: PreviewItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct SelectorView_Previews: PreviewProvider {
    static var previews: some View {
        let items: [PreviewItem] = [
            PreviewItem(id: 1, name: "Apple", iconName: "apple.logo"),
            PreviewItem(id: 2, name: "Banana", iconName: nil),
            PreviewItem(id: 3, name: "Cherry", iconName: "leaf.fill"),
            PreviewItem(id: 4, name: "Date", iconName: nil),
            PreviewItem(id: 5, name: "Elderberry", iconName: "star.fill")
        ]
        
        if #available(iOS 15.0, *) {
            SelectorView(
                items: items,
                selected: items[2],
                title: "Select Fruit",
                titleBlock: { $0.name },
                iconBlock: { $0.iconName },
                onSelection: {
                    print("Selected: \($0.name)")
                }
            )
        }
    }
}

