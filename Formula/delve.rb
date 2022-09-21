class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.8.3.tar.gz"
  sha256 "b18dc56de8768da055125663e7c368ecf24cdac4d72d9080ac90dc0ee99ea852"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/delve"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "516f3b2e6ce9f528f956c399337cfc07cbd9cfac733165ada4a18fe8cdaaeb94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
