//
//  CoreDataManager.swift
//  DailyCatalystWidgetExtension
//
//  Created by Asir Bygud on 11/12/23.
//

import Foundation
import WidgetKit
import CoreData

class CoreDataManager {
    var catalystArray = [Catalyst]()
    let dataController: DataController

    private var observers = [NSObjectProtocol]()

    init(_ dataController: DataController) {
        self.dataController = dataController
        fetchCatalysts()

        /// Add Observer to observe CoreData changes and reload data
        observers.append(
            NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: nil, queue: .main) { _ in //swiftlint:disable:this line_length discarded_notification_center_observer
                self.fetchCatalysts()
            }
        )
    }

    deinit {
        /// Remove Observer when CoreDataManager is de-initialized
        observers.forEach(NotificationCenter.default.removeObserver)
    }

    /// Fetches all Vehicles from CoreData
    func fetchCatalysts() {
        defer {
            WidgetCenter.shared.reloadAllTimelines()
        }

        dataController.container.viewContext.refreshAllObjects()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Catalyst")

        do {
            guard let catalystArray = try dataController.container.viewContext.fetch(fetchRequest) as? [Catalyst] else {
                return
            }
            self.catalystArray = catalystArray
        } catch {
            print("Failed to fetch: \(error)")
        }
    }
}
