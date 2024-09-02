class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.26.1.tar.gz"
  sha256 "44c90753cf4c1b6e7fb82074c6701fd4b47dc6dc26fe4e5504dcccb4d273b946"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dasel"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c25b988dafa8d5f853d510e695f19192852b918e53d2dd370cd9d242cb5e1ab7"
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
