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
    
    @MainActor let onSelection: (Item?) -> Void
    
    let searchable: Bool
    
    let searchFilter: ((Item, String) -> Bool)?
    
    let searchPlaceholder: String
    
    let selectedRowColor: Color
    
    let showBackButton: Bool
    
    let nilOptionTitle: String?
        
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
            titleBlock($0).localizedStandardContains(searchText)
        }
    }
    
    public init(
        items: [Item],
        selected: Item? = nil,
        title: String,
        titleBlock: @escaping (Item) -> String,
        iconBlock: ((Item) -> String?)? = nil,
        leftIconBlock: ((Item) -> String?)? = nil,
        nilOptionTitle: String? = nil,
        searchable: Bool = true,
        searchFilter: ((Item, String) -> Bool)? = nil,
        searchPlaceholder: String? = nil,
        selectedRowColor: Color? = nil,
        showBackButton: Bool = false,
        onSelection: @escaping (Item?) -> Void
    ) {
        self.allItems = items
        self.selectedItem = selected
        self.title = title
        self.titleBlock = titleBlock
        self.iconBlock = iconBlock
        self.leftIconBlock = leftIconBlock
        self.nilOptionTitle = nilOptionTitle
        self.searchable = searchable
        self.searchFilter = searchFilter
        self.searchPlaceholder = searchPlaceholder ?? Dejavu.trans("search")
        self.selectedRowColor = selectedRowColor ?? .blue
        self.showBackButton = showBackButton
        self.onSelection = onSelection
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            Group {
                if filteredItems.isEmpty && nilOptionTitle == nil {
                    EmptyContentView(
                        icon: "magnifyingglass",
                        text: Dejavu.trans("noResults")
                    ) {}
                } else {
                    itemsList
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .if(searchable) {
                $0.searchable(text: $searchText, prompt: searchPlaceholder)
            }
            .if(showBackButton) { view in
                view.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            onSelection(nil)
                        }) {
                            Text(Dejavu.trans("back"))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var itemsList: some View {
        List {
            if let nilOptionTitle {
                SelectorRow(
                    title: nilOptionTitle,
                    iconName: nil,
                    leftIconName: nil,
                    isSelected: selectedItem == nil,
                    selectedRowColor: selectedRowColor
                )
                .onTapGesture {
                    selectedItem = nil
                    onSelection(nil)
                }
            }
            ForEach(filteredItems) { item in
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
        }
        .listStyle(.plain)
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
                Dejavu.imageFor(leftIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.secondary)
            }
            
            if let iconName {
                Dejavu.imageFor(iconName)
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

// MARK: - Helpers
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


struct PreviewCountry: Equatable, Identifiable {
    let id: String
    let name: String
    
    static func == (lhs: PreviewCountry, rhs: PreviewCountry) -> Bool {
        lhs.id == rhs.id
    }
}

struct PreviewVehicle: Equatable, Identifiable {
    let id: Int
    let name: String
    let iconName: String
    let flagIcon: String?
    
    static func == (lhs: PreviewVehicle, rhs: PreviewVehicle) -> Bool {
        lhs.id == rhs.id
    }
}

struct PreviewCategory: Equatable, Identifiable {
    let id: Int
    let name: String
    
    static func == (lhs: PreviewCategory, rhs: PreviewCategory) -> Bool {
        lhs.id == rhs.id
    }
}

struct PreviewProduct: Equatable, Identifiable {
    let id: Int
    let name: String
    let code: String
    let description: String
    
    static func == (lhs: PreviewProduct, rhs: PreviewProduct) -> Bool {
        lhs.id == rhs.id
    }
}

@available(iOS 15.0, *)
struct Preview: View {
    @State private var selectedCountry: PreviewCountry? = PreviewCountry(id: "us", name: "United States")
    @State private var selectedVehicle: PreviewVehicle? = PreviewVehicle(id: 3, name: "Airplane", iconName: "airplane", flagIcon: "flag")
    @State private var selectedProduct: PreviewProduct? = nil
    @State private var selectedCategory: PreviewCategory? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SelectorView(
                    items: [
                        PreviewCountry(id: "us", name: "United States"),
                        PreviewCountry(id: "uk", name: "United Kingdom"),
                        PreviewCountry(id: "cat", name: "Catalonia")
                    ],
                    selected: selectedCountry,
                    title: "Select Country",
                    titleBlock: { $0.name },
                    onSelection: { country in
                        selectedCountry = country
                    }
                )
                
                .frame(height: 300)
                
                SelectorView(
                    items: [
                        PreviewVehicle(id: 1, name: "Car", iconName: "car", flagIcon: "environments"),
                        PreviewVehicle(id: 2, name: "Bus", iconName: "bus", flagIcon: "environments"),
                        PreviewVehicle(id: 3, name: "Airplane", iconName: "airplane", flagIcon: "wind")
                    ],
                    selected: selectedVehicle,
                    title: "Select Vehicle",
                    titleBlock: { $0.name },
                    iconBlock: { $0.iconName },
                    leftIconBlock: { $0.flagIcon },
                    onSelection: { vehicle in
                        selectedVehicle = vehicle
                    }
                )
                .frame(height: 300)
                
                SelectorView(
                    items: [
                        PreviewProduct(id: 1, name: "Widget", code: "W001", description: "A small widget"),
                        PreviewProduct(id: 2, name: "Gadget", code: "G002", description: "A large gadget")
                    ],
                    selected: selectedProduct,
                    title: "Select Product",
                    titleBlock: { $0.name },
                    searchFilter: { product, searchText in
                        product.name.localizedCaseInsensitiveContains(searchText) ||
                        product.code.localizedCaseInsensitiveContains(searchText) ||
                        product.description.localizedCaseInsensitiveContains(searchText)
                    },
                    onSelection: { product in
                        selectedProduct = product
                    }
                )
                .frame(height: 300)
                
                SelectorView(
                    items: [
                        PreviewCategory(id: 1, name: "Electronics"),
                        PreviewCategory(id: 2, name: "Clothing"),
                        PreviewCategory(id: 3, name: "Food")
                    ],
                    selected: selectedCategory,
                    title: "Select Category",
                    titleBlock: { $0.name },
                    nilOptionTitle: "None",
                    selectedRowColor: .green,
                    onSelection: { category in
                        selectedCategory = category
                    }
                )
                .frame(height: 300)
            }
            .padding()
        }
    }
}

#Preview {
    if #available(iOS 15.0, *) {
        Preview()
    }
}

