class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.21.0.tar.gz"
  sha256 "0ccf1375ee3c20508c37de288a46faa6b0e4dffb3a3749f4b699a30f95e861be"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/stern"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7e533acfa6771d62b190bdb55b13bb8c8d9d45edf1fd276c6c6704606475c3f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=fish")
    (fish_completion/"stern.fish").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
