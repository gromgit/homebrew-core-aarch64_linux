class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.22.1.tar.gz"
  sha256 "cef2766e41a21eadf8b6a00e467bfb2c9234373d5cc52a272100cefed99a2380"
  license "BSD-4-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/scalingo"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1c34f63ce4447fe3e7c6bff27a46bffe6e2e6b1229ac43fc88e76a0926e63ae4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
