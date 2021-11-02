class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.89.0.tar.gz"
  sha256 "0fbee83dd04927b6c467caad245cf3159463c5114e0624edc1536f75e4c6cf17"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "951421a05a55b2ccc041900739d3cd7e4549dc3800b4c88c870f38d2346115e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b53f2bf2d3d1e760b4f49ab0c5ea9e91026b5d5d447802f022a96d9397f6682"
    sha256 cellar: :any_skip_relocation, catalina:      "801775c0bca3a021263256484e80ec3ed52b6f7565d878b5b95207af8f74c1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71fe6ed2f883c4fc3cf79682b59ea9141d7b9df85cfc570077fcde229a235d0a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
    bash_completion.install "hugo.sh"

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
