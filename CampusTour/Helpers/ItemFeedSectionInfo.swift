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
            locationSpec: ItemOfInterestTableViewCell.LocationLineViewSpec(locationName: "todo, add location name",
                                                                           distanceString: "x mi away") ,
            tags: ["tag1", "tag2"], //TODO add tags to data
            imageUrl: URL(string: "https://picsum.photos/150/150/?random")!
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
            imageUrl: URL(string: "https://picsum.photos/150/150/?random")!
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
        items: [ItemCellModelInfoConvertible],
        layout: ItemOfInterestTableViewCell.Layout
    )
    case map
}

struct ItemFeedSpec {
    var sections: [ItemFeedSectionSpec]
}
