defmodule GenReport.Parser do
  @months %{
    "1": "Janeiro",
    "2": "Fevereiro",
    "3": "Março",
    "4": "Abril",
    "5": "Maio",
    "6": "Junho",
    "7": "Julho",
    "8": "Agosto",
    "9": "Setembro",
    "10": "Outubro",
    "11": "Novembro",
    "12": "Dezembro"
  }

  def parse_file(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&parse_line(&1))
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(3, &get_month_name(String.to_atom(&1)))
    |> Enum.map(fn elem ->
      case Integer.parse(elem) do
        :error -> String.downcase(elem)
        {value, ""} -> value
      end
    end)
  end

  defp get_month_name(month_number), do: @months[month_number]
end
