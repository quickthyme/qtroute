
import XCTest

class ToDoDetailViewControllerTests: XCTestCase {

    var subject: ToDoDetailViewController!
    var mockRouteDriver: MockRouteDriver!

    override func setUp() {
        mockRouteDriver = MockRouteDriver()
        subject = (StoryboardLoader.loadViewController(from: "ToDoDetail") as! ToDoDetailViewController)
        subject.routeDriver = mockRouteDriver
    }

    func test_configuration_and_events() {
        given("it has route input with 'toDoId' set") {
            subject.routeInput = ["toDoId":88]

            given_view_controller_has_been_presented(subject) {

                with("routeResolver") {
                    XCTAssert(subject.routeResolver is ToDoDetailRouteResolver)
                    XCTAssertEqual(subject.routeResolver?.route.id, AppRoute.id.ToDoDetail)
                }
                with("title incudes the route input toDoId") {
                    XCTAssertEqual(subject.navigationItem.title, "Item 88")
                }

                when("contactUsNear action") {
                    mockRouteDriver.reset()
                    subject.contactUsNearAction(nil)
                    then("it should drive (sub) to Contact Us") {
                        XCTAssertEqual(mockRouteDriver.timesCalled_driveSub, 1)
                        XCTAssertEqual(mockRouteDriver.valueFor_driveSub_targetId, AppRoute.id.ContactUs)
                    }
                }

                when("contactUsFar action") {
                    mockRouteDriver.reset()
                    subject.contactUsFarAction(nil)
                    then("it should drive all the way to Contact Us") {
                        XCTAssertEqual(mockRouteDriver.timesCalled_driveTo, 1)
                        XCTAssertEqual(mockRouteDriver.valueFor_driveTo_targetId, AppRoute.id.ContactUs)
                    }
                }
            }
        }
    }
}