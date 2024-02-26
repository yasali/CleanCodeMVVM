import Swinject

public final class DIManager {
    public static let shared = DIManager()
    private let assembler = Assembler(container: Container(defaultObjectScope: .transient))
    
    private var synchronizedResolver: Resolver {
        if let container = assembler.resolver as? Container {
            return container.synchronize()
        } else {
            assertionFailure("Couldn't get Container from Assembler.")
            return assembler.resolver
        }
    }

    func register(_ assembly: Assembly) {
        assembler.apply(assembly: assembly)
    }

    public func getObject<T>(type: T.Type) -> T? {
        return synchronizedResolver.resolve(type)
    }

    public func getObject<T, Arguments>(type: T.Type, argument: Arguments) -> T? {
        return synchronizedResolver.resolve(type, argument: argument)
    }
}
