defmodule AssetTracker.Brokerages do
  @moduledoc false
  alias AssetTracker.Brokerages.BrokerageLogic
  defdelegate list_brokerage, to: BrokerageLogic

  defdelegate get_brokerage!(id), to: BrokerageLogic

  defdelegate create_brokerage(attrs \\ %{}), to: BrokerageLogic

  defdelegate update_brokerage(brokerage, attrs),
    to: BrokerageLogic

  defdelegate delete_brokerage(brokerage), to: BrokerageLogic

  defdelegate change_brokerage(brokerage, attrs \\ %{}),
    to: BrokerageLogic
end
