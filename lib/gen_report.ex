defmodule GenReport do
  alias GenReport.Parser

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(build_report(), &gen_report(&1, &2))
  end

  defp build_report(all_hours \\ %{}, hours_per_month \\ %{}, hours_per_year \\ %{}) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp gen_report(line, acc) do
    build_report(
      gen_all_hours_report(line, acc),
      gen_month_hours_report(line, acc),
      gen_year_hours_report(line, acc)
    )
  end

  defp gen_all_hours_report([name, hours, _, _, _], %{"all_hours" => all_hours}) do
    sum_hours(all_hours, name, hours)
  end

  defp gen_month_hours_report([name, hours, _, month, _], %{"hours_per_month" => hours_per_month}) do
    gen_nested_hours_report(hours_per_month, name, month, hours)
  end

  defp gen_year_hours_report([name, hours, _, _, year], %{"hours_per_year" => hours_per_year}) do
    gen_nested_hours_report(hours_per_year, name, year, hours)
  end

  defp gen_nested_hours_report(acc_hours, dev_name, hours_key, hours)
       when is_map_key(acc_hours, dev_name) do
    dev_nested_hours = acc_hours[dev_name]

    update_nested_hours(
      acc_hours,
      dev_name,
      sum_hours(dev_nested_hours, hours_key, hours)
    )
  end

  defp gen_nested_hours_report(acc_hours, dev_name, hours_key, hours) do
    update_nested_hours(acc_hours, dev_name, %{hours_key => hours})
  end

  defp sum_hours(acc_hours, hours_key, hours) when is_map_key(acc_hours, hours_key) do
    %{acc_hours | hours_key => acc_hours[hours_key] + hours}
  end

  defp sum_hours(acc_hours, hours_key, hours) do
    Map.merge(acc_hours, %{hours_key => hours})
  end

  defp update_nested_hours(acc_hours, dev_name, dev_map) do
    Map.merge(acc_hours, %{dev_name => dev_map})
  end
end
