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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2c3ef744bf7a4068401082afcc7f516b95b04fefa5f112dd52c84316cf884d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42674338ee571f5596b600908a765aec0911ff737de12ba9842bbfd6523a5060"
    sha256 cellar: :any_skip_relocation, monterey:       "3b37e97b8c963a64fa459fc3b89b5dc989e9b7ae4d1e4a89ce48cdd9b560a6e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf6fd65c4fc31e0a048c285ac9186b265febdfb8ecbe3ad726d9d611743f5384"
    sha256 cellar: :any_skip_relocation, catalina:       "8830b28f1ad6b581e5d0093dd79226c4f01a8c42c922d16aacdbaafc990528de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c5cedfe3a02b5bc598c33a64d89b947e769c0c48ce2df7c9709c9311f22fb9"
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
