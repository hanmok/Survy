import UIKit


struct Place: Decodable {
    var name: String
    var latitude: Double
    var longitude: Double
    var visited: Bool
}

struct PlacesResponse: Decodable {
    var places: [Place]
}

let json = """
{
    "places": [
        {
            "name": "Costa Rica"
            "latitude": 23.12,
            "longitude: 45.12
        },
        {
            "name": "Puerto Rico",
            "latitude": 23,
            "longitude": 45
        }
    ]
}
""".data(using: .utf8)!

// 1 [Place]?
let placesDic = try! JSONDecoder().decode([String: [Place]].self, from: json)
let places = placesDic["places"]

// 2 PlaceResponse
let placesResponse = try! JSONDecoder().decode(PlacesResponse.self, from: json)

