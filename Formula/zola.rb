class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.12.0.tar.gz"
  sha256 "d76b380189ddf9fa7ac3243aac8f47f38fb754b4c39f424a00d961c68f9dcd59"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "74f1a61560783117b70c2dcd9e962e70739d86a7185099b79684faed1a9506b5" => :catalina
    sha256 "58b73515856df5385cc960bfdb8871e948594c50a2dc50dae3ad17463e4922c4" => :mojave
    sha256 "316bc92a2962c51801f71f16fb250d6e1983afce289e390936b147943cc16127" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/zola.bash"
    zsh_completion.install "completions/_zola"
    fish_completion.install "completions/zola.fish"
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath/"mysite/templates/page.html").write <<~EOS
      {{ page.content | safe }}
    EOS

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end
