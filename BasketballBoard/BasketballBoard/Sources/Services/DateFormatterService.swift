//
//  DateFormatterService.swift
//  BasketballBoard
//
//  Created by Eva on 16.08.2024.
//

import Foundation

final class DateFormatterService {
    
    enum CountryRegion: String {
        // North America
        case unitedStates = "US"
        case canada = "CA"
        case mexico = "MX"
        
        // Europe
        case france = "FR"
        case germany = "DE"
        case italy = "IT"
        case spain = "ES"
        case unitedKingdom = "UK"
        case netherlands = "NL"
        case belgium = "BE"
        case switzerland = "CH"
        case sweden = "SE"
        case norway = "NO"
        case finland = "FI"
        case denmark = "DK"
        case poland = "PL"
        case austria = "AT"
        case portugal = "PT"
        case greece = "GR"
        case ireland = "IE"
        case czechRepublic = "CZ"
        case hungary = "HU"
        case slovakia = "SK"
        case slovenia = "SI"
        case croatia = "HR"
        case romania = "RO"
        case bulgaria = "BG"
        case estonia = "EE"
        case lithuania = "LT"
        case latvia = "LV"
        case ukraine = "UA"
        
        // Asia
        case china = "CN"
        case japan = "JP"
        case southKorea = "KR"
        case india = "IN"
        case singapore = "SG"
        case malaysia = "MY"
        case thailand = "TH"
        case vietnam = "VN"
        case philippines = "PH"
        case indonesia = "ID"
        case hongKong = "HK"
        case taiwan = "TW"
        
        // Middle East
        case saudiArabia = "SA"
        case unitedArabEmirates = "AE"
        case israel = "IL"
        case iran = "IR"
        case turkey = "TR"
        
        func dateFormat() -> String {
            switch self {
            case .unitedStates, .canada, .mexico:
                return "MM.dd.yyyy"
            case .france, .germany, .italy, .spain, .unitedKingdom, .netherlands, .belgium, .switzerland, .sweden, .norway, .finland, .denmark, .poland, .austria, .portugal, .greece, .ireland, .czechRepublic, .hungary, .slovakia, .slovenia, .croatia, .romania, .bulgaria, .estonia, .lithuania, .latvia, .ukraine:
                return "dd.MM.yyyy"
            case .china, .japan, .southKorea, .india, .singapore, .malaysia, .thailand, .vietnam, .philippines, .indonesia, .hongKong, .taiwan:
                return "yyyy.MM.dd"
            case .saudiArabia, .unitedArabEmirates, .israel, .iran, .turkey:
                return "dd.MM.yyyy"
            }
        }
    }
    
    static let shared = DateFormatterService()
    
    private init() {}
    
    // Function to format the current date based on region
    func formatDate(for date: Date = Date()) -> String {
        let currentRegion = CountryRegion(rawValue: Locale.current.region?.identifier ?? "US")
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = currentRegion?.dateFormat()
        
        return dateFormatter.string(from: date)
    }
    
    // Function to format a date using a custom format
    func formatDate(for date: Date = Date(), with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
