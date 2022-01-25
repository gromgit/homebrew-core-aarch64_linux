class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "090748b5f9cf5a539e22963ae9e34a0edb782e10cbde06b60570fffe795fc212"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c6955fa775064e5aff420c98d918b06d5cb98b38b092b2f186dc02f5f8e6983"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c6955fa775064e5aff420c98d918b06d5cb98b38b092b2f186dc02f5f8e6983"
    sha256 cellar: :any_skip_relocation, monterey:       "48dff0da3afb423d03d477ff2c7ac122efb6ed81a30ad6806c44634dceae57bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "48dff0da3afb423d03d477ff2c7ac122efb6ed81a30ad6806c44634dceae57bc"
    sha256 cellar: :any_skip_relocation, catalina:       "48dff0da3afb423d03d477ff2c7ac122efb6ed81a30ad6806c44634dceae57bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6132eaf879f24bf5c0c83d01cc6aced6751ec571a9927950540b11cb821372c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
