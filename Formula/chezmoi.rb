class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/v1.8.0.tar.gz"
  sha256 "b55289372b0e419d9e759f3193cca366a0ae1de2bd72f523d49a0e8ca8567a47"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55192586a5d4287885b7a2de6fd94dd002f074480ec99077ca0215b5d255ae0b" => :catalina
    sha256 "08a42d8e4fc5920be533353ae3a7701bd45ebe6da8370ea7aa02e287c2de2f34" => :mojave
    sha256 "f3d02bc4834d30f8100054ea90d6fe45133bde1d431a052fa1dfa591ef5cad0b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"

    system "make", "completions"
    bash_completion.install "completions/chezmoi-completion.bash"
    zsh_completion.install "completions/chezmoi.zsh"

    prefix.install_metafiles
  end

  test do
    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
