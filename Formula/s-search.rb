class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.2.tar.gz"
  sha256 "acc38953fcb21e1dd2cd761b9d2bf8272aa6aa30fed2adb657f2dba7e4df872f"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa5f506a14583c6975f47d32c06b29a82ff544876b379253641f5c8ab010cf36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51d3f2cff22cdb7d5a628d914539841de6d67facaccb521b0df2d2991986ba1a"
    sha256 cellar: :any_skip_relocation, monterey:       "b46e4c7f53872481620da20234184f20f6294e049e777843f7e24581aa7f712f"
    sha256 cellar: :any_skip_relocation, big_sur:        "03c101309a9410d4a30e85f3abf0ecc7badd1f6ae002b80c44a1de6fc66d44d6"
    sha256 cellar: :any_skip_relocation, catalina:       "5987f1d6d6f3a69108d58cb5012f4a17c619be496a9abe4749c0c481d96772a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1523a33ed2d89dba192084da67bdd21b3c46c9082dbf2fe97cb82a5802e5af6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"s"

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "bash")
    (bash_completion/"s-completion.bash").write output

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "zsh")
    (zsh_completion/"_s").write output

    output = Utils.safe_popen_read("#{bin}/s", "--completion", "fish")
    (fish_completion/"s.fish").write output
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
