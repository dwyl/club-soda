defmodule CsGuide.Repo.Migrations.CreateVenues do
  use Ecto.Migration

  def change do
    create table(:venues) do
      add(:venue_name, :string)
      add(:postcode, :string)
      add(:phone_number, :string)
      add(:cs_score, :float, default: 0)
      add(:entry_id, :string)
      add(:deleted, :boolean, default: false)
      add(:description, :text)
      add(:num_cocktails, :integer)
      add(:website, :string)
      add(:address_line_1, :string)
      add(:city, :string)

      timestamps()
    end
  end
end
