import Foundation

public protocol VMTypeID: Hashable {
    var rawValue: String { get }
}

// Box TypeID into AnyTypeID to be able to use it as a dictionary key

private class _AnyTypeIDBase: VMTypeID {
    init() {
        guard type(of: self) != _AnyTypeIDBase.self else {
            fatalError("_AnyTypeIDBase instances can not be created; create a subclass instance instead")
        }
    }

    var rawValue: String { fatalError("Must override") }

    var hashValue: Int { fatalError("Must override") }

    static func == (lhs: _AnyTypeIDBase, rhs: _AnyTypeIDBase) -> Bool {
        fatalError("Must override")
    }
}

private final class _AnyTypeIDBox<Concrete: VMTypeID>: _AnyTypeIDBase {
    var concrete: Concrete

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override var rawValue: String {
        return concrete.rawValue
    }

    override var hashValue: Int {
        return concrete.hashValue
    }
}

public final class AnyTypeID: VMTypeID {
    private let box: _AnyTypeIDBase

    public init<Concrete: VMTypeID>(_ concrete: Concrete) {
        box = _AnyTypeIDBox(concrete)
    }

    public var rawValue: String {
        return box.rawValue
    }

    public var hashValue: Int {
        return box.hashValue
    }

    public static func == (lhs: AnyTypeID, rhs: AnyTypeID) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
