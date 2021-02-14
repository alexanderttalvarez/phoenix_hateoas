if Code.ensure_loaded?(Plug) do
  defmodule PhoenixHateoas.Plug do
    import Plug.Conn

    def init(_params) do
    end

    def call(conn, _params) do
      register_before_send(conn, fn(conn) ->
        case get_resp_header(conn, "content-type") do
          [] -> conn
          [content_type | _tail] ->
            if String.contains?(content_type, "application/json") do
              case conn.status do
                st when st >= 200 and st < 300 -> resp(
                    conn,
                    conn.status,
                    Jason.encode!(Map.merge(Jason.decode!(conn.resp_body), %{"_links" => get_links(conn)}))
                  )
                _ -> conn
              end

            else
              conn
            end
        end
      end)
    end

    defp get_links(conn) do
      [
        get_self(conn),
        get_prev(conn),
        get_next(conn),
        get_index(conn)
      ]
      |> Enum.reject(&(&1==nil))
    end

    defp get_self(conn) do
      %{
        "rel" => "self",
        "href" => conn.request_path
      }
    end

    def get_index(conn) do
      with(
        {:ok, _slug} <- Map.fetch(conn.params, "slug")
      ) do
        %{
          "rel" => "index",
          "href" => conn.request_path |> String.split("/") |> Enum.reverse() |> tl() |> Enum.reverse() |> Enum.join("/")
        }
      else
        _err -> nil
      end
    end

    defp get_prev(_conn) do
      nil
    end

    defp get_next(_conn) do
      nil
    end
  end
end
