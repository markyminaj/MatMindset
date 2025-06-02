//
//  PhotoStorageManager.swift
//  MatMindset
//
//  Created by Mark Martin on 6/1/25.
//

import UIKit

struct PhotoStorageManager {
    static func savePhoto(_ image: UIImage, id: UUID) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }

        let filename = "\(id.uuidString).jpg"
        let url = getDocumentsDirectory().appendingPathComponent(filename)

        do {
            try data.write(to: url)
            return filename
        } catch {
            print("❌ Error saving photo: \(error)")
            return nil
        }
    }

    static func loadPhoto(named filename: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }

    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
