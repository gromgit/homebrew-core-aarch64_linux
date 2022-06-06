class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/24.0.0.tar.gz"
  sha256 "43682e6b189a84602930b9fb09a87af400359a9e97a4bb8e1119688c53fad9fd"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fx"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6a1a9f5f2bfad4c6dd25ed960906c79aa8c38f190725d03169e1684eb3fbf8d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output(bin/"fx", 42).strip
  end
end
