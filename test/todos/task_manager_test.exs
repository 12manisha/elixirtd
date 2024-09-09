defmodule Todos.TaskManagerTest do
  use Todos.DataCase

  alias Todos.TaskManager

  describe "todos" do
    alias Todos.TaskManager.Todo

    import Todos.TaskManagerFixtures

    @invalid_attrs %{done: nil, title: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert TaskManager.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert TaskManager.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{done: true, title: "some title"}

      assert {:ok, %Todo{} = todo} = TaskManager.create_todo(valid_attrs)
      assert todo.done == true
      assert todo.title == "some title"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskManager.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{done: false, title: "some updated title"}

      assert {:ok, %Todo{} = todo} = TaskManager.update_todo(todo, update_attrs)
      assert todo.done == false
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskManager.update_todo(todo, @invalid_attrs)
      assert todo == TaskManager.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = TaskManager.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> TaskManager.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = TaskManager.change_todo(todo)
    end
  end
end
