import Foundation

protocol ItemCellModelInfoConvertible {
    func toItemFeedModelInfo(index: Int?) -> ItemOfInterestTableViewCell.ModelInfo
}

extension Event: ItemCellModelInfoConvertible {
    func toItemFeedModelInfo(index: Int? = nil) -> ItemOfInterestTableViewCell.ModelInfo {
        
        return ItemOfInterestTableViewCell.ModelInfo(
            index: index,
            title: self.name,
            dateRange: (self.startTime, self.endTime),
            description: self.description,
            locationSpec: ItemOfInterestTableViewCell.LocationLineViewSpec(locationName: self.location.name,
                                                                           distanceString: "x mi away") ,
            tags: self.parseTag(),
            imageUrl: URL(string: (self.location.imageUrl != "") ? self.location.imageUrl : defaultLocationImageUrl)!,
            layout: .event
        )
    }
}

extension Building: ItemCellModelInfoConvertible {
    func toItemFeedModelInfo(index: Int? = nil) -> ItemOfInterestTableViewCell.ModelInfo {
        return ItemOfInterestTableViewCell.ModelInfo(
            index: index,
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
    
    static func getMapEventsDataSpec() -> ItemFeedSpec {
        return ItemFeedSpec(sections: [
            .map,
            .items(
                headerInfo: (title: "Explore", subtitle: "EVENTS"),
                items: DataManager.sharedInstance.events
            ),
        ])
    }
    
    static func getEventsDataSpec() -> ItemFeedSpec {
        return ItemFeedSpec(sections: [
            .items(
                headerInfo: (title: "Explore", subtitle: "EVENTS"),
                items: DataManager.sharedInstance.events
            ),
        ])
    }
    
    static func getTaggedDataSpec(events: [Event]) -> ItemFeedSpec {
        return ItemFeedSpec(sections: [
            .map,
            .items(
                headerInfo: (title: "Explore", subtitle: "EVENTS"),
                items: events
            ),
        ])
    }
}
