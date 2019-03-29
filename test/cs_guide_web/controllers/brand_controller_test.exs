defmodule CsGuideWeb.BrandControllerTest do
  use CsGuideWeb.ConnCase

  alias CsGuide.Resources.Brand

  import CsGuide.SetupHelpers

  @create_attrs %{
    description: "some description",
    logo: "some logo",
    member: true,
    name: "some name",
    slug: "some-name",
    sold_amazon: false,
    sold_aldi: true,
    sold_ocado: true,
    website: "https://www.some-website.com"
  }
  @update_attrs %{
    description: "some updated description",
    logo: "some updated logo",
    member: true,
    name: "some updated name",
    slug: "some-updated-name",
    sold_amazon: true,
    sold_aldi: true,
    sold_ocado: false,
    website: "https://www.some-updated-website.com"
  }
  @invalid_attrs %{description: nil, logo: nil, member: nil, name: nil, website: nil}

  def fixture(:brand) do
    {:ok, brand} =
      %Brand{}
      |> Brand.changeset(@create_attrs)
      |> Brand.insert()

    brand
  end

  describe "index" do
    test "cannot access page if not logged in", %{conn: conn} do
      conn = get(conn, brand_path(conn, :index))
      assert html_response(conn, 302)
    end
  end

  describe "index - admin" do
    setup [:admin_login]

    test "lists all brands", %{conn: conn} do
      conn = get(conn, brand_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Brands"
    end
  end

  describe "new brand" do
    test "does not render form if not logged in", %{conn: conn} do
      conn = get(conn, brand_path(conn, :new))
      assert html_response(conn, 302)
    end
  end

  describe "new brand - admin" do
    setup [:admin_login]

    test "renders form", %{conn: conn} do
      conn = get(conn, brand_path(conn, :new))
      assert html_response(conn, 200) =~ "New Brand"
    end
  end

  describe "create brand" do
    setup [:admin_login]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, brand_path(conn, :create), brand: @create_attrs)

      assert redirected_to(conn) == brand_path(conn, :index)

      conn = get(conn, brand_path(conn, :show, @create_attrs.slug))
      assert html_response(conn, 200) =~ "some name"
      refute html_response(conn, 200) =~ "Use discount code"
      assert html_response(conn, 200) =~ "Aldi"
      refute html_response(conn, 200) =~ "Amazon"
      assert html_response(conn, 200) =~ "Ocado"
      assert html_response(conn, 200) =~ "bg-spirit"
      refute html_response(conn, 200) =~ "bg-beer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, brand_path(conn, :create), brand: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Brand"
    end
  end

  describe "edit brand" do
    setup [:create_brand]

    test "non logged in user cannot access form", %{conn: conn, brand: brand} do
      conn = get(conn, brand_path(conn, :edit, brand.slug))
      assert html_response(conn, 302)
    end
  end

  describe "edit brand - admin" do
    setup [:create_brand, :admin_login]

    test "renders form for editing chosen brand", %{conn: conn, brand: brand} do
      conn = get(conn, brand_path(conn, :edit, brand.slug))
      assert html_response(conn, 200) =~ "Edit Brand"
    end
  end

  describe "update brand" do
    setup [:create_brand, :admin_login]

    test "redirects when data is valid", %{conn: conn, brand: brand} do
      conn = put(conn, brand_path(conn, :update, brand.slug), brand: @update_attrs)
      assert redirected_to(conn) == brand_path(conn, :show, @update_attrs.slug)

      conn = get(conn, brand_path(conn, :show, @update_attrs.slug))

      assert html_response(conn, 200) =~
               "https://www.amazon.co.uk/s/ref=as_li_ss_tl?url=search-alias=aps&field-keywords=some updated name&linkCode=ll2&tag=clusod0c-21"

      assert html_response(conn, 200) =~
               "https://www.aldi.co.uk/search?text=some updated name&category=ALL"

      assert html_response(conn, 200) =~ "some updated description"
      refute html_response(conn, 200) =~ "Ocado"
    end

    test "renders errors when data is invalid", %{conn: conn, brand: brand} do
      conn = put(conn, brand_path(conn, :update, brand.slug), brand: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Brand"
    end
  end

  # describe "delete brand" do
  #   setup [:create_brand]
  #
  #   test "deletes chosen brand", %{conn: conn, brand: brand} do
  #     conn = delete(conn, brand_path(conn, :delete, brand))
  #     assert redirected_to(conn) == brand_path(conn, :index)
  #
  #     assert_error_sent(404, fn ->
  #       get(conn, brand_path(conn, :show, brand))
  #     end)
  #   end
  # end

  defp create_brand(_) do
    brand = fixture(:brand)
    {:ok, brand: brand}
  end
end
