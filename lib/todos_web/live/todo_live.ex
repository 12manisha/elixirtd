defmodule TodosWeb.TodoLive do
  use TodosWeb, :live_view
  alias Todos.TaskManager

  def mount(_params, _session, socket) do
    if connected?(socket), do: TaskManager.subscribe()
    {:ok, fetch(socket)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>TODO LIST</h1>

      <form phx-submit="add">
        <input type="text" name="todo[title]" placeholder="What to do"/>
        <button type="submit" phx-disable-with="Adding">Add</button>
      </form>

      <div>
        <%= for todo <- @todos do %>
          <div>
            <input type="checkbox"
                   phx-change="toggle_done"
                   value={todo.id}
                   { if todo.done, do: "checked" } />
            <%= todo.title %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end


  def handle_event("add", %{"todo" => todo}, socket) do
    TaskManager.create_todo(todo)
    {:noreply, fetch(socket)}
  end

  def handle_event("toggle_done", id, socket) do
    todo = TaskManager.get_todo!(id)
    TaskManager.update_todo(todo, %{done: !todo.done})
    {:noreply, fetch(socket)}
  end


  def handle_info({:todo_created, _todo}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({:todo_updated, _todo}, socket) do
    {:noreply, fetch(socket)}
  end


  defp fetch(socket) do
    todos = TaskManager.list_todos() || []
    assign(socket, todos: todos)
  end

end
