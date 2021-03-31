class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.7",
      revision: "1ce19442a526747d53317a4cd5764f4e4a60a216"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0a74997b936fcb7a8f1bc20a44017a969f5117bb63eee12eff15c7463eae932"
    sha256 cellar: :any_skip_relocation, big_sur:       "67e06b0a11870acbdbd39ed6bc5874485663fddab46cc80e86b55543dcf6d4cb"
    sha256 cellar: :any_skip_relocation, catalina:      "eff19428beac963ae024a527b10655b6c5c09e5537c98fdc043e011ba0d03732"
    sha256 cellar: :any_skip_relocation, mojave:        "0a0b16fda39952f86467c9a57ba7d6fd902646aa2197f8025cf9e706825c0e51"
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
