class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.22.1",
      revision: "64b9c1fa7346526c17d5073827fe055dc46f6c09"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5341ff341fd9d979c8122c9056399c6e29fefb9911ef20184b57dc91479f14df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "915d17c07b230185e8cb34ee2f9d68d176ff7b7bf3c7bc8c8f4521c48897d26a"
    sha256 cellar: :any_skip_relocation, monterey:       "bc24354893e163602466089257e6a7c32225f102179b43941c512c2c3ed8a635"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c28c589a5a9c5d6f9791e245dbad047928df0a9f6804060a662c0d18018a286"
    sha256 cellar: :any_skip_relocation, catalina:       "ab69a7e1c7d0c23a58a27eee2c44f0f2d07e34992df3672895190e9f0dcb4497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d91ec5ebddf6747c8731aed3442a663e4e327a42fb5654ebe7056746127546"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
