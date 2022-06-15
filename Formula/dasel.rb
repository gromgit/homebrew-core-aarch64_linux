class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.24.3.tar.gz"
  sha256 "86d497e7dcfe63901ef0aeddb31e3989959d60d785a04f98fc6a88b6f497980a"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dasel"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ebea8d00d8911dcb2d967eba1d9268909d9bebbfba94e0c48a61dc883ae169af"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
