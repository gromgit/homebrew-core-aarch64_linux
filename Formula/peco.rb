class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "781c2effc4f6a58d9ff96fb0fc8b0fba3aab56a91a34933d68c5de3aea5fe3f6"
  license "MIT"
  head "https://github.com/peco/peco.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/peco"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "28c07ea479eddff811e1321d400cc88ce87d5259a8b53fc80d7dcc650c8ca78f"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    system "go", "build", *std_go_args, "cmd/peco/peco.go"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
