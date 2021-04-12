class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.14.0.tar.gz"
  sha256 "b12f2a6d680d63a54b736c308ca4b040f57dd4b1bc9b0a0e75fe0f32de3b5847"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea5dba645e69331c5053943da0c734a05616abf09b3952c98dfcc74406d81e86"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3cdd166ef14bfd26e371b8f0d53d1890a4007daf12e673daf099a46b8dc45f2"
    sha256 cellar: :any_skip_relocation, catalina:      "b2f1bd818158566caf8c25c77acc2ac6a889022f5338f7d32ab02cc54f3575bc"
    sha256 cellar: :any_skip_relocation, mojave:        "dfc4db26a1ebcac490026cf5549ed2765ca4c31f4ac96bf3badbd4918ee5fb4d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
