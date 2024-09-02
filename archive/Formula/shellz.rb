class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://github.com/evilsocket/shellz/archive/v1.6.0.tar.gz"
  sha256 "3a89e3d573563a0c2ccb1831ff41fc0204c8b4efb011c10108ab98451a309b1c"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/shellz"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "606b1374370864b03d39a50482977775c64efbc88a78d55d4c9a41deea7411fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shellz"
  end

  test do
    output = shell_output("#{bin}/shellz -no-banner -no-effects -path #{testpath}", 1)
    assert_match "creating", output
    assert_predicate testpath/"shells", :exist?
  end
end
