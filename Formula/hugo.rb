class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.79.1.tar.gz"
  sha256 "2d4d387251e9970c514577f92b55a100ff3f0fe7e177e5cc4e7661a8b996b9da"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "276cb57cf2e4d0a3ff1a7160043578d8c743d2b35f6aa7777b6772641acb0cf5" => :big_sur
    sha256 "9a177a3e54867523f10c44522cda5c3666fd80cbdfb4238d0ca0fc2bf9684ac7" => :catalina
    sha256 "afee3eeab8930928a9b7656f09826dc2be8dbcd112558a40ca08f304f3e07e00" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-tags", "extended"

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
