Feature: conversation/breakout-rooms
  Background:
    Given user "participant1" exists
    Given user "participant2" exists
    Given user "participant3" exists
    Given user "participant4" exists
    Given group "group1" exists

  Scenario: Teacher creates manual breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" adds user "participant3" to room "class room" with 200 (v4)
    And user "participant1" adds user "participant4" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
      | users      | participant3 | 3               |
      | users      | participant4 | 3               |
    When user "participant1" creates 3 manual breakout rooms for "class room" with 200 (v1)
      | users::participant2 | 0 |
      | users::participant3 | 1 |
      | users::participant4 | 2 |
    Then user "participant1" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 2     |
      | 2    | Room 3     |
    Then user "participant2" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    Then user "participant3" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 2     |
    Then user "participant4" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 3     |
    And user "participant1" sees the following attendees in breakout rooms for room "class room" with 200 (v4)
      | roomToken  | actorType  | actorId      | participantType |
      | class room | users      | participant1 | 1               |
      | class room | users      | participant2 | 3               |
      | class room | users      | participant3 | 3               |
      | class room | users      | participant4 | 3               |
      | Room 1     | users      | participant1 | 1               |
      | Room 1     | users      | participant2 | 3               |
      | Room 2     | users      | participant1 | 1               |
      | Room 2     | users      | participant3 | 3               |
      | Room 3     | users      | participant1 | 1               |
      | Room 3     | users      | participant4 | 3               |
    And user "participant2" sees the following attendees in breakout rooms for room "class room" with 400 (v4)
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    And user "participant2" sees the following attendees in breakout rooms for room "class room" with 200 (v4)
      | roomToken  | actorType  | actorId      | participantType |
      | class room | users      | participant1 | 1               |
      | class room | users      | participant2 | 3               |
      | class room | users      | participant3 | 3               |
      | class room | users      | participant4 | 3               |
      | Room 1     | users      | participant1 | 1               |
      | Room 1     | users      | participant2 | 3               |

  Scenario: Teacher creates automatic breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" adds user "participant3" to room "class room" with 200 (v4)
    And user "participant1" adds user "participant4" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
      | users      | participant3 | 3               |
      | users      | participant4 | 3               |
    When user "participant1" creates 3 automatic breakout rooms for "class room" with 200 (v1)
    Then user "participant1" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 2     |
      | 2    | Room 3     |
    And user "participant1" sees the following attendees in room "Room 1" with 200 (v4)
      | actorType  | actorId           | participantType |
      | users      | participant1      | 1               |
      | users      | /^participant\d$/ | 3               |
    And user "participant1" sees the following attendees in room "Room 2" with 200 (v4)
      | actorType  | actorId           | participantType |
      | users      | participant1      | 1               |
      | users      | /^participant\d$/ | 3               |
    And user "participant1" sees the following attendees in room "Room 3" with 200 (v4)
      | actorType  | actorId           | participantType |
      | users      | participant1      | 1               |
      | users      | /^participant\d$/ | 3               |
    Then user "participant2" is participant of the following rooms (v4)
      | type | name        |
      | 2    | class room  |
      | 2    | /^Room \d$/ |
    Then user "participant3" is participant of the following rooms (v4)
      | type | name        |
      | 2    | class room  |
      | 2    | /^Room \d$/ |
    Then user "participant4" is participant of the following rooms (v4)
      | type | name        |
      | 2    | class room  |
      | 2    | /^Room \d$/ |

  Scenario: Co-teachers are promoted and removed in all breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant1" creates 3 manual breakout rooms for "class room" with 200 (v1)
      | users::participant2 | 0 |
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 2     |
      | 2    | Room 3     |
    And user "participant2" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    When user "participant1" promotes "participant2" in room "class room" with 200 (v4)
    Then user "participant2" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 2     |
      | 2    | Room 3     |
    And user "participant1" sees the following attendees in room "Room 1" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 2               |
    And user "participant1" sees the following attendees in room "Room 2" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 2               |
    And user "participant1" sees the following attendees in room "Room 3" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 2               |
    When user "participant1" demotes "participant2" in room "class room" with 200 (v4)
    Then user "participant2" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
    And user "participant1" sees the following attendees in room "Room 1" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
    And user "participant1" sees the following attendees in room "Room 2" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
    And user "participant1" sees the following attendees in room "Room 3" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |

  Scenario: Can not nest breakout rooms
    When user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" creates 3 manual breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 2     |
      | 2    | Room 3     |
    And user "participant1" creates 3 manual breakout rooms for "Room 1" with 400 (v1)

  Scenario: Can not create breakout rooms in one-to-one
    When user "participant1" creates room "one-to-one room" (v4)
      | roomType | 1 |
      | invite   | participant2 |
    And user "participant1" creates 3 manual breakout rooms for "one-to-one room" with 400 (v1)

  Scenario: Can not create more than 20 breakout rooms
    When user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" creates 21 manual breakout rooms for "class room" with 400 (v1)

  Scenario: Can not create less than 1 breakout rooms
    When user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" creates 0 manual breakout rooms for "class room" with 400 (v1)

  Scenario: Invalid breakout room number in attendee map (low)
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    When user "participant1" creates 3 manual breakout rooms for "class room" with 400 (v1)
      | users::participant2 | -1 |

  Scenario: Invalid breakout room number in attendee map (high)
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    When user "participant1" creates 3 manual breakout rooms for "class room" with 400 (v1)
      | users::participant2 | 4 |

  Scenario: Breakout rooms are disabled
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And the following "spreed" app config is set
      | breakout_rooms | no |
    When user "participant1" creates 3 manual breakout rooms for "class room" with 400 (v1)
      | users::participant2 | 1 |

  Scenario: Broadcast chat message to all breakout room
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
    When user "participant1" creates 3 manual breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 2     |
      | 2    | Room 3     |
    And user "participant1" broadcasts message "Hello rooms 1-3" to room "class room" with 201 (v1)
    Then user "participant1" sees the following messages in room "Room 1" with 200
      | room   | actorType | actorId      | actorDisplayName         | message         | messageParameters |
      | Room 1 | users     | participant1 | participant1-displayname | Hello rooms 1-3 | []                |
    Then user "participant1" sees the following messages in room "Room 2" with 200
      | room   | actorType | actorId      | actorDisplayName         | message         | messageParameters |
      | Room 2 | users     | participant1 | participant1-displayname | Hello rooms 1-3 | []                |
    Then user "participant1" sees the following messages in room "Room 3" with 200
      | room   | actorType | actorId      | actorDisplayName         | message         | messageParameters |
      | Room 3 | users     | participant1 | participant1-displayname | Hello rooms 1-3 | []                |

  Scenario: Can not broadcast chat message in a non-breakout room
    Given user "participant1" creates room "room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" broadcasts message "Does not work" to room "room" with 400 (v1)

  Scenario: Can not start in a non-breakout room
    Given user "participant1" creates room "room" (v4)
      | roomType | 2 |
      | roomName | room |
    And user "participant1" starts breakout rooms in room "room" with 400 (v1)
    And user "participant1" stops breakout rooms in room "room" with 400 (v1)

  Scenario: Moderator starts and stops breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
    When user "participant1" creates 3 manual breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 2                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
      | 2    | Room 3     | 1          | 0                | 0                  |
    Then user "participant1" sees the following system messages in room "Room 1" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 1 | users     | participant1 | participant1-displayname | conversation_created   |
    Then user "participant1" sees the following system messages in room "Room 2" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 2 | users     | participant1 | participant1-displayname | conversation_created   |
    Then user "participant1" sees the following system messages in room "Room 3" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 3 | users     | participant1 | participant1-displayname | conversation_created   |
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 2                | 1                  |
      | 2    | Room 1     | 0          | 0                | 0                  |
      | 2    | Room 2     | 0          | 0                | 0                  |
      | 2    | Room 3     | 0          | 0                | 0                  |
    Then user "participant1" sees the following system messages in room "Room 1" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 1 | users     | participant1 | participant1-displayname | breakout_rooms_started |
      | Room 1 | users     | participant1 | participant1-displayname | conversation_created   |
    Then user "participant1" sees the following system messages in room "Room 2" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 2 | users     | participant1 | participant1-displayname | breakout_rooms_started |
      | Room 2 | users     | participant1 | participant1-displayname | conversation_created   |
    Then user "participant1" sees the following system messages in room "Room 3" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 3 | users     | participant1 | participant1-displayname | breakout_rooms_started |
      | Room 3 | users     | participant1 | participant1-displayname | conversation_created   |
    And user "participant1" stops breakout rooms in room "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 2                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
      | 2    | Room 3     | 1          | 0                | 0                  |
    Then user "participant1" sees the following system messages in room "Room 1" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 1 | users     | participant1 | participant1-displayname | breakout_rooms_stopped |
      | Room 1 | users     | participant1 | participant1-displayname | breakout_rooms_started |
      | Room 1 | users     | participant1 | participant1-displayname | conversation_created   |
    Then user "participant1" sees the following system messages in room "Room 2" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 2 | users     | participant1 | participant1-displayname | breakout_rooms_stopped |
      | Room 2 | users     | participant1 | participant1-displayname | breakout_rooms_started |
      | Room 2 | users     | participant1 | participant1-displayname | conversation_created   |
    Then user "participant1" sees the following system messages in room "Room 3" with 200
      | room   | actorType | actorId      | actorDisplayName         | systemMessage          |
      | Room 3 | users     | participant1 | participant1-displayname | breakout_rooms_stopped |
      | Room 3 | users     | participant1 | participant1-displayname | breakout_rooms_started |
      | Room 3 | users     | participant1 | participant1-displayname | conversation_created   |

  Scenario: Request assistance and cancel it
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    When user "participant1" creates 1 automatic breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    And user "participant2" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 1                  |
      | 2    | Room 1     | 0          | 0                | 0                  |
    And user "participant2" requests assistance in room "Room 1" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 1                  |
      | 2    | Room 1     | 0          | 0                | 2                  |
    And user "participant2" cancels request for assistance in room "Room 1" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 1                  |
      | 2    | Room 1     | 0          | 0                | 0                  |
    And user "participant2" requests assistance in room "Room 1" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 1                  |
      | 2    | Room 1     | 0          | 0                | 2                  |
    And user "participant1" cancels request for assistance in room "Room 1" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 1                  |
      | 2    | Room 1     | 0          | 0                | 0                  |

  Scenario: Teacher creates free breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" creates 2 free breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 3                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    Then user "participant2" sees the following breakout rooms for room "class room" with 404 (v4)
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    Then user "participant2" sees the following breakout rooms for room "class room" with 400 (v4)
    Then user "participant1" sees the following breakout rooms for room "class room" with 200 (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    Then user "participant2" sees the following breakout rooms for room "class room" with 200 (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | Room 1     | 0          | 0                | 0                  |
      | 2    | Room 2     | 0          | 0                | 0                  |

  Scenario: Student can only get their own breakout room when non-free
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    When user "participant1" creates 3 manual breakout rooms for "class room" with 200 (v1)
      | users::participant2 | 0 |
    Then user "participant1" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 2     |
      | 2    | Room 3     |
    Then user "participant2" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    Then user "participant1" sees the following breakout rooms for room "class room" with 200 (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
      | 2    | Room 3     | 1          | 0                | 0                  |
    Then user "participant2" sees the following breakout rooms for room "class room" with 400 (v4)
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    Then user "participant2" sees the following breakout rooms for room "class room" with 200 (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | Room 1     | 0          | 0                | 0                  |

  Scenario: Teachers can not "switch" breakout rooms as they are in all of them
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" creates 2 free breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 3                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    When user "participant1" switches in room "class room" to breakout room "Room 1" with 400 (v1)

  Scenario: Student switching breakout room in free selection
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" creates 2 free breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 3                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    Then user "participant2" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
    When user "participant2" switches in room "class room" to breakout room "Room 1" with 400 (v1)
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    When user "participant2" switches in room "class room" to breakout room "Room 1" with 200 (v1)
    Then user "participant2" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    When user "participant2" switches in room "class room" to breakout room "Room 2" with 200 (v1)
    Then user "participant2" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 2     |

  Scenario: Student can not switch on manual breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant1" creates 2 manual breakout rooms for "class room" with 200 (v1)
      | users::participant2 | 0 |
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 2                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    Then user "participant2" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    When user "participant2" switches in room "class room" to breakout room "Room 1" with 400 (v1)

  Scenario: Student can not switch on automatic breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant1" creates 2 automatic breakout rooms for "class room" with 200 (v1)
      | users::participant2 | 0 |
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    Then user "participant2" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    When user "participant2" switches in room "class room" to breakout room "Room 1" with 400 (v1)

  Scenario: Deleting the parent also deletes all breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant1" creates 2 automatic breakout rooms for "class room" with 200 (v1)
      | users::participant2 | 0 |
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    And user "participant2" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    When user "participant1" deletes room "class room" with 200 (v4)
    And user "participant1" is participant of the following rooms (v4)
    And user "participant2" is participant of the following rooms (v4)

  Scenario: Deleting a single breakout room unassigned the students from the mapping
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" adds user "participant3" to room "class room" with 200 (v4)
    And user "participant1" adds user "participant4" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
      | users      | participant3 | 3               |
      | users      | participant4 | 3               |
    And user "participant1" creates 3 manual breakout rooms for "class room" with 200 (v1)
      | users::participant2 | 0 |
      | users::participant3 | 1 |
      | users::participant4 | 2 |
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 2     |
      | 2    | Room 3     |
    And user "participant2" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    And user "participant3" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 2     |
    And user "participant4" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 3     |
    When user "participant1" deletes room "Room 2" with 200 (v4)
    Then user "participant1" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
      | 2    | Room 3     |
    And user "participant3" is participant of the following rooms (v4)
      | type | name       |
      | 2    | class room |

  Scenario: Create an additional breakout room on the fly
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" promotes "participant2" in room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 2               |
    And user "participant1" creates 2 automatic breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    And user "participant2" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    # Can not nest breakout rooms
    Given user "participant1" creates room "Room 3" with 400 (v4)
      | roomType   | 2 |
      | roomName   | Room 3 |
      | objectType | room |
      | objectId   | ROOM(Room 2) |
    # Can not create room for other object types
    Given user "participant1" creates room "Room 3" with 400 (v4)
      | roomType   | 2 |
      | roomName   | Room 3 |
      | objectType | files |
      | objectId   | ROOM(class room) |
    Given user "participant1" creates room "Room 3" with 201 (v4)
      | roomType   | 2 |
      | roomName   | Room 3 |
      | objectType | room |
      | objectId   | ROOM(class room) |
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
      | 2    | Room 3     | 1          | 0                | 0                  |
    And user "participant2" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
      | 2    | Room 3     | 1          | 0                | 0                  |
    And user "participant1" starts breakout rooms in room "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 1                  |
      | 2    | Room 1     | 0          | 0                | 0                  |
      | 2    | Room 2     | 0          | 0                | 0                  |
      | 2    | Room 3     | 0          | 0                | 0                  |
    Given user "participant1" creates room "Room 3" with 201 (v4)
      | roomType   | 2 |
      | roomName   | Room 4 |
      | objectType | room |
      | objectId   | ROOM(class room) |
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 1                  |
      | 2    | Room 1     | 0          | 0                | 0                  |
      | 2    | Room 2     | 0          | 0                | 0                  |
      | 2    | Room 3     | 0          | 0                | 0                  |
      | 2    | Room 4     | 0          | 0                | 0                  |

  Scenario: Adding a user directly to a breakout room adds them to the parent as well
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" creates 2 automatic breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    When user "participant1" adds user "participant2" to room "Room 2" with 200 (v4)
    Then user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant1" sees the following attendees in room "Room 2" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant2" is participant of the following rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |

  Scenario: Adding a user directly to a breakout room adds them to the parent as well
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" creates 2 automatic breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    When user "participant1" adds user "participant2" to room "Room 2" with 200 (v4)
    Then user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant1" sees the following attendees in room "Room 2" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant2" is participant of the following rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |

  Scenario: Removing a user from the parent also removes them from the breakout room
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    When user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    When user "participant1" adds user "participant3" to room "class room" with 200 (v4)
    When user "participant1" adds user "participant4" to room "class room" with 200 (v4)
    Then user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
      | users      | participant3 | 3               |
      | users      | participant4 | 3               |
    And user "participant1" promotes "participant2" in room "class room" with 200 (v4)
    When user "participant1" creates 2 manual breakout rooms for "class room" with 200 (v1)
      | users::participant3 | 0 |
      | users::participant4 | 1 |
    And user "participant2" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 2                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    And user "participant3" is participant of the following rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 2                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
    And user "participant4" is participant of the following rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 2                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    When user "participant1" removes user "participant2" from room "class room" with 200 (v4)
    And user "participant1" removes user "participant3" from room "class room" with 200 (v4)
    And user "participant4" removes themselves from room "class room" with 200 (v4)
    Then user "participant2" is participant of the following rooms (v4)
    And user "participant3" is participant of the following rooms (v4)
    And user "participant4" is participant of the following rooms (v4)

  Scenario: Only users with normal level can be moved between breakout rooms
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    When user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    Then user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
    And user "participant1" promotes "participant2" in room "class room" with 200 (v4)
    And user "participant1" creates 2 automatic breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    # Can not "move" moderators
    When user "participant1" adds user "participant2" to room "Room 2" with 400 (v4)
    # Can not "add" groups
    When user "participant1" adds group "group1" to room "Room 2" with 400 (v4)

  Scenario: Teacher applies a new attendee map
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" adds user "participant2" to room "class room" with 200 (v4)
    And user "participant1" adds user "participant3" to room "class room" with 200 (v4)
    And user "participant1" adds user "participant4" to room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 3               |
      | users      | participant3 | 3               |
      | users      | participant4 | 3               |
    And user "participant1" promotes "participant2" in room "class room" with 200 (v4)
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
      | users      | participant2 | 2               |
      | users      | participant3 | 3               |
      | users      | participant4 | 3               |
    When user "participant1" creates 3 manual breakout rooms for "class room" with 200 (v1)
      | users::participant3 | 0 |
      | users::participant4 | 1 |
    Then user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 2                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
      | 2    | Room 3     | 1          | 0                | 0                  |
    Then user "participant3" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 1     |
    Then user "participant4" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 2     |
    When user "participant1" moves participants into different breakout rooms for "class room" with 400 (v1)
      | users::participant2 | 0 |
      | users::participant3 | 2 |
      | users::participant4 | 1 |
    When user "participant1" moves participants into different breakout rooms for "class room" with 400 (v1)
      | users::participant3 | -2 |
      | users::participant4 | 1 |
    When user "participant1" moves participants into different breakout rooms for "class room" with 400 (v1)
      | users::participant3 | 3 |
      | users::participant4 | 1 |
    When user "participant1" moves participants into different breakout rooms for "class room" with 200 (v1)
      | users::participant3 | 2 |
      | users::participant4 | 1 |
    Then user "participant3" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 3     |
    Then user "participant4" is participant of the following unordered rooms (v4)
      | type | name       |
      | 2    | class room |
      | 2    | Room 2     |

  Scenario: Can not change lobby status, allow or disallow guests in breakout rooms directly
    Given user "participant1" creates room "class room" (v4)
      | roomType | 2 |
      | roomName | class room |
    And user "participant1" sees the following attendees in room "class room" with 200 (v4)
      | actorType  | actorId      | participantType |
      | users      | participant1 | 1               |
    And user "participant1" creates 2 automatic breakout rooms for "class room" with 200 (v1)
    And user "participant1" is participant of the following unordered rooms (v4)
      | type | name       | lobbyState | breakoutRoomMode | breakoutRoomStatus |
      | 2    | class room | 0          | 1                | 0                  |
      | 2    | Room 1     | 1          | 0                | 0                  |
      | 2    | Room 2     | 1          | 0                | 0                  |
    # Can not disable lobby
    Then user "participant1" sets lobby state for room "Room 1" to "no lobby" with 400 (v4)
    # Can not enable listing
    And user "participant1" allows listing room "Room 1" for "all" with 400 (v4)
    # Can not allow guests
    And user "participant1" makes room "Room 1" public with 400 (v4)
