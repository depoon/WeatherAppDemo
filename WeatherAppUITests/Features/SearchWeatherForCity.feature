Feature: As a user I can search for weather of cities

    Scenario: User can search for city
        Given I am at Weather Search Form Page
        When I enter city search for "Singapore"

        Then I should be at Weather Details Page
        And I wait to see "Singapore, Singapore"
