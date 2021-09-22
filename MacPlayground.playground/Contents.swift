import Cocoa

var greeting = "Hello, playground"

/// get Type for anything in Swift
enum Kind {
    
    case `struct`
    case `enum`
    case `optional`
    case foreignClass
    case opaque
    case tuple
    case function
    case existential
    case metatype
    case objCClassWrapper
    case existentialMetatype
    case heapLocalVariable
    case heapGenericLocalVariable
    case errorObject
    case heapArray
    case `class`
    
    // MARK: - Some flags
    /// Non-type metadata kinds have this bit set
    private static let nonType: UInt = 0x400
    /// Non-heap metadata kinds have this bit set
    private static let nonHeap: UInt = 0x200
    /*k
    The above two flags are negative because the "class" kind has to be zero, a
    */
    /// Runtime-private metadata has this bit set. The compiler must not statically generate metadata objects binary layout of their associated data structures
    private static let runtimePrivate: UInt = 0x100
    private static let runtimePrivate_nonHeap = runtimePrivate | nonHeap
    private static let runtimePrivate_nonType = runtimePrivate | nonType
    // MARK: - initialization
    /// KAny.Typext BsMetadataKind 1
    
    init(_ type: Any.Type) {
        let kind = unsafeBitCast(type, to: UnsafePointer<UInt>.self).pointee
        
        switch kind {
        case 0 | Kind.nonHeap, 1: self = .struct
        case 1 | Kind.nonHeap, 2: self = .enum
        case 2 | Kind.nonHeap, 3: self = .optional
        case 3 | Kind.nonHeap: self = .foreignClass
        case 0 | Kind.runtimePrivate_nonHeap, 8: self = .opaque
        case 1 | Kind.runtimePrivate_nonHeap, 9: self = .tuple
        case 2 | Kind.runtimePrivate_nonHeap, 10: self = .function
        case 3 | Kind.runtimePrivate_nonHeap, 12: self = .existential
        case 4 | Kind.runtimePrivate_nonHeap, 13: self = .metatype
        case 5 | Kind.runtimePrivate_nonHeap, 14: self = .objCClassWrapper
        case 6 | Kind.runtimePrivate_nonHeap, 15: self = .existentialMetatype
        case 0 | Kind.nonType, 64: self = .heapLocalVariable
        case 0 | Kind.runtimePrivate_nonType: self = .heapGenericLocalVariable
        case 1 | Kind.runtimePrivate_nonType: self = .errorObject
        case 65: self = .heapArray
        case 0: fallthrough
        default: self = .class
        }
    }
}

let k = Kind(type(of: greeting))
print(k)


func someFunction(i: Int) { print(i) }
let f = someFunction

print(Kind(type(of: f)))

print(Kind(type(of: NSObject())))

class MyObject { }

print(Kind(type(of: MyObject())))


print(type(of: greeting))
print(type(of: f))
print(type(of: NSObject()))
print(type(of: MyObject()))

print(type(of: greeting) == String.self)
print(Kind(String.self))

// print(Kind((greeting.self).self))


class Person: NSObject {
    class func eat() {
        print(self == Person.self)
    }
}

class Student: Person {
    class func cut() {
        print(self == Person.self)
    }
}

Person.eat()
Student.cut()
