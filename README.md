# muppet

## Muppet

Core library

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

http://localhost:8080/windows?pid=123&isOnScreen=true

#### Get window detail

http://localhost:8080/windows/:windowId

#### Get window screenshot

http://localhost:8080/windows/screenshot/:windowId

### CDP

Chrome Devtools Protocol

devtools://devtools/bundled/inspector.html?ws=localhost:8080/cdp/:windowId
