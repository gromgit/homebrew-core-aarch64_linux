class C14Cli < Formula
  desc "Manage your Online C14 archives from the command-line"
  homepage "https://github.com/scaleway/c14-cli"
  url "https://github.com/scaleway/c14-cli/archive/v0.5.0.tar.gz"
  sha256 "b93960ee3ba516a91df9f81cf9b258858f8b5da6238d44a339966a5636643cb2"
  license "MIT"
  head "https://github.com/scaleway/c14-cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/c14-cli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1081843302b74daa5ae37f29b54747581aa02353d14352ccb91d367782e1ac79"
  end

  # "C14 Classic has been discontinued"
  deprecate! date: "2020-12-01", because: :repo_archived

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"c14",
           "-ldflags", "-X github.com/online-net/c14-cli/pkg/version.GITCOMMIT=homebrew",
           "./cmd/c14/"
  end

  test do
    output = shell_output(bin/"c14 help")
    assert_match "Interact with C14 from the command line.", output
  end
end
