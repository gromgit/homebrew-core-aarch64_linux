class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v1.8.8",
      revision: "71e82dbbdcd516286100596ca7ddff023b5a07ca"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5056d11f7b277541fcccf0e006c2c748b7e771f454fb48cbf1baeda0a0412cb" => :big_sur
    sha256 "d8943c663fe4c753b9aaf62dd493058d233cb7ab9e4880cc34749da748c9efce" => :catalina
    sha256 "34725bf9c5c4cfd5706b33d89f18497370c99f6061738205dfc1652825eba435" => :mojave
    sha256 "036f16a1354e6c8bbe7da3826d0a137109458b6f27c1e30c427c0ad0c43cc024" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
      -X main.date=#{Time.now.utc.rfc3339}
      -X main.builtBy=homebrew
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version #{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
