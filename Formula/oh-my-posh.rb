class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.71.0.tar.gz"
  sha256 "f790bbc7cd18f91b4e56e046a2788034dc983d975bdd2c427b0fa47255413847"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ff05a8c9b3abfcc78d8542676c277681a38292234eb0f83dcd721bd9dc3fbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3f351ed8f5f8aeef20162562547d8d62925c75c8068b344abb46d1244f8db92"
    sha256 cellar: :any_skip_relocation, monterey:       "1d0ba4807cba51daff0efb71a6931d9bb2a62b571f9567d8135cb42072129549"
    sha256 cellar: :any_skip_relocation, big_sur:        "f703c20e043963be98b32aaaf566127400affe5ed465c6e51853447448578f2f"
    sha256 cellar: :any_skip_relocation, catalina:       "c1a6944b2f4b9e8ee0ebcad5cd1bf8a4acaad1345f0fa545831c86239ffed444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c2cc317f9630a368e4ab772a8947ad8c6fcb06534a23fb7fd48dd37ea20608"
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
