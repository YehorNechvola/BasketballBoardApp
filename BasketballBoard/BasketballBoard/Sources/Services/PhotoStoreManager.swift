//
//  PhotoStoreManager.swift
//  BasketballBoard
//
//  Created by Rush_user on 26.02.2026.
//

import UIKit

final class DataWrapper {
    let data: Data
    
    init(data: Data) {
        self.data = data
    }
}

actor PhotoStoreManager {
    
    static let shared = PhotoStoreManager()
    private let fileManager = FileManager.default
    private let cache = NSCache<NSString, DataWrapper>()
    
    private init() {
        cache.countLimit = 100
    }
    
    // MARK: - Public
    
    func saveImage(_ imageData: Data, for id: String) throws {
        let url = try fileURL(for: id)
        try imageData.write(to: url, options: .atomic)
        let cacheData = DataWrapper(data: imageData)
        cache.setObject(cacheData, forKey: id as NSString)
    }
    
    func loadImage(for id: String) -> Data? {
        if let cached = cache.object(forKey: id as NSString) {
            return cached.data
        }
        
        do {
            let url = try fileURL(for: id)
            let data = try Data(contentsOf: url)
            let cacheData = DataWrapper(data: data)
            cache.setObject(cacheData, forKey: id as NSString)
            
            return data
        } catch {
            return nil
        }
    }
    
    func deleteImage(for id: String) throws {
        let url = try fileURL(for: id)
        
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
        
        cache.removeObject(forKey: id as NSString)
    }
}

// MARK: - Private

private extension PhotoStoreManager {
    
    func fileURL(for id: String) throws -> URL {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appending(path: "photo_\(id).jpg")
    }
}

// MARK: - Error

enum ImageError: Error {
    case failedToConvert
}
