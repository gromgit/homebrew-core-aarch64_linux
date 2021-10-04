class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.6.1",
      revision: "8d9a89b0c131e69fc97ecbb2279558e2930ae9e1"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4f669c04e7036641df6efb61c10b849e1fd88d46ad09d8e4e8d21d99690bd015"
    sha256 cellar: :any_skip_relocation, big_sur:       "93e014f0ba2768c04df1687f6b1acdd517beee72ae7767c1baaa302f1a6c6e34"
    sha256 cellar: :any_skip_relocation, catalina:      "d8ed2b58fa685f1b568c36d4d089e6cb6340c5f97872d9103a3c5a12bf1239dd"
    sha256 cellar: :any_skip_relocation, mojave:        "7a5542ca729acb5d9d8c87c8c28aa167efc5287ab7968dd55ec545b1f0f9a59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9946edf160870acd9bebeac457382bc62a2704cc6e75269ce571820141b3c6e1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ].join(" ")
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
