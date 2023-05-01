/*
[Reference: Open-Closed Principle in Swift](https://medium.com/movile-tech/open-closed-principle-in-swift-6d666270953d)
OCP의 핵심은 확장에는 열려있고, 변경에는 닫혀있도록 하는 것이다.
OCP는 추상화를 통해서 적용해볼 수 있다.
*/

class Person {
  private let name: String
  private let age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }
}

class House {
  private var residents: [Person]

  init(residents: [Person]) {
    self.residents = residents
  }
  
  func add(_ resident: Person) {
    residents.append(resident)
  }
}

// 위의 예시는 새로운 유형의 거주자를 추가하고자 할 때 House 클래스에 변경이 일어나게 된다.
// Person 클래스 자체를 변경할 수도 있지만 여러 곳에서 사용하고 있다면 SideEffect가 발생할 수 있다.

// protocol을 만들어서 의존 관계의 방향을 바꾸어 위 문제를 해결할 수 있다.

protocol Resident {}

class Person: Resident {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// Person의 동작을 확장하기 위해 새로운 타입을 만든다고 하더라도 프로토콜만 일치시킨다면 수정 없이 확장을 할 수 있게 된다.
struct NewPerson: Resident {
    let name: String
    let age: Int

    func complexMethod() {
        // Process something
    }

    func otherMethod() {
        // Process something
    }
}

class House {
  var resident: [Resident]

  init(residents: [Resident]) {
    self.resident = resident
  }

  func add(_ resident: Resident) {
    residents.append(resident)
  }
}