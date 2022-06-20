class Armor < Formula
  desc "Uncomplicated, modern HTTP server"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.4.14.tar.gz"
  sha256 "bcaee0eaa1ef29ef439d5235b955516871c88d67c3ec5191e3421f65e364e4b8"
  license "MIT"
  head "https://github.com/labstack/armor.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/armor"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bc82d9c87e1446ac78f471ed465d8e6fde29345c69de534d01c621e1bf46ec64"
  end

  deprecate! date: "2022-03-16", because: :unmaintained

  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/armor/main.go"
    prefix.install_metafiles
  end

  test do
    port = free_port
    fork do
      exec "#{bin}/armor --port #{port}"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}")
  end
end
