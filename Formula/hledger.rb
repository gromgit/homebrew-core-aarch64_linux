class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.27.tar.gz"
  sha256 "1a3d1d321cf5fb9ae6d214a5a4a71775680a8146cf43f77e523a2e6c0af9d366"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebcc1a998bc9c53e7c95b3557de5e6e700ff7c6b74e16e8e6437b489b71aed25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e78f193336015a689c750c4dd47146b7b64702cf917fb63e254c339b4164224"
    sha256 cellar: :any_skip_relocation, monterey:       "e4ce7beb81a718088d3eb8000af6b59346dfc75ae96d8853371dfecb5c3bf4cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bb1db3834b408cb69de73bcd145b96288376954b2f3550f3ddc6cd2435a4636"
    sha256 cellar: :any_skip_relocation, catalina:       "7988b267077ef989ed75e087e7de236600c3f4c9142fdddc9d910c2eb0545b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed094477cf1939f94ceabd79d3103625f310dd7d216e98b0e2624141c28aa2aa"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger*/*.1"]
    info.install Dir["hledger*/*.info"]
    bash_completion.install "hledger/shell-completion/hledger-completion.bash" => "hledger"
  end

  test do
    system bin/"hledger", "test"
    system bin/"hledger-ui", "--version"
    system bin/"hledger-web", "--test"
  end
end
