defmodule CsGuideWeb.SearchBrandController do
  use CsGuideWeb, :controller

  alias CsGuide.Resources.Brand

  def index(conn, _params) do
    brands =
      Brand.all()
      |> Brand.preload(brand_images: [])
      |> Enum.sort_by(&String.first(&1.name))
      |> Enum.map(&(Map.put(&1, :cover_image, get_cover_brand_image(&1.brand_images))))
      |> Enum.group_by(& &1.member)

    {members, non_members} =
      case brands do
        %{true: members, false: non_members} -> {members, non_members}
        %{true: members} -> {members, []}
        %{false: non_members} -> {[], non_members}
        _ -> {[], []}
      end

    render(conn, "index.html", member_brands: members, brands: non_members)
  end

  @doc """
  Retreive the cover image for the brand.
  If no cover image found returns nil
  """
  def get_cover_brand_image([]), do: nil

  def get_cover_brand_image(images) do
    images
    |> Enum.filter(&(&1.one and not &1.deleted))
    |> Enum.sort_by(&(&1.id), &>=/2)
    |> Enum.at(0)
  end
end
