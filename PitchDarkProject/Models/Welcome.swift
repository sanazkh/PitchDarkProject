//
//  Welcome.swift
//  PitchDarkProject
//
//  Created by Sanaz Khosravi on 11/9/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import Foundation

struct Welcome: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Clouds
    let id: Int
    let name: String
    let cod: Int
}

struct Clouds: Codable {
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}
