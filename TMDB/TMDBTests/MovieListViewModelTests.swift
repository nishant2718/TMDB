//
//  MovieListViewModelTests.swift
//  TMDBTests
//
//  Created by Nishant Patel on 7/26/23.
//

import Foundation
import XCTest

@testable import TMDB

class MovieListViewModelTests: XCTestCase {
    var subject: MovieListViewModel!
    
    override func setUp() {
        super.setUp()
        
        subject = MovieListViewModel(with: MockDependencyContainer())
    }
    
    override func tearDown() {
        super.tearDown()
        
        subject = nil
    }
    
    func testShouldUpdateWithNewKeywordSearched() async {
        await subject.fetchMoviesWith("test")
        
        XCTAssert(subject.shouldUpdate)
    }
    
    func testShouldIncrementPageCountBeforeSearching() async {
        subject.keyword = "test"
        
        await subject.fetchMovies()
        
        XCTAssertEqual(subject.page, 2)
    }
    
    func testShouldResetPageCountOnNewKeyword() async {
        subject.keyword = "test"
        
        await subject.fetchMovies()
        XCTAssertEqual(subject.page, 2)
        
        await subject.fetchMoviesWith("hello")
        XCTAssertEqual(subject.page, 1)
    }
    
    func testMoviesArrayIsIncremented() async {
        subject.keyword = "test"
        
        await subject.fetchMovies()
        XCTAssertEqual(subject.movies.count, 4)
        
        await subject.fetchMovies()
        XCTAssertEqual(subject.movies.count, 8)
    }
    
    func testMoviesArrayIsPurgedAndPopulatedWithNewSearchTerm() async {
        subject.keyword = "test"
        
        await subject.fetchMovies()
        XCTAssertEqual(subject.movies.count, 4)
        
        await subject.fetchMoviesWith("hello")
        XCTAssertEqual(subject.movies.count, 4)
    }
}
