class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v1.2/stgit-1.2.tar.gz"
  sha256 "2042bb69c2e978ea7d8aad60c47001e7ce4e928ec56e7d2bfb99aaac5f740b4e"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfe9a7b2c285fbef18c85bd830494b9cf84218451d407ebf129e1eb7b91fb113"
    sha256 cellar: :any_skip_relocation, big_sur:       "a41c81093c1fe1ef8cfcd326805ee650b2acc307324fed6931ce32346d5b1849"
    sha256 cellar: :any_skip_relocation, catalina:      "a41c81093c1fe1ef8cfcd326805ee650b2acc307324fed6931ce32346d5b1849"
    sha256 cellar: :any_skip_relocation, mojave:        "a41c81093c1fe1ef8cfcd326805ee650b2acc307324fed6931ce32346d5b1849"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "python@3.9"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-doc"
    bash_completion.install "completion/stgit.bash"
    fish_completion.install "completion/stg.fish"
    zsh_completion.install "completion/stgit.zsh" => "_stgit"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
  end
end
