class Wego < Formula
  desc "Weather app for the terminal"
  homepage "https://github.com/schachmat/wego"
  url "https://github.com/schachmat/wego/archive/2.1.tar.gz"
  sha256 "cebfa622789aa8e7045657d81754cb502ba189f4b4bebd1a95192528e06969a6"
  license "ISC"
  head "https://github.com/schachmat/wego.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wego"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cb20fd1ce8db0c124476a867e53d5c05aa93f205bcee4690b78e6607e96a14d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["WEGORC"] = testpath/".wegorc"
    assert_match(/No .*API key specified./, shell_output("#{bin}/wego 2>&1", 1))
  end
end
