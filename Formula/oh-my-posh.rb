class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.85.2.tar.gz"
  sha256 "40c6463f37ee67933214527c9ee8274db9e1aa0e9c90e3fd54baab5f1c58b3f5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e53eb976fdc2f4e0fe03e64e875f6098bb3a3150c31d1c2d306b6bafcf7ef7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "196b358bf37db38ac2493be6b21c4b88c9df63c84403b7f6bb424d409a299727"
    sha256 cellar: :any_skip_relocation, monterey:       "4df4726e4cd419d38ed8301b2015e3de28a1c848c6082b0166997a596333db0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "54d67cb5b213c766cf3cc71d43c4a90aa0ed07d8cc0397f272afb02c2307a042"
    sha256 cellar: :any_skip_relocation, catalina:       "2a018cdc7e284e16e27c0201ff87c088773d97b26c6504472cf6ebdf9536cbc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa169a37676ffa75f1f1ba0970406d260d5cddcb877b124c8b5ea79c134f2ba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
