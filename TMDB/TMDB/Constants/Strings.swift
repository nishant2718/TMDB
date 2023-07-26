//
//  Strings.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

/// The format of this file is as follows:
/// - Each screen or view will have its own string extension
/// - Each extension will contain just the strings related to one screen or view
/// - Each struct will contain strings grouped for a screen or view. This grouping is left to the developer to do as they find reasonable.
///
/// Having it structured this way conveys the context strings are used in.
///
/// Every string MUST:
/// - Have a key that's unique. To help with uniqueness, give the key the value of the structs you've drilled down into, and end with the variable name.
/// - The tableName should be the screen or view.
/// - Value is the value of the string you want users to see.
/// - Leave a comment that will help translators understand the context of the string. Use complete sentences.

import Foundation

// MARK: - Movie List screen
extension String {
    public struct MovieList {
        public static let Title = NSLocalizedString("MovieList.Title",
                                                    tableName: "MovieList",
                                                    value: "Movie Search",
                                                    comment: "This is the title of the movie search screen. This title is displayed at the top, indicating to the user which screen they are on.")
        public static let NoResults = NSLocalizedString("MovieList.NoResults",
                                                        tableName: "MovieList",
                                                        value: "No results",
                                                        comment: "This label shows on the movie search page when a user searches for something that has no results.")
    }
}
