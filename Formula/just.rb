class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.9.0.tar.gz"
  sha256 "3f2a2cd532dffd978ea28817a909b3ccbe09837380f014eed615ec8557302cec"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4727d5f0e260127fd304cabab76c143125a551183ac2d2edb9cd545404e90b6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36deb2db553afc77013b5cb147e59797c80b0fad78a777be3bbb29fef67d3b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b97c3fa020eef11cc10057acda77821125a540580714fb16324d30a18baa70a"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e4484843b6db0d75889e190115ea3d8e0535c644816258ba9a6fc7665f9006"
    sha256 cellar: :any_skip_relocation, monterey:       "44229bcee3df7217a984d994878544d75b64e97c4b011951c2d42108cec3943d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b60fc285d141729f148996bf81e1760a0a74bbd2e4c5a88d78409a4e1cef0ef1"
    sha256 cellar: :any_skip_relocation, catalina:       "bee6f3ed7ec708aa9f1473ab35ab12cd711f3bf9674fcd4c15d205eabd3574bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f56a5865e13a8b9488e95f07934a19d618960a69542d7aaa7bd2a7652439c4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
