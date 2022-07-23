class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.0.2.tar.gz"
  sha256 "4d844ee3a216da8c2aa720adb936d8364280439f9839f8cd6eca59d91321f742"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57f1d0bf072f1a5fbc4f45b97c08c5753d652dd9c5083c4e1b7d9878c0b8ec55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6483cd942b61c2d5142a979f402ebdeb37287ed10f024aca744001ddd4582a14"
    sha256 cellar: :any_skip_relocation, monterey:       "4af2cb885986eabd50dab8e2bfac7ad451336b0d220425c21074ad2982284576"
    sha256 cellar: :any_skip_relocation, big_sur:        "e22531f02ff7ae42d82791a233ea0a172d43f052b6fec06d5aa1a7a6c2caf4b3"
    sha256 cellar: :any_skip_relocation, catalina:       "20c9d4b37d85edd9ef8f8b2207daa0035e28a13c7b30b6d1cd6ac48b4b0c99c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fd405e35b90734570b3fc0c53e6776a9ef0c99f6d7524b07d2718e815b9ae63"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bin.install_symlink "lean" => "tds"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Invalid access token.", shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
  end
end
