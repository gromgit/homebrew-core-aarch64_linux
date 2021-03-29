class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.7.tar.gz"
  sha256 "1012443e266d64bfb15a8651c96f02255221644731a17c543c30f8e2798b0aab"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b4b9269eb124f07100faf26eee1beff27e77aac3435c78a9ea8399b38801a86"
    sha256 cellar: :any_skip_relocation, big_sur:       "d75a38323372399c75b1bb71b68e27c92eb42613dec35d72d3e6c85f3618689c"
    sha256 cellar: :any_skip_relocation, catalina:      "01d1102c0288a7657a24932f29a8573ed460ae06247c21d336aa871bdf032a10"
    sha256 cellar: :any_skip_relocation, mojave:        "e0c6f01b3349130f19748dff15a63ca90aa53aa10ff0451cc4cd1de6bcd9b61c"
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
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
