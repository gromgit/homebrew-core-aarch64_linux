class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.2.tar.gz"
  sha256 "a216fc96cc80c65ed72a1b50f77697c2d6cb18f4cb849d8dde67f65d24951adc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gitbackup"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4044ef8bd1fcaf99907cc90582937cec51d12783aa34fd6f25b05478658ed548"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
