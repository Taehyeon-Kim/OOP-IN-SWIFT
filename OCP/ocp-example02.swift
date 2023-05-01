/*
[enum 사용에서의 예제]
무조건적으로 나쁜 코드는 없다. enum의 사용도 마찬가지이다. 분명히 적재적소에 사용한다면 enum은 좋은 수단이 되겠지만, 그러지 못한 상황도 존재한다.

대부분 enum을 사용하는 경우에 OCP를 깨트리는 경우가 많다. 다시 말해서 프로젝트 전반적으로 enum과 관련된 코드가 있고, switch-case 또는 if-else context가 존재할 때 문제를 야기한다. 새로운 case를 추가했을 때 모든 곳에서 변경이 일어나야하고, 변경하는 것을 잊어버렸을 때 위험할 수 있다.

새로운 case가 추가되거나 삭제되는 경우가 많다고 한다면 최대한 switch-case를 피하는 방향으로 코드를 만들어보면 좋을 것 같다.
*/

enum DeeplinkType {
    case home
    case profile
    case settings // Modification
}

protocol Deeplink {
    var type: DeeplinkType { get }
}

class HomeDeeplink: Deeplink {
    let type: DeeplinkType = .home

    func executeHome() {
        // Presents the main screen
    }
}

class ProfileDeeplink: Deeplink {
    let type: DeeplinkType = .profile

    func executeProfile() {
        // Presents the profile screen
    }
}

class SettingsDeeplink: Deeplink {
    let type: DeeplinkType = .settings

    func executeSettings() {
        // Presents the Settings Screen
    }
}

class Router {
    func execute(_ deeplink: Deeplink) {
        switch deeplink.type {
        case .home:
            (deeplink as? HomeDeeplink)?.executeHome()
        case .profile:
            (deeplink as? ProfileDeeplink)?.executeProfile()
	      // Other Modification
        case .settings:
            (deeplink as? SettingsDeeplink)?.executeSettings()
        }
    }
}

// 위의 코드는 기존에 home, profile case가 존재하는 상황에서 새롭게 settings라는 case를 추가하는 것을 코드로 표현한 것이다.
// 새롭게 case를 추가하는 것은 좋은데 Router 클래스의 switch-case에서 불필요한 수정이 일어나게 된다.
// 이는 OCP를 위반하게 된다. (딥링크 동작을 확장하기 위해서 라우터의 execute 메소드를 수정해야 하기 때문이다.)

// 아래는 OCP를 지키는 코드이다.
// 열거형을 제거하고 Protocol에 execute메소드를 정의함으로써 코드를 개선하고 있다.
// 새로운 Deeplink 유형을 추가하려는 경우에 새 클래스만 생성하면 된다.
// Router 클래스를 변경할 필요가 없게 된다.
protocol Deeplink {
    func execute()
}

class HomeDeeplink: Deeplink {
    func execute() {
        // Presents the main screen
    }
}

class ProfileDeeplink: Deeplink {
    func execute() {
        // Presents the Profile screen
    }
}

class Router {
    func execute(_ deeplink: Deeplink) {
        deeplink.execute()
    }
}

// 코드를 100% closed(폐쇄)하는 것은 불가능하거나 어려울 수 있다.
// 프로젝트를 진행하다보면 어쩔 수 없이 코드 조각을 변경해야하는 경우가 생길 수 있다.
// 가장 좋은 방법은 주요 기능에 대해 코드를 폐쇄하도록 노력하는 것이다.