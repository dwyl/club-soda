defmodule CsGuide.Resources.Venue do
  use Ecto.Schema
  use Alog
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias CsGuide.Repo
  alias CsGuide.Resources

  schema "venues" do
    field(:venue_name, :string)
    field(:description, Fields.DescriptionPlaintextUnlimited)
    field(:address, Fields.Address)
    field(:city, Fields.Address)
    field(:postcode, Fields.Postcode)
    field(:website, :string)
    field(:phone_number, Fields.PhoneNumber)
    field(:twitter, :string)
    field(:facebook, :string)
    field(:instagram, :string)
    field(:cs_score, :float, default: 0.0)
    field(:favourite, :boolean, default: false)
    field(:num_cocktails, :integer)
    field(:entry_id, :string)
    field(:deleted, :boolean, default: false)
    field(:external_image, :string)

    many_to_many(
      :venue_types,
      CsGuide.Categories.VenueType,
      join_through: "venues_venue_types",
      join_keys: [venue_id: :id, venue_type_id: :id],
      on_replace: :delete
    )

    many_to_many(
      :drinks,
      CsGuide.Resources.Drink,
      join_through: "venues_drinks",
      join_keys: [venue_id: :id, drink_id: :id],
      on_replace: :delete
    )

    many_to_many(
      :users,
      CsGuide.Accounts.User,
      join_through: "venues_users",
      join_keys: [venue_id: :id, user_id: :id],
      on_replace: :delete
    )

    has_many(:venue_images, CsGuide.Images.VenueImage)

    timestamps()
  end

  @doc false
  def changeset(venue, attrs \\ %{}) do
    venue
    |> cast(attrs, [
      :venue_name,
      :postcode,
      :phone_number,
      :cs_score,
      :description,
      :num_cocktails,
      :website,
      :address,
      :city,
      :twitter,
      :instagram,
      :facebook,
      :favourite,
      :external_image
    ])
    |> cast_assoc(:users)
    |> validate_required([:venue_name, :postcode, :venue_types])
  end

  def insert(attrs) do
    %__MODULE__{}
    |> __MODULE__.changeset(attrs)
    |> insert_entry_id()
    |> Resources.put_many_to_many_assoc(attrs, :venue_types, CsGuide.Categories.VenueType, :name)
    |> Resources.put_many_to_many_assoc(attrs, :drinks, CsGuide.Resources.Drink, :entry_id)
    |> Resources.require_assocs([:venue_types])
    |> Repo.insert()
  end

  def update(%__MODULE__{} = item, attrs) do
    item
    |> __MODULE__.preload(__MODULE__.__schema__(:associations))
    |> Map.put(:id, nil)
    |> Map.put(:inserted_at, nil)
    |> Map.put(:updated_at, nil)
    |> __MODULE__.changeset(attrs)
    |> Resources.put_many_to_many_assoc(attrs, :venue_types, CsGuide.Categories.VenueType, :name)
    |> Resources.put_many_to_many_assoc(attrs, :drinks, CsGuide.Resources.Drink, :entry_id)
    |> Repo.insert()
  end
end
