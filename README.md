# Godot Template
## Features
- Static typing
- Two busses "inherited" from master: Music and SFX
- Singletones: EventBus and Global

## Policies of using "Global" and "EventBus" singletones
### Global
The are some facts that show that it's better to place data and code in this global class:
- Deadline is kicking your ass and there is no time to elegant design
- Temporary functions and data for testing
- Cache information
- ...

If there is an opportunity to not place anything in here then use it.
### Event Bus
Here you can only place signal definitions and nothing else.
There are some facts that show that it is better to use the signal through this global class. The more facts that fit your case, the higher the likelihood that placing the signal here is the right decision:
- Signal is not emitted frequently
- Signal is not connected to a large number of nodes, either statically or at runtime
- It is difficult to connect the signal to the subscriber
- ...
