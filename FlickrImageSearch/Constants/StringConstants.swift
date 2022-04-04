//
//  StringConstants.swift
//  StringConstants
//
//  Created by Virendra Ravalji on 04/04/22.
//

import Foundation

func localizedString(forKey key: String) -> String {
    var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)

    if result == key {
        result = Bundle.main.localizedString(forKey: key, value: nil, table: "Default")
    }

    return result
}

struct StringConstants {
    static let noNetworkError = "no_network_error"
    static let networkError = "network_error"
    static let noDataError = "no_data_error"
    static let errorTitle = "error_title"
    static let alertOkayAction = "alert_okay_action"
    static let emptySearchError = "empty_search_error"
    static let unableToFetchImage = "unable_to_fetch_image"
}
