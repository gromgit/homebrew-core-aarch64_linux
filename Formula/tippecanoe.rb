class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.9.15.tar.gz"
  sha256 "e58cac588842a5f70d263d0e9b2eb940e32b06ab3c6560bbd650059484bab184"

  bottle do
    cellar :any
    sha256 "0afa03d0a09f178834537301c42f91b9235c7a7e7849e6526633927ff6cf18ef" => :el_capitan
    sha256 "54505632c32d8bc698c392508d82e68fce3ba249b04da8df5d5ef8f40f793b92" => :yosemite
    sha256 "0f0253a1d1bb08a368c9f8c95f7b757e9aa7f6b20e8dfa03dcb95cc63ecb8abe" => :mavericks
  end

  depends_on "protobuf-c"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert File.exist?("#{testpath}/test.mbtiles"), "tippecanoe generated no output!"
  end
end
