class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.8.tar.gz"
  sha256 "b3ac1ab35ce4716290ad40898b3227b4b18197f8068a8f03fb1069231e60104e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b12d57706fd28dc01dfa8b4841d57fbe084180a81c7de6717276d329dce5144"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "464654c8411fcbba1cb390d7bd3f5ecd43b7d78bf84eb493837834867d0d6522"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4718db4b6a93a6bdaebddaac8c8e8d3e5ade455721bb07f788e0ae343e6b969"
    sha256 cellar: :any_skip_relocation, monterey:       "74dc9897f3cf9a8d52777caf26f06648c7d2fb7a542274d5b137481eaabae76e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e91f0646ea67e1fd10b00e748c5c8b6e513e91a0a93f088dac06c4921f2382d"
    sha256 cellar: :any_skip_relocation, catalina:       "acde9cba8e397722e8ae2abf595fb22caeadac38165117737c37108911356b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4a3b5e060916d8a5eb44c32c98d9a710a6d6538e968c19a08d69d44b5f0fee"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
