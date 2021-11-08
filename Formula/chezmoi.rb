class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.7.5",
      revision: "53bb61524468afe3262d6d8089fdc6912dbccb34"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c80497a75cafeec03996995ac553b1946fcca3b9de50fbde6046a45d5b174e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ec5947a540c60bfc486de3055b4a5441652d3686e7bf8d1d5fdefc17b336fee"
    sha256 cellar: :any_skip_relocation, monterey:       "ca20720fc98ab56d2fac905a4b263708a4b0587cc395ec28b109eae4db80bbb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "132785d3d56942f81318c1f62f5c416e8076b5d1f46f0ff72238fc6945dc32a8"
    sha256 cellar: :any_skip_relocation, catalina:       "2bd802f1aa41bb9517cb8e7efa5ab5dfb49b351736a083261a580ac357f78f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5db350f1514c37642741584f34fc5c2349d31b035a82b9adb014ba5a8a17199"
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
