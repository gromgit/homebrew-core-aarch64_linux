class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-c-client/archive/v1.4.2.tar.gz"
  sha256 "532cc30b21ea146d23ba880142ae284bd2774c27c247ecc00221d9434bd9343f"
  license "MIT"
  head "https://github.com/tldr-pages/tldr-c-client.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d222a054caa471a81fa51dabcee45b65d4488c59c3b7b2ec099161259844b27b"
    sha256 cellar: :any,                 arm64_big_sur:  "2765c6c23e565a7f0f81fde477ad6d9942b9dcb1b81ac74a81a46630dbaac59f"
    sha256 cellar: :any,                 monterey:       "a53f48f03a7729b9687ae7516956c77e551d636f015d41e4b8d021ea9f5c19ea"
    sha256 cellar: :any,                 big_sur:        "8591a53b59312eafd7b3829d0f08e6f4cc3a1cb1048f275828d0a98664dfc1ab"
    sha256 cellar: :any,                 catalina:       "6cfce860468cd9b2aa4a1db7d03cc989421666cdc2b55a041e1eb5f032fb2e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a18c2d06e7fccdcabb376be4320e41d261db3e4cbe8a56ac05ca6757959adcd"
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  uses_from_macos "curl"

  conflicts_with "tealdeer", because: "both install `tldr` binaries"

  def install
    system "make", "PREFIX=#{prefix}", "install"

    bash_completion.install "autocomplete/complete.bash" => "tldr"
    zsh_completion.install "autocomplete/complete.zsh" => "_tldr"
    fish_completion.install "autocomplete/complete.fish" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
