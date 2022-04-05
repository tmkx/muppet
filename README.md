# muppet

## Muppet

Library

## MuppetServer

### Apps

#### Get all apps

http://localhost:8080/apps

#### Get apps by identifier

http://localhost:8080/apps/:identifier
> For example: http://localhost:8080/apps/com.apple.finder

### Windows

#### Get all windows

http://localhost:8080/windows

#### Get windows by pid

http://localhost:8080/windows?pid=123

#### Get window detail

http://localhost:8080/windows/:windowId

### CDP

Chrome Devtools Protocol

devtools://devtools/bundled/inspector.html?ws=localhost:8080/cdp/:windowId
