//
//  MemorySetController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/14/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

class MemorySetController {
    
    static let shared = MemorySetController()
    private init() {
        load()
    }
    var allMemorySets = [MemorySet]()
    
    // MARK: - CRUD
    func createNewSet(verseInts: [Int], verseReferences: [String], verseTexts: [String]) {
        
        let newSet = MemorySet(verseInts: verseInts, verseReferences: verseReferences, verseTexts: verseTexts)
        allMemorySets.append(newSet)
        save()
    }
    
    func toggleMemorySetStatus(memorySet: MemorySet) {
        
        memorySet.isMemorized.toggle()
        save()
    }
    
    func deleteSet(memorySet: MemorySet) {
        
        guard let dyingSet = allMemorySets.firstIndex(of: memorySet) else { print("Memory Set NOT DELETED, NOT FOUND"); return }
        allMemorySets.remove(at: dyingSet)
        save()
    }
    
    // MARK: - PERSISTENCE
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "memorysets.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    fileprivate func save() {
        
        do {
            let saveData = try JSONEncoder().encode(allMemorySets)
            try saveData.write(to: fileURL())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func load() {
        
        do {
            let loadData = try Data(contentsOf: fileURL())
            let allLoadedSets = try JSONDecoder().decode([MemorySet].self, from: loadData)
            self.allMemorySets = allLoadedSets
        } catch {
            print(error.localizedDescription)
        }
    }
}
