import CoreData

protocol DataManagerProtocol {
    func saveSections(sections: [Section])
    func fetchSections() -> [Section]?
    func saveSectionDetails(sectionDetails: SectionDetails)
    func fetchSectionDetails(id: String) -> SectionDetails?
}

class DataManager: DataManagerProtocol {
    static let shared = DataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CleanCodeMVVMModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
        return container
    }()

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Methods for saving and fetching Section

    func saveSections(sections: [Section]) {
        let context = persistentContainer.viewContext
        for section in sections {
            let sectionEntity = SectionEntity(context: context)
            sectionEntity.id = section.id
            sectionEntity.title = section.title
            sectionEntity.href = section.href
            sectionEntity.type = section.type
            sectionEntity.sectionSort = Int16(section.sectionSort)
            sectionEntity.name = section.name
        }
        saveContext()
    }

    func fetchSections() -> [Section]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SectionEntity> = SectionEntity.fetchRequest()
        do {
            let sectionsEntities = try context.fetch(fetchRequest)
            let sections = sectionsEntities.map { Section(id: $0.id ?? "",
                                                          title: $0.title ?? "",
                                                          href: $0.href ?? "",
                                                          type: $0.type ?? "",
                                                          sectionSort: Int($0.sectionSort),
                                                          name: $0.name ?? "")
            }
            return sections
        } catch {
            print("Error fetching sections: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Methods for saving and fetching SectionDetails

    func saveSectionDetails(sectionDetails: SectionDetails) {
        let context = persistentContainer.viewContext
        let sectionDetailsEntity = SectionDetailsEntity(context: context)
        sectionDetailsEntity.id = sectionDetails.id
        sectionDetailsEntity.title = sectionDetails.title
        sectionDetailsEntity.descriptionText = sectionDetails.description
        saveContext()
    }

    func fetchSectionDetails(id: String) -> SectionDetails? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SectionDetailsEntity> = SectionDetailsEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let sectionDetailsEntities = try context.fetch(fetchRequest)
            if let sectionDetailsEntity = sectionDetailsEntities.first {
                return SectionDetails(id: sectionDetailsEntity.id ?? "",
                                      title: sectionDetailsEntity.title ?? "",
                                      description: sectionDetailsEntity.description )
            }
            return nil
        } catch {
            print("Error fetching section details: \(error.localizedDescription)")
            return nil
        }
    }
}
