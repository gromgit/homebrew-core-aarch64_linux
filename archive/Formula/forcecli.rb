class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.33.0.tar.gz"
  sha256 "d8ab631475c9080339d1e96410ad84ea26377fa3d0662d3903f05030f929860d"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/forcecli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e004894ec51b7b8540f9b9ad681f75f4cd383a027e04169f5326a4a5a93170e0"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
