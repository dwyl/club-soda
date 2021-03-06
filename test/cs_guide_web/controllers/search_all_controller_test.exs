defmodule CsGuideWeb.SearchAllControllerTest do
  use CsGuideWeb.ConnCase
  alias CsGuide.{Resources, Categories, Fixtures}
  @create_types Fixtures.create_types()
  @create_brand Fixtures.create_brand()

  @venues [
    %{
      venue_name: "The Favourite Pub",
      parent_company: "Parent Co",
      favourite: true,
      venue_types: %{"Pubs" => "on"},
      city: "London",
      postcode: "MK40 1AY",
      slug: "the-favourite-pub-tw3-5fg"
    }
  ]

  @create_attrs %{
    name: "AF Beer 1",
    abv: "0.5",
    description: "Description of drink",
    weighting: 1,
    drink_types: %{"Beer" => "on"}
  }

  def fixture(:type) do
    types =
      @create_types
      |> Enum.map(fn t ->
        {:ok, type} = Categories.DrinkType.insert(t)

        type
      end)

    types
  end

  def fixture(:brand) do
    {:ok, brand} =
      %Resources.Brand{}
      |> Resources.Brand.changeset(@create_brand)
      |> Resources.Brand.insert()

    brand
  end

  def fixture(:venue) do
    %Categories.VenueType{}
    |> Categories.VenueType.changeset(%{name: "Pubs"})
    |> Categories.VenueType.insert()

    @venues
    |> Enum.map(fn v ->
      {:ok, venue} = Resources.Venue.insert(v)
      venue
    end)
  end

  def fixture(:drink, brand) do
    {:ok, drink} =
      @create_attrs
      |> Map.put(:brand, brand)
      |> Resources.Drink.insert()

    drink
  end

  describe "search on venues and drinks" do
    setup [:create_venue, :drink_setup]

    test "GET /search/all display venue and drink", %{conn: conn} do
      conn = get(conn, "/search/all")

      assert html_response(conn, 200) =~ "The Favourite Pub"
      assert html_response(conn, 200) =~ "AF Beer 1"
    end

    test "GET search by postcode", %{conn: conn} do
      conn = get(conn, "/search/all?term=MK40 1AY")
      assert html_response(conn, 302)
    end

    test "GET search by postcode text", %{conn: conn} do
      conn = get(conn, "/search/all?term=MK40")
      assert html_response(conn, 200) =~ "The Favourite Pub"
    end

    test "GET search by city text", %{conn: conn} do
      conn = get(conn, "/search/all?term=Lond")
      assert html_response(conn, 200) =~ "The Favourite Pub"
    end
  end

  def create_venue(_) do
    venue = fixture(:venue)
    {:ok, venue: venue}
  end

  defp drink_setup(_) do
    brand = fixture(:brand)
    {:ok, brand: brand}

    type = fixture(:type)
    {:ok, type: type}

    drink = fixture(:drink, brand.name)
    {:ok, drink: drink}
  end
end
