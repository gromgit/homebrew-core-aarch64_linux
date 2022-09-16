class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.14.0.tar.gz"
  sha256 "67765fe6b612e791aab276af601dd12410b70486946e983753f6b0442f915233"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a822b931250081419f53ad441a89076a64411e5971e091387a92476860204806"
    sha256 cellar: :any,                 arm64_big_sur:  "9dd563705ceb2f2837d4f5df511e5b3d13cf1409968b1fdcae991ef0a381e6e2"
    sha256 cellar: :any,                 monterey:       "c10c02bea8013843e94222ae833e64b2ea61a4287d60e386b8c1a560baf978b2"
    sha256 cellar: :any,                 big_sur:        "bd7ed40d240f593ddeab17dbaceb9f06b8d14f870a3e3f07872228a56d7622fc"
    sha256 cellar: :any,                 catalina:       "5b67d83929194c424ff1929a3e4a019607409ac650a04bd97d9a7e58f169d0d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28c587bd9003d6b08adbf08ae8cb15548184f1b1995032542166fce7d213c2d5"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "pandoc" => :build
  depends_on "boost"
  depends_on "lz4"

  uses_from_macos "expat"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.osm").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="handwritten">
        <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <nd ref="1"/>
          <nd ref="2"/>
          <tag k="name" v="line"/>
        </way>
        <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <member type="node" ref="1" role=""/>
          <member type="way" ref="1" role=""/>
        </relation>
      </osm>
    EOS
    output = shell_output("#{bin}/osmium fileinfo test.osm")
    assert_match(/Compression.+generator=handwritten/m, output)
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end
