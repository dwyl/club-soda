defmodule CsGuide.Resources.Brand do
  use Ecto.Schema
  use Alog
  import Ecto.Changeset

  schema "brands" do
    field(:name, :string)
    field(:description, :string)
    field(:member, :boolean, default: false)
    field(:logo, :string)
    field(:website, :string)
    field(:entry_id, :string)
    field(:deleted, :boolean, default: false)

    has_many(:drinks, CsGuide.Resources.Drink)

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :description, :deleted])
    |> validate_required([:name, :description])
  end
end
