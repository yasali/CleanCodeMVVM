import Swinject

final class CleanCodeMVVMAssembly: Assembly {
    func assemble(container: Container) {
        container.registerRouters()
        container.registerRepositories()
        container.registerManagers()
        container.registerFactories()
    }
}

extension Container {
    func registerRouters() {
        register(HomeRouterProtocol.self) { _ in
            HomeRouter()
        }

        register(HomeDetailsRouterProtocol.self) { (resolver, section: HomeSection) in
            HomeDetailsRouter(section: section)
        }
    }

    func registerRepositories() {
        register(CleanCodeMVVMContentRepositoryProtocol.self) { _ in
            CleanCodeMVVMContentRepository()
        }
    }

    func registerManagers() {
        register(DataManagerProtocol.self) { _ in
            DataManager.shared
        }
    }

    func registerFactories() {
        register(ViewControllerFactoryProtocol.self) { _ in
            // MARK: Comment/Uncomment to change implementation
            UIKitViewControllerFactory()
            //SwiftUIViewControllerFactory()
        }
    }
}
