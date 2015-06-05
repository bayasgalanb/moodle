@core @core_grades
Feature: We can choose what min or max grade to use when aggregating grades.
  In order to what min or max grade to use
  As an teacher
  I can update modify a course setting

  Scenario: Changing the min or max grade to use updates the grades accordingly
    Given the following "courses" exist:
      | fullname | shortname | category | groupmode |
      | C1 | C1 | 0 | 1 |
    And the following "users" exist:
      | username | firstname | lastname | email | idnumber |
      | teacher1 | Teacher | 1 | teacher1@example.com | t1 |
      | student1 | Student | 1 | student1@example.com | s1 |
      | student2 | Student | 2 | student2@example.com | s2 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
      | student2 | C1 | student |
    And the following "grade categories" exist:
      | fullname | course |
      | CAT1 | C1 |
    And I log in as "admin"
    And I set the following administration settings values:
      | grade_aggregations_visible | Mean of grades,Weighted mean of grades,Simple weighted mean of grades,Mean of grades (with extra credits),Median of grades,Lowest grade,Highest grade,Mode of grades,Natural |
      | grade_minmaxtouse | Grade item min and max |
    And I am on site homepage
    And I follow "C1"
    And I navigate to "Grades" node in "Course administration"
    And I navigate to "Categories and items" node in "Grade administration > Setup"
    And I press "Add grade item"
    And I set the following fields to these values:
      | Item name | MI 1 |
      | Grade category | C1 |
    And I press "Save changes"
    And I press "Add grade item"
    And I set the following fields to these values:
      | Item name | MI 2 |
      | Grade category | C1 |
    And I press "Save changes"
    And I press "Add grade item"
    And I set the following fields to these values:
      | Item name | MI 3 |
      | Grade category | CAT1 |
    And I press "Save changes"
    And I press "Add grade item"
    And I set the following fields to these values:
      | Item name | MI 4 |
      | Grade category | CAT1 |
    And I press "Save changes"
    And I navigate to "Course grade settings" node in "Grade administration > Setup"
    And I set the field "Show weightings" to "Show"
    And I set the field "Show contribution to course total" to "Show"
    And I press "Save changes"
    And I navigate to "Categories and items" node in "Grade administration > Setup"
    And I set the following settings for grade item "CAT1":
      | Aggregation          | Natural |
    And I log out
    And I log in as "teacher1"
    And I follow "C1"
    And I navigate to "Grades" node in "Course administration"
    And I turn editing mode on
    And I give the grade "75.00" to the user "Student 1" for the grade item "MI 1"
    And I give the grade "25.00" to the user "Student 1" for the grade item "MI 2"
    And I give the grade "50.00" to the user "Student 1" for the grade item "MI 3"
    And I give the grade "100.00" to the user "Student 1" for the grade item "MI 4"
    And I give the grade "10.00" to the user "Student 2" for the grade item "MI 1"
    And I give the grade "20.00" to the user "Student 2" for the grade item "MI 3"
    And I press "Save changes"
    And I follow "User report"
    And I select "Student 1" from the "Select all or one user" singleselect
    And the following should exist in the "user-grade" table:
      | Grade item | Calculated weight | Grade  | Range | Percentage | Contribution to course total |
      | MI 1       | 25.00 %           | 75.00  | 0–100 | 75.00 %    | 18.75 %                      |
      | MI 2       | 25.00 %           | 25.00  | 0–100 | 25.00 %    | 6.25 %                       |
      | MI 3       | 50.00 %           | 50.00  | 0–100 | 50.00 %    | 12.50 %                      |
      | MI 4       | 50.00 %           | 100.00 | 0–100 | 100.00 %   | 25.00 %                      |
      | CAT1 total | 50.00 %           | 150.00 | 0–200 | 75.00 %    | -                            |
      | C1 total   | -                 | 250.00 | 0–400 | 63.50 %    | -                            |
    And I select "Student 2" from the "Select all or one user" singleselect
    And the following should exist in the "user-grade" table:
      | Grade item | Calculated weight | Grade  | Range | Percentage | Contribution to course total |
      | MI 1       | 50.00 %           | 20.00  | 0–100 | 20.00 %    | 10.00 %                      |
      | MI 2       | 0.00 % ( Empty )  | -      | 0–100 | -          | 0.00 %                       |
      | MI 3       | 100.00 %          | 10.00  | 0–100 | 10.00 %    | 5.00 %                       |
      | MI 4       | 0.00 % ( Empty )  | -      | 0–100 | -          | 0.00 %                       |
      | CAT1 total | 50.00 %           | 10.00  | 0–100 | 10.00 %    | -                            |
      | C1 total   | -                 | 30.00  | 2–400 | 15.00 %    | -                            |
