# TODO list with Phoenix Liveview

based on [this](https://github.com/dwyl/phoenix-liveview-todo-list-tutorial) tutorial

Phoenix app with ecto db

setup:

```
make enter
# and inside the container
mix phx.new todo
```
This will generate a Phoenix app. Then generate the database
```
# inside the container as well, make enter again if previously exited
cd todo
mix ecto.create # to generate the database
```