defmodule TodosWeb.TodoLive do
  use TodosWeb, :live_view
  alias Todos.TaskManager

  def mount(_params, _session, socket) do
    if connected?(socket), do: TaskManager.subscribe()
    {:ok, fetch(socket)}
  end

  def render(assigns) do
    ~H"""
    <div class="todo-container">
      <h1 class="todo-header">TODO LIST</h1>

      <form class="todo-form" phx-submit="add">
        <input type="text" name="todo[title]" placeholder="What to do" class="todo-input"/>
        <button type="submit" phx-disable-with="Adding" class="todo-button">Add</button>
      </form>

      <div class="todo-list">
        <%= for todo <- @todos do %>
          <div class="todo-item">
            <input
              type="checkbox"
              phx-click="delete_todo"
              value={todo.id}
              phx-value-id={todo.id}
              class="todo-checkbox"
            />
            <%= if @editing_id == todo.id do %>
              <form phx-submit="save_edit" phx-value-id={todo.id} class="edit-form">
                <input type="text" name="todo[title]" value={todo.title} class="edit-input"/>
                <button type="submit" class="save-button">Save</button>
                <button type="button" phx-click="cancel_edit" class="cancel-button">Cancel</button>
              </form>
            <% else %>
              <span class="todo-title"><%= todo.title %></span>
              <button type="button" phx-click="edit_todo" phx-value-id={todo.id} class="edit-button">Edit</button>
            <% end %>
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

  def handle_event("delete_todo", %{"id" => id}, socket) do
    todo = TaskManager.get_todo!(id)
    TaskManager.delete_todo(todo)
    {:noreply, fetch(socket)}
  end

  def handle_event("edit_todo", %{"id" => id}, socket) do
    {:noreply, assign(socket, editing_id: String.to_integer(id))}
  end

  def handle_event("save_edit", %{"id" => id, "todo" => %{"title" => title}}, socket) do
    todo = TaskManager.get_todo!(id)
    TaskManager.update_todo(todo, %{title: title})
    {:noreply, assign(socket, editing_id: nil) |> fetch()}
  end

  def handle_event("cancel_edit", _params, socket) do
    {:noreply, assign(socket, editing_id: nil)}
  end

  def handle_info({:todo_updated, _todo}, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, todos: TaskManager.list_todos() || [], editing_id: nil)
  end
end
