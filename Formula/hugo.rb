class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.88.0.tar.gz"
  sha256 "76b5a5393bbb2983697b1c0b32926d6d3510113ce8de7c66f6509371439ff383"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd1ca3fbc1333943661d07c2191d0a0d4fbd20f9cbe33eec1edeb42855306f41"
    sha256 cellar: :any_skip_relocation, big_sur:       "40bee49ace32384e3a9ff3f4badad20c4d9c1a73b67aff1e40bf6d35b319ed92"
    sha256 cellar: :any_skip_relocation, catalina:      "85d855b5b7bca20ae91156cfd9527b211a0dfab8744b037cb6d21640ac7dd8af"
    sha256 cellar: :any_skip_relocation, mojave:        "6b8be49bc103d50f4b12cb8b871c4bc9e11d2567447885cac2f5c65dd949eb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b6767076c6e32447e5164f619d6aa4785e175244b95c24d71c889782a832d0"
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
