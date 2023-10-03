class FaviconSamplingJob < ActiveJob::Base
  ['open-uri', 'rmagick'].each do |lib|
    require lib
  end

  def perform(id)
    link = Link.find(id)
    destination_path = Rails.root.join('tmp', "#{link.id}-favicon.ico")

    download_favicon(favicon_url(link.url), destination_path)
    pixels = parse_favicon destination_path

    counts = pixels.group_by { |pixel| pixel }.transform_values(&:count)
    rgb_values = counts.sort_by {|_, count| -count}.take(3).map(&:first)

    convert_rgb_to_hex rgb_values
  end

  def convert_rgb_to_hex rbg_values
    rgb_values.map do |rgb|
      "##{rgb.map { |val| val.to_s(16).rjust(2, '0') }.join('')}"
    end
  end

  def download_favicon(url, destination)
    open(url) do |file|
      File.open(destination, 'wb') do |output|
        output.write(file.read)
      end
    end
  end

  def parse_favicon destination_path
    image = Magick::Image.read(destination_path).first
    pixels = image.export_pixels(0,0, image.columns, image.rows, 'RGB')
    pixels.each_slice(3).to_a
  end

  def delete_file destination_path
    if File.exists?
      File.delete(destination_path)
    end
  end

  def favicon_url(domain)
    "https://www.google.com/s2/favicons?domain=#{domain}"
  end

end
