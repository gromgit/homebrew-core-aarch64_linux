class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "14045272aa0157dc5fde1cfe885fecc2703f3bf33506603f2922cdf28310ebf0"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "963d5a8cb653d299053cee34147a8621cdf52b4ab6a35466280c33d8b8bbb459"
    sha256 cellar: :any,                 arm64_big_sur:  "06e48ad84bf09388bbd6f9b7ba1d74f37d25e6cd88f5a654ecb3ca94382aa284"
    sha256 cellar: :any,                 monterey:       "de268561471e84f0da4246e0ae1b164eefccc7d3605378f6abff9cf68a6ce6d1"
    sha256 cellar: :any,                 big_sur:        "414b866d127e3b9a14cb7493c9eacf1caf125db4b12f06d762e9b46a4eaa7656"
    sha256 cellar: :any,                 catalina:       "de962f20d642f3896ec67d03e77ab44994568a164029c1f9dc22b45491994c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcd5668ebd62fd0883cceec35a34ff47aeb04302ab5c20f8885f4076e8b14646"
  end

  depends_on "go" => :build
  depends_on "osmium-tool" => :test
  depends_on "geos"
  depends_on "leveldb"

  def install
    ENV["CGO_LDFLAGS"] = "-L#{Formula["geos"].opt_lib} -L#{Formula["leveldb"].opt_lib}"
    ENV["CGO_CFLAGS"] = "-I#{Formula["geos"].opt_include} -I#{Formula["leveldb"].opt_include}"

    ldflags = "-X github.com/omniscale/imposm3.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"imposm"), "cmd/imposm/main.go"
  end

  test do
    (testpath/"sample.osm.xml").write <<~EOS
      <?xml version='1.0' encoding='UTF-8'?>
      <osm version="0.6">
        <bounds minlat="51.498" minlon="7.579" maxlat="51.499" maxlon="7.58"/>
      </osm>
    EOS

    (testpath/"mapping.yml").write <<~EOS
      tables:
        admin:
          columns:
          - name: osm_id
            type: id
          - name: geometry
            type: geometry
          - key: name
            name: name
            type: string
          - name: type
            type: mapping_value
          - key: admin_level
            name: admin_level
            type: integer
          mapping:
            boundary:
            - administrative
          type: polygon
    EOS

    assert_match version.to_s, shell_output("#{bin}/imposm version").chomp

    system "osmium", "cat", testpath/"sample.osm.xml", "-o", "sample.osm.pbf"
    system "imposm", "import", "-read", testpath/"sample.osm.pbf", "-mapping", testpath/"mapping.yml",
            "-cachedir", testpath/"cache"

    assert_predicate testpath/"cache/coords/LOG", :exist?
    assert_predicate testpath/"cache/nodes/LOG", :exist?
    assert_predicate testpath/"cache/relations/LOG", :exist?
    assert_predicate testpath/"cache/ways/LOG", :exist?
  end
end
