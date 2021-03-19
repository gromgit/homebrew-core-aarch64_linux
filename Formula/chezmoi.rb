class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.2",
      revision: "f5a63291beaf3b3b18dc93890d9d08ad5558f2ec"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c92f1219739806683c63efeb8a41be13dbccc34070416785fd7bd39df05acb40"
    sha256 cellar: :any_skip_relocation, big_sur:       "59ab217cd27d3b1af20b18e35782ec36934080b9b6dd407b6ddf1d49c21a7944"
    sha256 cellar: :any_skip_relocation, catalina:      "33db8ca241db0059ea63a2de09ce555bbd425216df5039b303a90d904856a514"
    sha256 cellar: :any_skip_relocation, mojave:        "f5b86eff475e03c701cb323da0b68d7f9e9f02f611fa0a6d53dd0949274c9623"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
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
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
