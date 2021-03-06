defmodule CsGuideWeb.RetailerControllerTest do
  use CsGuideWeb.ConnCase
  alias CsGuide.Fixtures
  alias CsGuide.{Resources, Categories}

  import CsGuide.SetupHelpers

  @create_brand Fixtures.create_brand()
  @create_types Fixtures.create_types()
  @create_drinks Fixtures.create_drinks()
  @create_venue_types Fixtures.create_venue_types()

  @create_attrs %{
    venue_name: "Retailer 1",
    website: "http://www.test.com",
    venue_types: %{"Retailer" => "on"}
  }

  # doesn't appear to be used. Doesn't look like update retailer is being tested
  # =====================================
  # @update_attrs %{
  #   venue_name: "Retailer 1",
  #   website: "http://www.updatedtest.com",
  #   venue_types: %{"Retailer" => "on"}
  # }

  @invalid_attrs %{venue_types: nil, website: nil, venue_name: nil}

  def fixture(:retailer) do
    @create_venue_types
    |> Enum.map(fn vt ->
      {:ok, _venue_type} =
        %Categories.VenueType{}
        |> Categories.VenueType.changeset(vt)
        |> Categories.VenueType.insert()
    end)

    {:ok, retailer} =
      @create_attrs
      |> Resources.Venue.retailer_insert()

    retailer
  end

  def fixture(:brand) do
    {:ok, brand} =
      @create_brand
      |> Resources.Brand.insert()

    brand
  end

  def fixture(:type) do
    types =
      @create_types
      |> Enum.map(fn t ->
        {:ok, type} = Categories.DrinkType.insert(t)
        type
      end)

    types
  end

  def fixture(:drink, brand) do
    drinks =
      @create_drinks
      |> Enum.map(fn d ->
        {:ok, drink} =
          Map.put(d, :brand, brand)
          |> Resources.Drink.insert()

        drink
      end)

    drinks
  end

  describe "index" do
    test "does not list retailers if not logged in", %{conn: conn} do
      conn = get(conn, retailer_path(conn, :index))
      assert html_response(conn, 302)
    end
  end

  describe "index - admin" do
    setup [:admin_login]

    test "lists all retailers", %{conn: conn} do
      conn = get(conn, retailer_path(conn, :index))
      assert html_response(conn, 200) =~ "All Retailers"
    end
  end

  describe "new retailer" do
    test "does not render form if not logged in", %{conn: conn} do
      conn = get(conn, retailer_path(conn, :new))
      assert html_response(conn, 302)
    end
  end

  describe "new retailer - admin" do
    setup [:admin_login]

    test "renders form", %{conn: conn} do
      conn = get(conn, retailer_path(conn, :new))
      assert html_response(conn, 200) =~ "New Retailer"
    end
  end

  describe "create retailer" do
    setup [:create_retailer, :admin_login]

    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, retailer_path(conn, :create), venue: @create_attrs)

      assert redirected_to(conn) == retailer_path(conn, :index)

      conn = get(conn, retailer_path(conn, :index))
      assert html_response(conn, 200) =~ "All Retailers"
      assert html_response(conn, 200) =~ "Retailer 1"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, retailer_path(conn, :create), venue: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Retailer"
    end
  end

  describe "edit retailer" do
    setup [:create_retailer]

    test "does not render form when not logged in", %{conn: conn, retailer: retailer} do
      conn = get(conn, retailer_path(conn, :edit, retailer.entry_id))
      assert html_response(conn, 302)
    end
  end

  describe "edit retailer - admin" do
    setup [:create_retailer, :admin_login]

    test "renders form for editing chosen retailer", %{conn: conn, retailer: retailer} do
      conn = get(conn, retailer_path(conn, :edit, retailer.entry_id))
      assert html_response(conn, 200) =~ "Edit Retailer"
    end
  end

  describe "update retailer" do
    setup [:create_retailer, :admin_login]

    test "renders errors when data is invalid", %{conn: conn, retailer: retailer} do
      conn = put(conn, retailer_path(conn, :update, retailer.entry_id), venue: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Retailer"
    end
  end

  describe "add drinks to retailer - admin" do
    setup [:create_retailer, :admin_login]

    test "renders form for adding drinks to chosen retailer", %{conn: conn, retailer: retailer} do
      conn = get(conn, retailer_path(conn, :add_drinks, retailer.entry_id))
      assert html_response(conn, 200) =~ "Add drinks sold by the retailer"
    end
  end

  defp create_retailer(_) do
    retailer = fixture(:retailer)
    {:ok, retailer: retailer}
  end
end
