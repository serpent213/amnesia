#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

defmodule Amnesia.Access do
  @moduledoc """
  This behavior is used to implement a different system while taking advantage
  of mnesia.

  It's used by mnesia itself to implement fragmentation using `mnesia_frag` and
  `mnesia:activity`.
  """

  use Behaviour

  @type id :: { :tid, integer, pid } | { :async_dirty, pid } | { :sync_dirty, pid } | { :ets, pid }

  @type lock_item :: { :table, atom } | { :global, any, [node] }
  @type lock_kind :: :write | :read | :sticky_write

  defcallback lock(id, any, lock_item, lock_kind) :: [node] | :ok | no_return
  defcallback write(id, any, atom, record, lock_kind) :: :ok | no_return
  defcallback delete(id, any, atom, any, lock_kind) :: :ok | no_return
  defcallback delete_object(id, any, atom, record, lock_kind) :: :ok | no_return
  defcallback read(id, any, atom, any, lock_kind) :: [record] | no_return
  defcallback match_object(id, any, atom, any, lock_kind) :: [any] | no_return
  defcallback all_keys(id, any, atom, lock_kind) :: [any] | no_return
  defcallback select(id, any, atom, any, lock_kind) :: [any]
  defcallback select(id, any, atom, any, integer, lock_kind) :: [any]
  defcallback select_cont(id, any, any) :: :"$end_of_table" | { [any], any }
  defcallback index_match_object(id, any, atom, any, atom | integer, lock_kind) :: [any] | no_return
  defcallback index_read(id, any, atom, any, atom | integer, lock_kind) :: [record] | no_return
  defcallback foldl(id, any, function, any, atom, lock_kind) :: any | no_return
  defcallback foldr(id, any, function, any, atom, lock_kind) :: any | no_return
  defcallback table_info(id, any, atom | { atom, atom }, atom) :: any
  defcallback first(id, any, atom) :: any
  defcallback next(id, any, atom, any) :: any
  defcallback prev(id, any, atom, any) :: any
  defcallback last(id, any, atom) :: any
  defcallback clear_table(id, any, atom, any) :: { :atomic, :ok } | { :aborted, any }

  @spec lock(id, any, lock_item, lock_kind) :: [node] | :ok | no_return
  def lock(id, opaque, item, kind) do
    :mnesia.lock(id, opaque, item, kind)
  end

  @spec write(id, any, atom, record, lock_kind) :: :ok | no_return
  def write(id, opaque, table, record, lock) do
    :mnesia.write(id, opaque, table, record, lock)
  end

  @spec delete(id, any, atom, atom, lock_kind) :: :ok | no_return
  def delete(id, opaque, table, key, lock) do
    :mnesia.delete(id, opaque, table, key, lock)
  end

  @spec delete_object(id, any, atom, record, lock_kind) :: :ok | no_return
  def delete_object(id, opaque, table, record, lock) do
    :mnesia.delete_object(id, opaque, table, record, lock)
  end

  @spec read(id, any, atom, any, lock_kind) :: [record] | no_return
  def read(id, opaque, table, key, lock) do
    :mnesia.read(id, opaque, table, key, lock)
  end

  @spec match_object(id, any, atom, any, lock_kind) :: [record] | no_return
  def match_object(id, opaque, table, pattern, lock) do
    :mnesia.match_object(id, opaque, table, pattern, lock)
  end

  @spec all_keys(id, any, atom, lock_kind) :: [any]
  def all_keys(id, opaque, table, lock) do
    :mnesia.all_keys(id, opaque, table, lock)
  end

  @spec select(id, any, atom, any, lock_kind) :: [any]
  def select(id, opaque, table, spec, lock) do
    :mnesia.select(id, opaque, table, spec, lock)
  end

  @spec select(id, any, atom, any, integer, lock_kind) :: [any]
  def select(id, opaque, table, spec, limit, lock) do
    :mnesia.select(id, opaque, table, spec, limit, lock)
  end

  @spec select_cont(id, any, any) :: :"$end_of_table" | { [any], any }
  def select_cont(id, opaque, cont) do
    :mnesia.select_cont(id, opaque, cont)
  end

  @spec index_match_object(id, any, atom, any, atom | integer, lock_kind) :: [any] | no_return
  def index_match_object(id, opaque, table, pattern, attribute, lock) do
    :mnesia.index_match_object(id, opaque, table, pattern, attribute, lock)
  end

  @spec index_read(id, any, atom, any, atom | integer, lock_kind) :: [record] | no_return
  def index_read(id, opaque, table, key, attribute, lock) do
    :mnesia.index_read(id, opaque, table, key, attribute, lock)
  end

  @spec foldl(id, any, function, any, atom, lock_kind) :: any | no_return
  def foldl(id, opaque, fun, acc, table, lock) do
    :mnesia.foldl(id, opaque, fun, acc, table, lock)
  end

  @spec foldr(id, any, function, any, atom, lock_kind) :: any | no_return
  def foldr(id, opaque, fun, acc, table, lock) do
    :mnesia.foldr(id, opaque, fun, acc, table, lock)
  end

  @spec table_info(id, any, atom | { atom, atom }, atom) :: any
  def table_info(id, opaque, of, key) do
    :mnesia.table_info(id, opaque, of, key)
  end

  @spec first(id, any, atom) :: any
  def first(id, opaque, table) do
    :mnesia.first(id, opaque, table)
  end

  @spec next(id, any, atom, any) :: any
  def next(id, opaque, table, key) do
    :mnesia.next(id, opaque, table, key)
  end

  @spec prev(id, any, atom, any) :: any
  def prev(id, opaque, table, key) do
    :mnesia.prev(id, opaque, table, key)
  end

  @spec last(id, any, atom) :: any
  def last(id, opaque, table) do
    :mnesia.last(id, opaque, table)
  end

  @spec clear_table(id, any, atom, any) :: { :atomic, :ok } | { :aborted, any }
  def clear_table(id, opaque, table, object) do
    :mnesia.clear_table(id, opaque, table, object)
  end

  defmacro __using__(opts) do
    target = Keyword.get(opts, :module, __MODULE__)

    quote do
      if unquote(target) == __MODULE__ do
        @behavior Amnesia.Access
      end

      @doc """
      Start a transaction with the given block or function, see `mnesia:transaction`.
      """
      @spec transaction([] | function) :: { :aborted, any } | { :atomic, any }
      defmacro transaction(do: block) do
        target = unquote(Macro.escape(target))

        quote do
          try do
            { :atomic, :mnesia.activity(:transaction, function(do: (() -> unquote(block))), [], unquote(target)) }
          catch
            :exit, error -> error
          end
        end
      end

      defmacro transaction(fun) when is_function fun, 0 do
        target = unquote(Macro.escape(target))

        quote do
          try do
            { :atomic, :mnesia.activity(:transaction, unquote(fun), [], unquote(target)) }
          catch
            :exit, error -> error
          end
        end
      end

      @doc """
      Start a transaction with the given function passing the passed arguments to
      it, see `mnesia:transaction`.
      """
      @spec transaction(function, list) :: { :aborted, any } | { :atomic, any }
      def transaction(fun, args) when is_function fun, length args do
        try do
          { :atomic, :mnesia.activity(:transaction, fun, args, unquote(target)) }
        catch
          :exit, error -> error
        end
      end

      @doc """
      Start a transaction with the given function passing the passed arguments to it,
      trying to take a lock maximum *retries* times, see `mnesia:transaction`.
      """
      @spec transaction(function, list, integer) :: { :aborted, any } | { :atomic, any }
      def transaction(fun, args, retries) when is_function fun, length args do
        try do
          { :atomic, :mnesia.activity({ :transaction, retries }, fun, args, unquote(target)) }
        catch
          :exit, error -> error
        end
      end

      @doc """
      Start a synchronous transaction with the given block or function, see
      `mnesia:sync_transaction`.
      """
      @spec transaction!([] | function) :: { :aborted, any } | { :atomic, any }
      defmacro transaction!(do: block) do
        target = unquote(Macro.escape(target))

        quote do
          try do
            { :atomic, :mnesia.activity(:sync_transaction, function(do: (() -> unquote(block))), [], unquote(target)) }
          catch
            :exit, error -> error
          end
        end
      end

      defmacro transaction!(fun) when is_function fun, 0 do
        target = unquote(Macro.escape(target))

        quote do
          try do
            { :atomic, :mnesia.activity(:sync_transaction, unquote(fun), [], unquote(target)) }
          catch
            :exit, error -> error
          end
        end
      end

      @doc """
      Start a synchronous transaction with the given function passing the passed
      arguments to it, see `mnesia:sync_transaction`.
      """
      @spec transaction!(function, list) :: { :aborted, any} | { :atomic, any }
      def transaction!(fun, args) when is_function fun, length args do
        try do
          { :atomic, :mnesia.activity(:sync_transaction, fun, args, unquote(target)) }
        catch
          :exit, error -> error
        end
      end

      @doc """
      Start a synchronous transaction with the given function passing the passed
      arguments to it, trying to take a lock maximum *retries* times, see
      `mnesia:sync_transaction`.
      """
      @spec transaction!(function, list, integer) :: { :aborted, any } | { :atomic, any }
      def transaction!(fun, args, retries) when is_function fun, length args do
        try do
          { :atomic, :mnesia.activity({ :sync_transaction, retries }, fun, args, unquote(target)) }
        catch
          :exit, error -> error
        end
      end

      @doc """
      Run the passed function or block in the ETS context, see `mnesia:ets`.
      """
      @spec ets([] | function) :: any
      defmacro ets(do: block) do
        target = unquote(Macro.escape(target))

        quote do
          :mnesia.activity(:ets, function(do: (() -> unquote(block))), [], unquote(target))
        end
      end

      defmacro ets(fun) when is_function fun, 0 do
        target = unquote(Macro.escape(target))

        quote do
          :mnesia.activity(:ets, unquote(fun), [], unquote(target))
        end
      end

      @doc """
      Run the passed function in the ETS context passing over the passed arguments,
      see `mnesia:ets`.
      """
      @spec ets(function, list) :: any
      def ets(fun, args) when is_function fun, length args do
        :mnesia.activity(:ets, fun, args, unquote(target))
      end

      @doc """
      Run the passed function or block in a dirty asynchronous context, see
      `mnesia:async_dirty`.
      """
      @spec async([] | function) :: any
      defmacro async(do: block) do
        target = unquote(Macro.escape(target))

        quote do
          :mnesia.activity(:async_dirty, function(do: (() -> unquote(block))), [], unquote(target))
        end
      end

      defmacro async(fun) when is_function fun, 0 do
        target = unquote(Macro.escape(target))

        quote do
          :mnesia.activity(:async_dirty, unquote(fun), [], unquote(target))
        end
      end

      @doc """
      Run the passed function in a dirty asynchronous context passing over the
      passed arguments, see `mnesia:async_dirty`.
      """
      @spec async(function, list) :: any
      def async(fun, args) when is_function fun, length args do
        :mnesia.activity(:async_dirty, fun, args, unquote(target))
      end

      @doc """
      Run the passed function or block in a dirty synchronous context, see
      `mnesia:sync_dirty`.
      """
      @spec sync([] | function) :: any
      defmacro sync(do: block) do
        target = unquote(Macro.escape(target))

        quote do
          :mnesia.activity(:sync_dirty, function(do: (() -> unquote(block))), [], unquote(target))
        end
      end

      defmacro sync(fun) when is_function fun, 0 do
        target = unquote(Macro.escape(target))

        quote do
          :mnesia.activity(:sync_dirty, unquote(fun), [], unquote(target))
        end
      end

      @doc """
      Run the passed function in a dirty synchronous context passing over the
      passed arguments, see `mnesia:sync_dirty`.
      """
      @spec sync(function, list) :: any
      def sync(fun, args) when is_function fun, length args do
        :mnesia.activity(:sync_dirty, fun, args, unquote(target))
      end
    end
  end
end
