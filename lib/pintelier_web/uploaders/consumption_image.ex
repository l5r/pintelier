defmodule Pintelier.ConsumptionImage do
  use Waffle.Definition

  # Include ecto support (requires package waffle_ecto installed):
  use Waffle.Ecto.Definition

  @versions [:original, :thumb, :display]
  @extensions ~w(.jpg .jpeg .png .gif .webp)

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # def bucket({_file, scope}) do
  #   scope.bucket || bucket()
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(@extensions, file_extension) do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def transform(:original, _), do: :noaction

  def transform(:thumb, _) do
    {:convert,
     "-auto-orient -strip -thumbnail 128x128^ -gravity center -extent 128x128 -quality 75 -format jpg",
     :jpg}
  end

  def transform(:display, _) do
    {:convert, "-auto-orient -strip -gravity center -extent 1:1 -resize 1024x1024> -format jpg",
     :jpg}
  end

  # Override the persisted filenames:
  def filename(version, {_file, _sccope}) do
    "image-#{version}"
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/user/#{scope.user_id}/consumptions/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
