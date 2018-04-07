import Foundation

protocol ItemCellModelInfoConvertible {
    func toItemFeedModelInfo() -> ItemOfInterestTableViewCell.ModelInfo
}

extension Event: ItemCellModelInfoConvertible {
    func toItemFeedModelInfo() -> ItemOfInterestTableViewCell.ModelInfo {
        return ItemOfInterestTableViewCell.ModelInfo(
            title: self.name,
            dateRange: (self.startTime, self.endTime),
            description: self.description,
            locationSpec: ItemOfInterestTableViewCell.LocationLineViewSpec(locationName: self.location.name,
                                                                           distanceString: "x mi away") ,
            tags: self.tags.map { $0.label },
            imageUrl: URL(string: "https://picsum.photos/150/150/?random")!,
            layout: .event
        )
    }
}

extension Building: ItemCellModelInfoConvertible {
    func toItemFeedModelInfo() -> ItemOfInterestTableViewCell.ModelInfo {
        return ItemOfInterestTableViewCell.ModelInfo(
            title: self.name,
            dateRange: nil,
            description: self.department ?? "",
            locationSpec: nil,
            tags: ["tag1", "tag2"],
            imageUrl: URL(string: "https://picsum.photos/150/150/?random")!,
            layout: .place
        )
    }
}

//TODO fix these names
struct ItemFeedItemSectionSpec {
    var headerInfo: (title: String, subtitle: String)?
    var items: [ItemCellModelInfoConvertible]
    var layout: ItemOfInterestTableViewCell.Layout
}

enum ItemFeedSectionSpec {
    case items(
        headerInfo: (title: String, subtitle: String)?,
        items: [ItemCellModelInfoConvertible]
    )
    case map
}

struct ItemFeedSpec {
    var sections: [ItemFeedSectionSpec]
    
    static let testItemFeedSpec = ItemFeedSpec(sections: [
        .map,
        .items(
            headerInfo: (title: "Explore", subtitle: "EVENTS"),
            items: testEvents
        ),
        .items(
            headerInfo: (title: "Discover", subtitle: "ATTRACTIONS"),
            items: testPlaces
        ),
        ])
}
